package vjyourself4.io{
	
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import vjyourself4.VJYBase;
	import vjyourself4.sys.MetaStream;
	import vjyourself4.sys.ScreenManager;
	
	public class MkbManager extends VJYBase{
		
		public var io:IOManager;
		
		public var keys:Object;
		public var mouse={
			x:0,y:0,
			rX:0,rY:0,rR:0,
			x0:0,y0:0,
			dX:0,dY:0,
			butt:false,
			onstage:false
		};
		public var drag:Object={
			active:false,
			x0:0,y0:0,
			dX:0,dY:0,
			drX:0,drY:0
		}
		
		public var active:Boolean=false;
		public var events = new EventDispatcher();
		
		function MkbManager(){
			keys={Left:false,Right:false,Up:false,Down:false};
			for(var i=65;i<=90;i++) keys[String.fromCharCode(i)]=false;
		}
		
		public function init(p:Object=null){
			io.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,0,0,1);
			io.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,0,0,1);
			io.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,0,0,1);
			io.stage.addEventListener(Event.MOUSE_LEAVE,onMouseLeave,0,0,1);
			io.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,0,0,1);
			io.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp,0,0,1);
		}

		function onMouseMove(e){
			if(!mouse.onstage){
				mouse.x0=io.win.mouseX;
				mouse.y0=io.win.mouseY;
			}
			mouse.onstage=true;
			active=true;
		}
		
		function onMouseLeave(e){
			mouse.onstage=false;
		}

		//no start above border GUI (e.g. Space Exp sliders&buttons)
		function onMouseDown(e){
			if((io.win.mouseY<io.wDimY-io.wLimBottom)&&(io.win.mouseY>io.wLimTop)&&
				(io.win.mouseX<io.wDimX-io.wLimRight)&&(io.win.mouseX>io.wLimLeft))
			{
				mouse.butt=true;
				drag.active=true;
				drag.x0=io.win.mouseX;
				drag.y0=io.win.mouseY;
				drag.dX=0;
				drag.dY=0;
				drag.drX=0;
				drag.drY=0;
				events.dispatchEvent(new Event("CLICK"));
			}
			active=true;
		}
		
		function onMouseUp(e){
			mouse.butt=false;
			drag.active=false;
			active=true;
		}
		
		function updateMouseR(){
			mouse.rX=io.win.mouseX/io.wDimX*2-1;
			mouse.rY=io.win.mouseY/io.wDimY*2-1;
			mouse.rR=Math.sqrt(mouse.rX*mouse.rX+mouse.rY*mouse.rY);
			drag.drX=drag.dX/io.wDimX;
			drag.drY=drag.dY/io.wDimY;
				
		}
		
		function onKeyDown(e:KeyboardEvent){
			switch(e.keyCode){
				case 37:keys["Left"]=true;break;
				case 38:keys["Up"]=true;break;
				case 39:keys["Right"]=true;break;
				case 40:keys["Down"]=true;break;
				default:
				keys[String.fromCharCode(e.charCode).toLowerCase()]=true;
				break;
			}
			active=true;
		};

		function onKeyUp(e:KeyboardEvent){
			switch(e.keyCode){
				case 37:keys["Left"]=false;break;
				case 38:keys["Up"]=false;break;
				case 39:keys["Right"]=false;break;
				case 40:keys["Down"]=false;break;
				default:
				keys[String.fromCharCode(e.charCode).toLowerCase()]=false;
				break;
			}
			active=true;
		}

		public function onEF(e){
			if(mouse.onstage){
				mouse.x=io.win.mouseX;
				mouse.y=io.win.mouseY;
				mouse.dX=(mouse.x-mouse.x0)/io.wDimX*2;
				mouse.dY=(mouse.y-mouse.y0)/io.wDimY*2;
				mouse.x0=mouse.x;
				mouse.y0=mouse.y;
				if(drag.active){
					drag.dX=mouse.x-drag.x0;
					drag.dY=mouse.y-drag.y0;
				}
				updateMouseR();
			}else{
				mouse.x=0;
				mouse.y=0;
				mouse.rX=0;
				mouse.rY=0;
				mouse.rR=0;
				mouse.dX=0;
				mouse.dY=0;
				updateMouseR();
				drag.active=false;
			}
		}
		
	}
}
