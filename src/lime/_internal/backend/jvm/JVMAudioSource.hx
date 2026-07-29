package lime._internal.backend.jvm;

#if jvm
import haxe.io.Bytes;
import lime.app.Application;
import lime.math.Vector4;
import lime.media.AudioSource;
import lime.utils.Log;

#if haxe5
import jvm.Int8;
#else
import java.types.Int8;
#end

class JVMAudioSource
{
	private static var active:Array<JVMAudioSource> = [];
	private static var pumping:Bool = false;

	private var parent:AudioSource;
	private var clip:JavaClip;
	private var gainControl:JavaFloatControl;
	private var loops:Int = 0;
	private var gain:Float = 1.0;
	private var pitch:Float = 1.0;
	private var length:Int = 0; // ms; 0 = full buffer
	private var position:Vector4 = new Vector4();
	private var playing:Bool = false;
	private var paused:Bool = false;
	private var sampleRate:Int = 44100;
	private var frameSize:Int = 4;

	public function new(parent:AudioSource)
	{
		this.parent = parent;
	}

	public function init():Void
	{
		var buffer = parent.buffer;
		Sys.println('[audio] init buffer=' + (buffer != null) + ' dataLen=' + ((buffer != null && buffer.data != null) ? buffer.data.length : -1)
			+ ' ch=' + (buffer != null ? buffer.channels : -1) + ' rate=' + (buffer != null ? buffer.sampleRate : -1));
		if (buffer == null || buffer.data == null) return;

		try
		{
			var pcm:java.NativeArray<Int8> = (cast buffer.data.buffer : Bytes).getData();
			Sys.println('[audio] init pcm bytes=' + pcm.length);
			sampleRate = buffer.sampleRate;
			frameSize = Std.int(buffer.channels * buffer.bitsPerSample / 8);
			if (frameSize < 1) frameSize = 1;

			var format = new JavaAudioFormat(buffer.sampleRate, buffer.bitsPerSample, buffer.channels, true /*signed*/, false /*little-endian*/);
			clip = JavaAudioSystem.getClip();
			clip.open(format, pcm, 0, pcm.length);
			Sys.println('[audio] init clip opened OK frameLen=' + clip.getFrameLength());

			try
			{
				gainControl = cast clip.getControl(#if wasmjs null #else JavaFloatControlType.MASTER_GAIN #end);
			}
			catch (e:Dynamic) {}
			applyGain();
		}
		catch (e:Dynamic)
		{
			Sys.println('[audio] init clip FAILED: ' + e);
			Log.warn("JVMAudioSource: could not open clip: " + e);
			clip = null;
		}
	}

	public function dispose():Void
	{
		active.remove(this);
		if (clip != null)
		{
			try clip.close() catch (e:Dynamic) {}
			clip = null;
		}
	}

	public function play():Void
	{
		Sys.println('[audio] play clip=' + (clip != null) + ' playing=' + playing + ' paused=' + paused + ' loops=' + loops);
		if (clip == null || (playing && !paused)) return;

		if (paused)
		{
			paused = false;
		}
		else
		{
			clip.setFramePosition(parent.offset);
		}

		playing = true;
		if (loops > 0)
			clip.loop(loops);
		else
			clip.start();

		if (active.indexOf(this) == -1) active.push(this);
		ensurePump();
	}

	public function pause():Void
	{
		if (clip == null || !playing) return;
		paused = true;
		try clip.stop() catch (e:Dynamic) {}
	}

	public function stop():Void
	{
		playing = false;
		paused = false;
		active.remove(this);
		if (clip != null)
		{
			try
			{
				clip.stop();
				clip.setFramePosition(0);
			}
			catch (e:Dynamic) {}
		}
	}

	private function applyGain():Void
	{
		if (gainControl == null) return;
		try
		{
			var db = (gain <= 0.0001) ? gainControl.getMinimum() : (20.0 * Math.log(gain) / 2.302585092994046 /* ln(10) */);
			if (db < gainControl.getMinimum()) db = gainControl.getMinimum();
			if (db > gainControl.getMaximum()) db = gainControl.getMaximum();
			gainControl.setValue(db);
		}
		catch (e:Dynamic) {}
	}

	private static function ensurePump():Void
	{
		if (pumping) return;
		if (Application.current != null)
		{
			pumping = true;
			Application.current.onUpdate.add(__pump);
		}
	}

	private static function __pump(deltaTime:Int):Void
	{
		var i = active.length;
		while (--i >= 0)
		{
			var source = active[i];
			if (source.clip == null || (!source.playing) || source.paused) continue;
			if (!source.clip.isRunning())
			{
				source.playing = false;
				active.remove(source);
				source.parent.onComplete.dispatch();
			}
		}
	}

	public function getCurrentTime():Int
	{
		if (clip == null) return 0;
		return Std.int(clip.getFramePosition() * 1000.0 / sampleRate);
	}

	public function setCurrentTime(value:Int):Int
	{
		if (clip != null) clip.setFramePosition(Std.int(value / 1000.0 * sampleRate));
		return value;
	}

	public function getGain():Float
	{
		return gain;
	}

	public function setGain(value:Float):Float
	{
		gain = value;
		applyGain();
		return value;
	}

	public function getLength():Int
	{
		if (length != 0) return length;
		if (clip == null) return 0;
		return Std.int(clip.getFrameLength() * 1000.0 / sampleRate);
	}

	public function setLength(value:Int):Int
	{
		return length = value;
	}

	public function getLoops():Int
	{
		return loops;
	}

	public function setLoops(value:Int):Int
	{
		return loops = value;
	}

	public function getPitch():Float
	{
		return pitch;
	}

	public function setPitch(value:Float):Float
	{
		return pitch = value;
	}

	public function getPosition():Vector4
	{
		return position;
	}

	public function setPosition(value:Vector4):Vector4
	{
		position.x = value.x;
		position.y = value.y;
		position.z = value.z;
		position.w = value.w;
		return position;
	}
}

@:native("javax.sound.sampled.AudioSystem")
private extern class JavaAudioSystem
{
	public static function getClip():JavaClip;
}

@:native("javax.sound.sampled.AudioFormat")
private extern class JavaAudioFormat
{
	public function new(sampleRate:Single, sampleSizeInBits:Int, channels:Int, signed:Bool, bigEndian:Bool);
}

@:native("javax.sound.sampled.Clip")
private extern interface JavaClip
{
	public function open(format:JavaAudioFormat, data:java.NativeArray<Int8>, offset:Int, bufferSize:Int):Void;
	public function start():Void;
	public function stop():Void;
	public function close():Void;
	public function loop(count:Int):Void;
	public function isRunning():Bool;
	public function setFramePosition(frames:Int):Void;
	public function getFramePosition():Int;
	public function getFrameLength():Int;
	public function getControl(control:Dynamic):Dynamic;
}

@:native("javax.sound.sampled.FloatControl")
private extern class JavaFloatControl
{
	public function setValue(newValue:Single):Void;
	public function getValue():Single;
	public function getMinimum():Single;
	public function getMaximum():Single;
}

@:native("javax.sound.sampled.FloatControl.Type")
private extern class JavaFloatControlType
{
	public static var MASTER_GAIN:Dynamic;
}
#end
