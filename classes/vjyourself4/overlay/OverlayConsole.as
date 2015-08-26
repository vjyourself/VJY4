package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import vjyourself4.DynamicEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import vjyourself4.rules.RuleAB_C;
	
	public class OverlayConsole{
		public var _debug:Object;
		public var _meta:Object={name:"Overlay Console"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		var filter:Object={act:false};

		var tfConsole:TextField;
		var rule:RuleAB_C;
		
		public var vis:Sprite;

		var width:Number=300;
		var height:Number=600;
		var visible:Boolean=false;

		public function OverlayConsole(){
		}
		
		public function init(){
			if(params.filter!=null) filter=params.filter;
			if(filter.act) rule = new RuleAB_C(filter.rule);

			vis = new Sprite();
			vis.x=ns.sys.screen.wDimX-width;
			vis.y=0;
			vis.visible=visible;

			var tf:TextFormat = new TextFormat();
			tf.size = 16;
			tf.bold = true;
			tf.font = "Arial"
			tf.color = 0xffffff;
	
			tfConsole = new TextField();
			tfConsole.width=width;
			tfConsole.height=height;
			tfConsole.defaultTextFormat = tf;
			tfConsole.backgroundColor=0x333333;
			tfConsole.background=true;

			vis.addChild(tfConsole);

			_debug.events.addEventListener("LOG",onLog,0,0,1);
		}
		
		public function show(v=null){
			if(v==null) visible=!visible;
			else visible=v;
			vis.visible=visible;
		}

		public function onLog(e:DynamicEvent){
			var show:Boolean=true;
			if(filter.act) show=rule.getVal(e.data.level,e.data.n);
					
			if(show){
				var txt=e.data.n+"> "+e.data.msg;
				tfConsole.text+=txt+"\n";
				tfConsole.scrollV=tfConsole.maxScrollV;
			}
		}
		
		public function onResize(e){
			vis.x=ns.sys.screen.wDimX-width;
			vis.y=0;
		}

		public function dispose(){

		}
	}
}