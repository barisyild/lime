package sys.io;

public class Process extends haxe.jvm.Object
{
	public haxe.io.Input stdout;
	public haxe.io.Input stderr;
	public haxe.io.Output stdin;

	public Process(String cmd, haxe.root.Array args, Boolean detached)
	{
		throw new RuntimeException("sys.io.Process is not available in the browser");
	}

	public Process(haxe.jvm.EmptyConstructor e) {}

	public static java.lang.ProcessBuilder createProcessBuilder(String cmd, haxe.root.Array args)
	{
		throw new RuntimeException("sys.io.Process is not available in the browser");
	}

	public void close() {}
}