package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import vjyourself4.DynamicEvent;
	
	
	public class OverlayAni{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		
		var aniCN:String;
		var aniWidth:Number;
		var aniHeight:Number;

		public var vis:Sprite;
		var ani:MovieClip;

		//auto cc
		var cc:Number=0;
		var delay:Number=0;
		var auto:Boolean=false;
		var scale:String="fit";
		//var perm:Boolean=false;
		
		public function OverlayAni(){
		}
		
		public function init(){
			aniCN=params.aniCN;
			aniWidth=params.aniWidth;
			aniHeight=params.aniHeight;
			if(params.scale!=null) scale=params.scale;
			if(params.auto!=null){
				auto=true;
				delay=params.auto.delay;
				if(params.auto.cc!=null) cc=params.auto.cc;
			}
			vis = new Sprite();
			var c:Class = getDefinitionByName(aniCN) as Class;
			ani = new c();
			ani.stop();
			vis.addChild(ani);
			
		}
		
		public function play(){
			ani.gotoAndPlay(2);
			cc=0;
		}
		
		public function onEF(e:DynamicEvent){
			if(auto){
				cc+=e.delta/1000;
				if(cc>=delay){
					cc=0;
					play();
				}
			}
		}
		
		public function onResize(e){
			var sX=ns.screen.wDimX/aniWidth;
			var sY=ns.screen.wDimY/aniHeight;
			switch(scale){
				case "stretch":
				ani.scaleX=sX;
				ani.scaleY=sY;
				break;
				case "fit":
				default:
				var s=(sX<sY)?sX:sY;
				ani.scaleX=s;
				ani.scaleY=s;
				break;
			}
			
		}

		public function dispose(){

		}
	}
}