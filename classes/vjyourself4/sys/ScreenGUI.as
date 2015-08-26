package vjyourself4.sys{
	import flash.display.Sprite;

	public class ScreenGUI{
		public var screen;
		var wDimX:Number;
		var wDimY:Number;
		public var vis:Sprite;
		
		public var elems:Array;
		public function ScreenGUI(){
			elems=[];
			vis=new Sprite();
		}
		public function init(){
			onResize();
		}
		public function addChild(vvv,params){
			//trace("ScreenGUI.addChild",vvv);
			vis.addChild(vvv);
			elems.push({vis:vvv,params:params});
			refreshElem(elems[elems.length-1]);
		}
		
		public function removeChild(el){
			var ind=-1;
			for(var i=0;i<elems.length;i++) if(elems[i].el===el) ind=i;
			if(ind>=0){
				vis.removeChild(elems[i].el);
				elems.splice(ind,1);
			}
		}
		public function refreshElem(el){
			switch(el.params.posX){case "left":el.vis.x=0;break;case "center":el.vis.x=wDimX/2;break;case "right":el.vis.x=wDimX;break;}
			switch(el.params.posY){case "top":el.vis.y=0;break;case "center":el.vis.y=wDimY/2;break;case "bottom":el.vis.y=wDimY;break;}
			if(el.params.scaleNorm!=null){var ss=wDimX/el.params.scaleNorm;el.vis.scaleX=ss;el.vis.scaleY=ss;}
			
		}
		public function onResize(){
			wDimX=screen.wDimX;
			wDimY=screen.wDimY;
			for(var i=0;i<elems.length;i++) refreshElem(elems[i]);

		}
	}
}