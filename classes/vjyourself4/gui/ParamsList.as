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

	public class ParamsList extends Sprite{
		public var events:EventDispatcher = new EventDispatcher();
		public var types:Object={};
		public var paramsM:ParamsManager;
		public var title:String;
		
		var head:TextField;
		var yy:Number=0;

		var i,ii:int;
		var n:String;
		
		var list:Array;

		public function ParamsList() {
		}
		public function init(){
			head = new TextField();
			head.textColor=0xffffff;
			head.width=200;
			head.height=40;
			head.text=title;
			addChild(head);
			yy+=40;
			
			list=[];
			processParams(paramsM.desc,"");
		}

		function processParams(obj,path){
			for(n in obj) if(obj[n] is String) processProperty(obj[n],path+((path=="")?"":".")+n);
								else processParams(obj[n],path+((path=="")?"":".")+n);
		}
		function processProperty(type,path){
			var ll={};
			ll.gui= new ParamLine();
			ll.gui.types=types;
			ll.gui.paramsM=paramsM;
			ll.gui.setProperty(path,type);
			addChild(ll.gui);
			ll.gui.y=yy;
			yy+=ll.gui.height;
			list.push(ll);
		}
	

		

	}
	
}
