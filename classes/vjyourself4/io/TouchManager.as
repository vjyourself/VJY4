package vjyourself4.io{
	
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;
	import flash.events.TouchEvent;

	import vjyourself4.VJYBase;
	import vjyourself4.sys.MetaStream;
	import vjyourself4.sys.ScreenManager;
	
	public class TouchManager extends VJYBase{
	
		public var io:IOManager;
		public var drag:Object={
			active:false,
			x0:0,y0:0,
			dX:0,dY:0,
			drX:0,drY:0
		}

		public var events = new EventDispatcher();
		
		function TouchManager(){
			
		}
		
		public function init(p:Object=null){
			/*
				acc1= new Accelerometer();
				acc1.setRequestedUpdateInterval(50);
        		acc1.addEventListener(AccelerometerEvent.UPDATE, updateHandler);
			*/
			Multitouch.inputMode=MultitouchInputMode.GESTURE;
			//io.win.addEventListener(TransformGestureEvent.GESTURE_PAN,onPan,0,0,1);
			io.win.addEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom,0,0,1);
			io.win.addEventListener(TransformGestureEvent.GESTURE_ROTATE,onRotate,0,0,1);
			//io.win.addEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe,0,0,1);
			io.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,0,0,1);
			io.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,0,0,1);
		}
		
		function onZoom(e:TransformGestureEvent){
			events.dispatchEvent(e);
		}
		
		function onRotate(e:TransformGestureEvent){
			events.dispatchEvent(e);
		}
		
		//no start above border GUI (e.g. Space Exp sliders&buttons)
		function onMouseDown(e){
			if((io.win.mouseY<io.wDimY-io.wLimBottom)&&(io.win.mouseY>io.wLimTop)&&
				(io.win.mouseX<io.wDimX-io.wLimRight)&&(io.win.mouseX>io.wLimLeft))
			{
				drag.active=true;
				drag.x0=io.win.mouseX;
				drag.y0=io.win.mouseY;
				drag.dX=0;
				drag.dY=0;
				drag.drX=0;
				drag.drY=0;
			}
		}
		
		function onMouseUp(e){
			drag.active=false;
		}
		
		function updateMouseR(){
			drag.drX=drag.dX/io.wDimX;
			drag.drY=drag.dY/io.wDimY;	
		}
		
		public function onEF(e){
			if(drag.active){
				drag.dX=io.win.mouseX-drag.x0;
				drag.dY=io.win.mouseY-drag.y0;
			}
			updateMouseR();
		}
		
	}
}
