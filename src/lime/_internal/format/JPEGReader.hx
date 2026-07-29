package lime._internal.format;

import haxe.io.Bytes;

class JPEGReader
{
	public var width:Int = 0;
	public var height:Int = 0;
	public var pixels:Bytes; // RGBA

	static var ZIGZAG:Array<Int> = [
		0, 1, 8, 16, 9, 2, 3, 10,
		17, 24, 32, 25, 18, 11, 4, 5,
		12, 19, 26, 33, 40, 48, 41, 34,
		27, 20, 13, 6, 7, 14, 21, 28,
		35, 42, 49, 56, 57, 50, 43, 36,
		29, 22, 15, 23, 30, 37, 44, 51,
		58, 59, 52, 45, 38, 31, 39, 46,
		53, 60, 61, 54, 47, 55, 62, 63
	];

	static var cosTable:Array<Float> = buildCosTable();

	var data:Bytes;
	var offset:Int = 0;
	var len:Int;

	var bitsData:Int = 0;
	var bitsCount:Int = 0;
	var eof:Bool = false;

	var quant:Array<Array<Int>> = []; // [tableId] -> 64 ints, ZIGZAG order
	var huffDC:Array<HuffNode> = [];
	var huffAC:Array<HuffNode> = [];
	var components:Array<Component> = [];
	var restartInterval:Int = 0;
	var maxH:Int = 1;
	var maxV:Int = 1;
	var mcusPerLine:Int = 0;
	var mcusPerColumn:Int = 0;

	var tmp:Array<Float> = [for (i in 0...64) 0.0];

	public static function decode(bytes:Bytes):JPEGReader
	{
		var j = new JPEGReader();
		j.parse(bytes);
		return j;
	}

	function new() {}


	inline function u16():Int
	{
		var v = (data.get(offset) << 8) | data.get(offset + 1);
		offset += 2;
		return v;
	}

	function parse(bytes:Bytes):Void
	{
		data = bytes;
		len = bytes.length;
		offset = 0;

		if (u16() != 0xFFD8) throw "JPEG: missing SOI";

		var marker = u16();
		while (marker != 0xFFD9 && offset < len) // EOI
		{
			switch (marker)
			{
				case 0xFFC0, 0xFFC1: // SOF0 baseline / SOF1 extended sequential
					parseSOF();
				case 0xFFC2:
					throw "JPEG: progressive (SOF2) not supported";
				case 0xFFC4: // DHT
					parseDHT();
				case 0xFFDB: // DQT
					parseDQT();
				case 0xFFDD: // DRI
					u16(); // length (=4)
					restartInterval = u16();
				case 0xFFDA: // SOS
					parseSOSAndScan();
				default:
					if (marker >= 0xFFD0 && marker <= 0xFFD7)
					{
					}
					else if ((marker & 0xFF00) != 0xFF00)
					{
						break; // desync — bail
					}
					else
					{
						var segLen = u16();
						offset += segLen - 2;
					}
			}
			if (offset + 2 > len) break;
			marker = u16();
		}

		if (width == 0 || height == 0) throw "JPEG: no frame";
		output();
	}

	function parseSOF():Void
	{
		u16(); // length
		var precision = data.get(offset++);
		if (precision != 8) throw "JPEG: only 8-bit supported";
		height = u16();
		width = u16();
		var n = data.get(offset++);
		maxH = 1;
		maxV = 1;
		for (i in 0...n)
		{
			var id = data.get(offset++);
			var hv = data.get(offset++);
			var h = hv >> 4, v = hv & 15;
			var q = data.get(offset++);
			if (h > maxH) maxH = h;
			if (v > maxV) maxV = v;
			components.push(new Component(id, h, v, q));
		}

		mcusPerLine = Math.ceil(width / (8 * maxH));
		mcusPerColumn = Math.ceil(height / (8 * maxV));

		for (c in components)
		{
			c.planeW = mcusPerLine * c.h * 8;
			c.planeH = mcusPerColumn * c.v * 8;
			c.samples = Bytes.alloc(c.planeW * c.planeH);
		}
	}

	function parseDQT():Void
	{
		var segEnd = offset + u16() - 2;
		while (offset < segEnd)
		{
			var pq_tq = data.get(offset++);
			var pq = pq_tq >> 4; // 0 = 8-bit, 1 = 16-bit
			var tq = pq_tq & 15;
			var table = new Array<Int>();
			for (k in 0...64) table.push(pq == 0 ? data.get(offset++) : u16());
			quant[tq] = table;
		}
	}

	function parseDHT():Void
	{
		var segEnd = offset + u16() - 2;
		while (offset < segEnd)
		{
			var tc_th = data.get(offset++);
			var tc = tc_th >> 4; // 0 = DC, 1 = AC
			var th = tc_th & 15;
			var counts = new Array<Int>();
			var total = 0;
			for (i in 0...16)
			{
				var c = data.get(offset++);
				counts.push(c);
				total += c;
			}
			var values = new Array<Int>();
			for (i in 0...total) values.push(data.get(offset++));
			var root = buildHuffman(counts, values);
			if (tc == 0) huffDC[th] = root; else huffAC[th] = root;
		}
	}

	function buildHuffman(counts:Array<Int>, values:Array<Int>):HuffNode
	{
		var root = new HuffNode();
		var code = 0;
		var k = 0;
		for (lenBits in 1...17)
		{
			var n = counts[lenBits - 1];
			for (i in 0...n)
			{
				insertHuffman(root, code, lenBits, values[k]);
				code++;
				k++;
			}
			code <<= 1;
		}
		return root;
	}

	function insertHuffman(root:HuffNode, code:Int, length:Int, value:Int):Void
	{
		var node = root;
		var b = length - 1;
		while (b > 0)
		{
			var bit = (code >> b) & 1;
			if (node.children[bit] == null) node.children[bit] = new HuffNode();
			node = node.children[bit];
			b--;
		}
		var leaf = new HuffNode();
		leaf.isLeaf = true;
		leaf.value = value;
		node.children[code & 1] = leaf;
	}


	function readBit():Int
	{
		if (bitsCount > 0)
		{
			bitsCount--;
			return (bitsData >> bitsCount) & 1;
		}
		if (offset >= len)
		{
			eof = true;
			return 0;
		}
		bitsData = data.get(offset++);
		if (bitsData == 0xFF)
		{
			var b2 = (offset < len) ? data.get(offset++) : 0;
			if (b2 != 0)
			{
				offset -= 2;
				eof = true;
				return 0;
			}
		}
		bitsCount = 7;
		return (bitsData >> 7) & 1;
	}

	function decodeHuff(node:HuffNode):Int
	{
		var n = 0;
		while (!node.isLeaf)
		{
			node = node.children[readBit()];
			if (node == null || ++n > 16)
			{
				eof = true;
				return 0;
			}
		}
		return node.value;
	}

	inline function receive(length:Int):Int
	{
		var n = 0;
		while (length > 0)
		{
			n = (n << 1) | readBit();
			length--;
		}
		return n;
	}

	inline function receiveAndExtend(length:Int):Int
	{
		var n = receive(length);
		return (n < (1 << (length - 1))) ? n - (1 << length) + 1 : n;
	}

	function parseSOSAndScan():Void
	{
		u16(); // length
		var ns = data.get(offset++);
		var scanComps = new Array<Component>();
		for (i in 0...ns)
		{
			var cs = data.get(offset++);
			var td_ta = data.get(offset++);
			var comp = null;
			for (c in components) if (c.id == cs) { comp = c; break; }
			if (comp == null) throw "JPEG: scan references unknown component";
			comp.dcTree = huffDC[td_ta >> 4];
			comp.acTree = huffAC[td_ta & 15];
			scanComps.push(comp);
		}
		offset += 3; // Ss, Se, Ah/Al (ignored for baseline)

		decodeScan(scanComps);
	}

	function decodeScan(scanComps:Array<Component>):Void
	{
		var blk = [for (i in 0...64) 0.0];
		var totalMcu = mcusPerLine * mcusPerColumn;
		var mcu = 0;

		while (mcu < totalMcu)
		{
			for (c in scanComps) c.pred = 0;
			bitsCount = 0;
			eof = false;

			var intervalEnd = (restartInterval != 0) ? mcu + restartInterval : totalMcu;
			if (intervalEnd > totalMcu) intervalEnd = totalMcu;

			while (mcu < intervalEnd)
			{
				var my = Std.int(mcu / mcusPerLine);
				var mx = mcu % mcusPerLine;
				for (c in scanComps)
				{
					for (v in 0...c.v)
					{
						for (h in 0...c.h)
						{
							decodeBlock(c, blk);
							idctStore(c, blk, (mx * c.h + h) * 8, (my * c.v + v) * 8);
						}
					}
				}
				mcu++;
			}

			if (mcu < totalMcu)
			{
				bitsCount = 0;
				if (offset + 1 < len && data.get(offset) == 0xFF)
				{
					var m = data.get(offset + 1);
					if (m >= 0xD0 && m <= 0xD7) offset += 2;
				}
			}
		}
	}

	function decodeBlock(c:Component, blk:Array<Float>):Void
	{
		for (i in 0...64) blk[i] = 0.0;
		var qt = quant[c.quantId];

		var t = decodeHuff(c.dcTree);
		var diff = (t == 0) ? 0 : receiveAndExtend(t);
		c.pred += diff;
		blk[0] = c.pred * qt[0];

		var k = 1;
		while (k < 64)
		{
			var rs = decodeHuff(c.acTree);
			var r = rs >> 4;
			var s = rs & 15;
			if (s == 0)
			{
				if (r == 15) { k += 16; continue; } // ZRL
				break; // EOB
			}
			k += r;
			if (k >= 64) break;
			blk[ZIGZAG[k]] = receiveAndExtend(s) * qt[k];
			k++;
		}
	}

	function idctStore(c:Component, blk:Array<Float>, bx:Int, by:Int):Void
	{
		for (r in 0...8)
		{
			var ro = r * 8;
			for (x in 0...8)
			{
				var s = 0.0;
				for (u in 0...8) s += cosTable[u * 8 + x] * blk[ro + u];
				tmp[ro + x] = s;
			}
		}
		var stride = c.planeW;
		for (x in 0...8)
		{
			for (y in 0...8)
			{
				var s = 0.0;
				for (v in 0...8) s += cosTable[v * 8 + y] * tmp[v * 8 + x];
				var val = Math.round(s) + 128;
				if (val < 0) val = 0 else if (val > 255) val = 255;
				c.samples.set((by + y) * stride + (bx + x), val);
			}
		}
	}

	static function buildCosTable():Array<Float>
	{
		var t = [for (i in 0...64) 0.0];
		for (u in 0...8)
		{
			var cu = (u == 0) ? 0.70710678118654752 : 1.0;
			for (x in 0...8)
			{
				t[u * 8 + x] = cu * Math.cos((2 * x + 1) * u * Math.PI / 16) * 0.5;
			}
		}
		return t;
	}


	function output():Void
	{
		pixels = Bytes.alloc(width * height * 4);
		var nc = components.length;

		if (nc == 1)
		{
			var c0 = components[0];
			for (y in 0...height)
			{
				var sy = Std.int(y * c0.v / maxV);
				for (x in 0...width)
				{
					var Y = c0.samples.get(sy * c0.planeW + Std.int(x * c0.h / maxH));
					var o = (y * width + x) * 4;
					pixels.set(o, Y);
					pixels.set(o + 1, Y);
					pixels.set(o + 2, Y);
					pixels.set(o + 3, 255);
				}
			}
		}
		else
		{
			var c0 = components[0], c1 = components[1], c2 = components[2];
			for (y in 0...height)
			{
				var y0 = Std.int(y * c0.v / maxV), y1 = Std.int(y * c1.v / maxV), y2 = Std.int(y * c2.v / maxV);
				for (x in 0...width)
				{
					var Y = c0.samples.get(y0 * c0.planeW + Std.int(x * c0.h / maxH));
					var Cb = c1.samples.get(y1 * c1.planeW + Std.int(x * c1.h / maxH)) - 128;
					var Cr = c2.samples.get(y2 * c2.planeW + Std.int(x * c2.h / maxH)) - 128;

					var R = Y + Std.int(1.402 * Cr);
					var G = Y - Std.int(0.344136 * Cb + 0.714136 * Cr);
					var B = Y + Std.int(1.772 * Cb);

					if (R < 0) R = 0 else if (R > 255) R = 255;
					if (G < 0) G = 0 else if (G > 255) G = 255;
					if (B < 0) B = 0 else if (B > 255) B = 255;

					var o = (y * width + x) * 4;
					pixels.set(o, R);
					pixels.set(o + 1, G);
					pixels.set(o + 2, B);
					pixels.set(o + 3, 255);
				}
			}
		}
	}
}

private class Component
{
	public var id:Int;
	public var h:Int;
	public var v:Int;
	public var quantId:Int;
	public var pred:Int = 0;
	public var dcTree:HuffNode;
	public var acTree:HuffNode;
	public var samples:Bytes;
	public var planeW:Int = 0;
	public var planeH:Int = 0;

	public function new(id:Int, h:Int, v:Int, quantId:Int)
	{
		this.id = id;
		this.h = h;
		this.v = v;
		this.quantId = quantId;
	}
}

private class HuffNode
{
	public var children:Array<HuffNode> = [null, null];
	public var value:Int = 0;
	public var isLeaf:Bool = false;

	public function new() {}
}
