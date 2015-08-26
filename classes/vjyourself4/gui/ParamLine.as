package vjyourself4.gui {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import vjyourself4.dson.Eval;
	import vjyourself4.dson.ParamsManager;

	public class ParamLine extends Sprite{
		public var events:EventDispatcher = new EventDispatcher();
		public var types:Object={};
		public var paramsM:ParamsManager;
		var line:TextField;

		public var path:String;
		public var type:String;
		public var val;

		public function ParamLine() {
			line = new TextField();
			line.textColor=0xffffff;
			line.width=200;
			line.height=20;
			line.text="";
			addChild(line);
		}
	
		function setProperty(pp,tt=null){
			path=pp;

			if(tt!=null) type=tt;
			else type=paramsM.getDesc(path);
			
			val=paramsM.getParam(path);

			line.text=" - "+path+" : "+type+" = "+val+"\n";
		}
	}
	
}
