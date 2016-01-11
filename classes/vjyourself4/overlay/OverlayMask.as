package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.VJYBase;
	import flash.utils.getDefinitionByName;
	
	public class OverlayMask extends VJYBase{
		
		public var ns:Object;
		public var params:Object;
		public var vis:Sprite;
		
		var top:Sprite;
		var topHeight:Number=40;
		var bottom:Sprite;
		var bottomHeight:Number=40;

		public function OverlayMask(){}
		
		public function init(){
			vis = new Sprite();
			var cMask:Class = getDefinitionByName("MaskSquare") as Class;
			top = new cMask();
			vis.addChild(top);
			bottom = new cMask();
			vis.addChild(bottom);
			onResize();
		}
		
		public function onResize(e=null){
			top.width=ns.sys.screen.wDimX;
			top.height=topHeight;
			top.x=0;
			top.y=0;
			
			bottom.width=ns.sys.screen.wDimX;
			bottom.height=bottomHeight;
			bottom.x=0;
			bottom.y=ns.sys.screen.wDimY-bottomHeight;
		}

		public function incHeight(n,d){
			this[n+"Height"]+=d;
			if(this[n+"Height"]<0)this[n+"Height"]=0;
			this[n].height=this[n+"Height"];

			bottom.y=ns.sys.screen.wDimY-bottomHeight;
		}
		
	}
}