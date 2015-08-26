package vjyourself4.sys{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Stage;
	import vjyourself4.DynamicEvent;
	import vjyourself4.sys.MetaStream;
	public class EnterFrame{
		public var mstream:MetaStream;
		public var _meta:Object={name:"EnterFrame"};
		public var msLevel:Number=3;
		
		public var events:EventDispatcher;
		public var pt:Number=0;
		public var nt:Number=0;
		public var dt:Number=0;
		public var dts:Array=[];
		public var dtsInd=0;
		public var dtsNum=12;
		public var mFps=0;
		public var fps=30;
		public var stage:Stage;
		
		
		function EnterFrame(){
			events= new EventDispatcher();
			nt = new Date().getTime();
			for(var i=0;i<dtsNum;i++) dts[i]=0;
			}
		public function init(){
			stage.addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
		}
		public function setFps(n:Number){
			mstream.log(this,2,"Framerate: "+n);
			if(stage.frameRate!=n) stage.frameRate=n;
			fps=n;
		}
		public function onEF(e=null){
			pt=nt;
			nt = new Date().getTime();
			dt = nt-pt;
			//longer than a secound -> ignore...
			if(dt>1000) dt=1000/fps;
			dtsInd=(dtsInd+1)%dtsNum;
			dts[dtsInd]=dt;
			mFps=0;for(var i=0;i<dtsNum;i++)mFps+=dts[i];mFps=1/mFps*dtsNum*1000;
			//trace("delta: "+dt+" mFps: "+mFps);
			var ev=new DynamicEvent(Event.ENTER_FRAME);
			ev.delta=dt;
			ev.mul=dt/(1000/60);
			//trace(ev.delta+" "+ev.mul);
			events.dispatchEvent(ev);
			}
	}
}