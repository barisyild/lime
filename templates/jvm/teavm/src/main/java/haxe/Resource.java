package haxe;

public class Resource extends haxe.jvm.Object
{
	public static haxe.root.Array content;

	public Resource(haxe.jvm.EmptyConstructor e) {}

	private static String escape(String name)
	{
		StringBuilder out = new StringBuilder(name.length());
		for (int i = 0; i < name.length(); i++)
		{
			char c = name.charAt(i);
			if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')
				|| c == '_' || c == '/' || c == '\\' || c == '.')
			{
				out.append(c);
			}
			else
			{
				out.append("-x").append((int) c);
			}
		}
		return out.toString();
	}

	public static haxe.io.Bytes getBytes(String name)
	{
		if (name == null) return null;
		String b64 = ResourceData.get(escape(name));
		if (b64 == null) return null;
		try
		{
			return haxe.io.Bytes.ofData(java.util.Base64.getDecoder().decode(b64));
		}
		catch (Throwable t)
		{
			return null;
		}
	}

	public static String getString(String name)
	{
		haxe.io.Bytes b = getBytes(name);
		if (b == null) return null;
		return new String(b.b, java.nio.charset.StandardCharsets.UTF_8);
	}
}
