package  vjyourself4.gui{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	public class HoriSlider extends Sprite{

		public var val:Number=0;
		public var valDelta:Number=0;
		public var dimX:Number=320;
		public var dimY:Number=50;
		public var input:String="mkb";
		public var relative:Boolean=false;
		public var autoval:Boolean=false;
		public var tfVal_bool:Boolean=true;
		public var tfVal_obj:TextField;

		public function HoriSlider() {
			stone.mouseEnabled=false;
			//input="mkb";
			if(input=="mkb"){
				addEventListener(MouseEvent.MOUSE_DOWN,onMDown);
				if(stage==null)addEventListener(Event.ADDED_TO_STAGE,onStage,0,0,1);
				else onStage();
			}
			
			if(input=="touch"){
				addEventListener(TouchEvent.TOUCH_OVER,onDown);
				addEventListener(TouchEvent.TOUCH_OUT,onUp);
				addEventListener(TouchEvent.TOUCH_MOVE,onTouchMove);
			}

			addEventListener(Event.ENTER_FRAME,onEF);
		}
		public function init(){
			if(tfVal_bool) tfVal_obj=this["tfVal"];
			updateSize();
		}
		public function updateSize(){
			ruler.width=dimX;
			if(tfVal_bool) tfVal_obj.x=dimX-tfVal_obj.width;
			rulerEndR.x=dimX;
			stone.x=dimX*val;
			ruler.height=dimY;
			ruler.y=0;
			rulerEndR.height=dimY;
			rulerEndR.y=0;
			rulerEndL.height=dimY;
			rulerEndL.y=0;
			var ss=dimY/50;
			stone.scaleX=ss;
			stone.scaleY=ss;
		}
		public function onStage(e=null){
			stage.addEventListener(MouseEvent.MOUSE_UP,onMUp);
		}
		public function setVal(v){
			val=v;
			if(val<0) val=0; if(val>1)val=1;
			stone.x=dimX*val;
		}
		var myTouchId=0;
		public function onTouchMove(e:TouchEvent){
			if(e.touchPointID==myTouchId){
				var p=new Point(e.stageX,e.stageY);
				trace("touch:"+e.stageX);
				p=globalToLocal(p);
				trace("local:"+p.x);
				val=p.x/dimX;
				if(val<0)val=0;
				if(val>1)val=1;
				//trace(p.x);
				stone.x=dimX*val;
			}
		}
		
		var mouseDown:Boolean=false;
		//public function globalMouseUp(e=null){onUp()};
		function onDown(e:TouchEvent){trace("touch Down");myTouchId=e.touchPointID;}
		function onUp(e:TouchEvent){trace("touch Up");}
		function onMDown(e){mouseDown=true;mX0=mouseX;}
		function onMUp(e){mouseDown=false;}
		var mX0:Number=0;
		function onEF(e=null){
			//trace("F1");
			if(input=="mkb"){
			if(mouseDown){
				
				//if((mouseX>=0)&&(mouseX<=dimX))
				{
					if(relative){
						valDelta=(mouseX-mX0)/dimX;
						mX0=mouseX;
					}else{
						val=mouseX/dimX;
						if(val<0)val=0;
						if(val>1)val=1;
						stone.x=dimX*val;
					}
					//tfVal.text=""+Math.round(val*100);
				}
			}else{
				valDelta=0;
			}
			}
			if(autoval) if(tfVal_bool) tfVal_obj.text=""+Math.round(val*100);

		}
		

	}
	
}
