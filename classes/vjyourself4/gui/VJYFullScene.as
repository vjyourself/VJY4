package vjyourself4.gui{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import vjyourself4.sys.WinConsoleLong;
	import flash.display.SimpleButton;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;
	import vjyourself4.dson.ParamsManager;

	public class VJYFullScene  extends Sprite{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var wDimX:Number;
		public var wDimY:Number;
	
		public var params:Object;
		public var vis:Sprite;
		public var ns:Object;
		
		var back:Sprite;
		var console:TextField;
		var comps:Array;
		var types:Object;
		var i,ii:int;
		public function VJYFullScene(){
			vis = this;
		}
		public function init(){
			scaleX=2;
			scaleY=2;
			ns.scene.events.addEventListener(Event.CHANGE,onSceneChange,0,0,1);
			
			back = new Sprite();
			back.graphics.beginFill(0x333333); // choosing the colour for the fill, here it is red
			back.graphics.drawRect(0, 0, 200,500); // (x spacing, y spacing, width, height)
			back.graphics.endFill();
			vis.addChild(back);

			/*console = new TextField();
		//	console.text="HELLO\n";
			console.textColor=0xffffff;
			console.width=200;
			console.height=500;
			vis.addChild(console);
			onSceneChange();*/
			comps=[
				{comp:ns.back,title:"Back"},
				{comp:ns.mid,title:"Mid"},
				{comp:ns.fore,title:"Fore"}
			];
			types=ns.sys.cloud.cont;
			onSceneChange();
		}
		
		function onSceneChange(e=null){
			log(1,"CHANGE!!!");
			//back
			var ccc:Object;
			var yy=0;
			for(i=0;i<comps.length;i++){
				ccc=comps[i];
				ccc.gui=new ParamsList();
				ccc.gui.types=types;
				ccc.gui.title=ccc.title;
				ccc.gui.paramsM=ccc.comp.compParams;
				ccc.gui.init();
				ccc.gui.y=yy;yy+=ccc.gui.height+5;
				vis.addChild(ccc.gui);
			}
		}

		
		public function onResize(e=null){
			wDimX=ns.sys.screen.wDimX;
			wDimY=ns.sys.screen.wDimY;
			
			
		}
		public function onEF(e){
		
		}
		
	}
}