package javax.sound.sampled;

import org.teavm.jso.JSBody;

class ClipImpl implements Clip {
    private final int id;
    private float gainDb;

    ClipImpl() {
        id = waNew();
    }

    @Override
    public void open(AudioFormat format, byte[] data, int offset, int length) {
        if (data == null || length <= 0) {
            return;
        }
        byte[] slice = (offset == 0 && length == data.length)
            ? data : java.util.Arrays.copyOfRange(data, offset, offset + length);
        waOpen(id, java.util.Base64.getEncoder().encodeToString(slice));
    }

    @Override
    public void start() {
        waStart(id, 0);
    }

    @Override
    public void loop(int count) {
        waStart(id, count);
    }

    @Override
    public void stop() {
        waStop(id);
    }

    @Override
    public void close() {
        waClose(id);
    }

    @Override
    public boolean isRunning() {
        return waRunning(id);
    }

    @Override
    public void setFramePosition(int frames) {
        waSeek(id, frames / 44100.0);
    }

    @Override
    public int getFramePosition() {
        return (int) (waPos(id) * 44100.0);
    }

    @Override
    public int getFrameLength() {
        return (int) (waLen(id) * 44100.0);
    }

    @Override
    public Object getControl(Object type) {
        return new FloatControl(this);
    }

    void setGainDb(float dB) {
        gainDb = dB;
        waGain(id, dB <= FloatControl.MIN_DB ? 0.0 : Math.pow(10.0, dB / 20.0));
    }

    float getGainDb() {
        return gainDb;
    }


    @JSBody(params = {}, script = ""
        + "if(!globalThis.__limeWA){"
        +   "var W={ctx:null,next:1,clips:{}};"
        +   "W.ensureCtx=function(){"
        +     "if(!W.ctx){try{W.ctx=new (window.AudioContext||window.webkitAudioContext)();}catch(e){}}"
        +     "if(W.ctx&&W.ctx.state==='suspended'){try{W.ctx.resume();}catch(e){}}"
        +     "return W.ctx;};"
        +   "W.start=function(id,loops,off){"
        +     "var c=W.clips[id]; if(!c||!c.buf||!W.ensureCtx())return;"
        +     "if(c.src){try{c.src.onended=null;c.src.stop();}catch(e){} c.src=null;}"
        +     "var s=W.ctx.createBufferSource(); s.buffer=c.buf;"
        +     "if(!c.g){c.g=W.ctx.createGain(); c.g.connect(W.ctx.destination);}"
        +     "c.g.gain.value=c.gain;"
        +     "s.connect(c.g);"
        +     "var d=c.buf.duration; var o=(off||0)%d; if(!(o>=0))o=0;"
        +     "c.src=s; c.playing=true; c.ended=false; c.off=o; c.t0=W.ctx.currentTime; c.loops=loops|0;"
        +     "s.onended=function(){c.ended=true; c.playing=false; c.off=0; c.src=null;};"
        +     "if(loops>0){s.loop=true; s.start(0,o); try{s.stop(W.ctx.currentTime+d*(loops+1)-o);}catch(e){}}"
        +     "else s.start(0,o);};"
        +   "W.pos=function(id){"
        +     "var c=W.clips[id]; if(!c)return 0;"
        +     "if(!c.playing||!c.buf||!W.ctx)return c.off||0;"
        +     "var d=c.buf.duration; var p=c.off+(W.ctx.currentTime-c.t0);"
        +     "return c.loops>0?(p%d):Math.min(p,d);};"
        +   "globalThis.__limeWA=W;}"
        + "var R=globalThis.__limeWA; var id=R.next++; R.clips[id]={gain:1,off:0,buf:null,pend:null}; return id;")
    private static native int waNew();

    @JSBody(params = {"id", "b64"}, script = ""
        + "var W=globalThis.__limeWA, c=W.clips[id]; if(!c)return;"
        + "var s=atob(b64), u=new Uint8Array(s.length);"
        + "for(var i=0;i<s.length;i++)u[i]=s.charCodeAt(i);"
        + "if(!W.ctx){try{W.ctx=new (window.AudioContext||window.webkitAudioContext)();}catch(e){console.warn('[wa] no AudioContext: '+e);return;}}"
        + "W.ctx.decodeAudioData(u.buffer).then(function(b){"
        +   "c.buf=b;"
        +   "if(c.pend){var p=c.pend; c.pend=null; W.start(id,p.loops,p.off);}"
        + "}).catch(function(e){console.warn('[wa] decode failed (clip '+id+'): '+e); c.pend=null;});")
    private static native void waOpen(int id, String b64);

    @JSBody(params = {"id", "loops"}, script = ""
        + "var W=globalThis.__limeWA, c=W.clips[id]; if(!c)return;"
        + "if(!c.buf){c.pend={loops:loops,off:c.off||0}; W.ensureCtx(); return;}"
        + "W.start(id,loops,c.off||0);")
    private static native void waStart(int id, int loops);

    @JSBody(params = {"id"}, script = ""
        + "var W=globalThis.__limeWA, c=W.clips[id]; if(!c)return;"
        + "c.pend=null;"
        + "if(c.playing){c.off=W.pos(id);}"
        + "if(c.src){try{c.src.onended=null;c.src.stop();}catch(e){} c.src=null;}"
        + "c.playing=false; c.ended=false;")
    private static native void waStop(int id);

    @JSBody(params = {"id"}, script = ""
        + "var W=globalThis.__limeWA, c=W&&W.clips[id]; if(!c)return;"
        + "if(c.src){try{c.src.onended=null;c.src.stop();}catch(e){}}"
        + "delete W.clips[id];")
    private static native void waClose(int id);

    @JSBody(params = {"id"}, script =
        "var W=globalThis.__limeWA, c=W&&W.clips[id]; return !!(c&&(c.pend||(c.playing&&!c.ended)));")
    private static native boolean waRunning(int id);

    @JSBody(params = {"id", "sec"}, script = ""
        + "var W=globalThis.__limeWA, c=W&&W.clips[id]; if(!c)return;"
        + "if(c.playing){W.start(id,c.loops|0,sec);}"
        + "else{c.off=sec; if(c.pend)c.pend.off=sec;}")
    private static native void waSeek(int id, double sec);

    @JSBody(params = {"id"}, script =
        "var W=globalThis.__limeWA; return (W&&W.pos)?W.pos(id):0;")
    private static native double waPos(int id);

    @JSBody(params = {"id"}, script =
        "var W=globalThis.__limeWA, c=W&&W.clips[id]; return (c&&c.buf)?c.buf.duration:0;")
    private static native double waLen(int id);

    @JSBody(params = {"id", "v"}, script = ""
        + "var W=globalThis.__limeWA, c=W&&W.clips[id]; if(!c)return;"
        + "c.gain=v; if(c.g)c.g.gain.value=v;")
    private static native void waGain(int id, double v);
}
