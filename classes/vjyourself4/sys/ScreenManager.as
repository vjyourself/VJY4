package vjyourself4.sys{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.external.ExternalInterface;
	import vjyourself4.DynamicEvent;
	import vjyourself4.sys.Sys_VisTerminal;
	import vjyourself4.sys.MetaStream;
	
	//save ScreenShot
	import away3d.containers.View3D;
	import flash.display.BitmapData;
	import com.adobe.images.JPGEncoder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.system.fscommand;
		
	
	public class ScreenManager{
		//DEBUG
		public var _debug:Object;
		public var _meta:Object={name:"Screen"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		//params
		public var shape:String="16:9";
		public var quality:String="MEDIUM";
		public var fullscreen:Boolean=false;
		public var fssource:Boolean=false;
		public var fssourceWidth:Number=0;
		public var fssourceHeight:Number=0;
		
		public var mouse:Boolean=false;
		public var logo:Boolean=false;
		public var logoX:String="left";
		public var logoY:String="top";
		public var fpsmeter:Boolean=false;
		public var console:Boolean=false;
		public var browser:Boolean=false;
		public var stats:Boolean=false;
		public var fps:Number=60;
		public var In3D:Object={mode:"none"};
		
		//vars
		public var events:EventDispatcher;
		public var stage:Stage;
		public var terminalEnabled:Boolean = false;
		
		public var wDimX=960;
		public var wDimY=540;
		public var ready=false;

		public var vis:Sprite;
		public var view:View3D;
		//public var visFPSMeter:Sprite;
		//public var visLogo:Sprite;
		public var screenshot:Object;
		public var quit:Object;
		public var landing:Object;
		
		public var saveImage:Object;
		public var gui;
		function ScreenManager(){
			events= new EventDispatcher();
		}
		
		public function init(){
			
			if(screenshot==null) screenshot={gamepad:"",click:false};
			if(quit==null) quit={gamepad:"",click:false};
			wDimX = stage.stageWidth;
			wDimY = stage.stageHeight;
			
			if(!mouse) Mouse.hide();
			
			/*
			gui = new ScreenGUI();
			gui.screen=this;
			gui.init();
			visWin.addChild(gui.vis);
			if(fpsmeter){
				visFPSMeter = new (getDefinitionByName("FPSMeter")as Class)();
				visWin.addChild(visFPSMeter);
			}

			if(console){
				visConsole = new (getDefinitionByName("SysScreenConsole") as Class)();
				visConsole.y=40;
				visWin.addChild(visConsole);
			}
			if(logo){
				visLogo = new (getDefinitionByName("ScreenLogo") as Class)();
				//trace("ADD LOGO"+visLogo);
				visWin.addChild(visLogo);
			}
			*/
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE,onResize,0,0,1);
			if(fullscreen) stage.displayState=StageDisplayState.FULL_SCREEN;
			ready=true;
			
			onResize();

			urlloader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE,imgSaved,0,0,1);
				
		}
		var urlloader:URLLoader;
		public function enableFssource(bool){
			if(bool!=fssource){
				if(bool) stage.fullScreenSourceRect=new Rectangle(0,0,fssourceWidth,fssourceHeight);
				else stage.fullScreenSourceRect=null;
				fssource=bool;
			}
		}
		
		public function addView(v){view=v;}
		public function quitApp(e=null){
			fscommand("quit");
		}
		public function getScreenShot():BitmapData{
			var bmpDSS = new BitmapData(wDimX,wDimY,false,0);
			if(view!=null){
				view.renderer.queueSnapshot(bmpDSS);
				//view.renderer.swapBackBuffer = false;
				view.render();
			}
			return bmpDSS;
		}
		public function saveScreenShot(e=null){
			if(view!=null){
				var bmpDSS = new BitmapData(wDimX,wDimY,false,0);
				view.renderer.queueSnapshot(bmpDSS);
				//view.renderer.swapBackBuffer = false;
				view.render();
				//view.stage3DProxy.context3D.drawToBitmapData(bmpDSS);
				//view.renderer.swapBackBuffer = true;
				
				var url=saveImage.url;
				var jpgEncoder:JPGEncoder = new JPGEncoder(85);
				var jpgStream:ByteArray = jpgEncoder.encode(bmpDSS);
				var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
				var jpgURLRequest:URLRequest = new URLRequest(url);
				jpgURLRequest.requestHeaders.push(header);
				jpgURLRequest.method = URLRequestMethod.POST;
				jpgURLRequest.data = jpgStream;
				log(1,"ScreenShot > sending post request:"+url);
				urlloader.load(jpgURLRequest);

			}
		}
		public function imgSaved(e){
			log(1,"ScreenShot > "+urlloader.data);
		}
		public function toggleFullscreen(){
			var flashFS=true;
			if(browser){
				if(ExternalInterface.call("isWebkitFS")==1){
					flashFS=false;
					ExternalInterface.call("toggleWebkitFS");
				}
			}
			
			if(flashFS){
				if(stage.displayState==StageDisplayState.FULL_SCREEN) stage.displayState=StageDisplayState.NORMAL
				else stage.displayState=StageDisplayState.FULL_SCREEN;
			}
		}
		function onResize(e=null){
			wDimX = stage.stageWidth;
			wDimY = stage.stageHeight;
			log(1,"Resize "+wDimX+","+wDimY);
			events.dispatchEvent(new Event(Event.RESIZE));
		//	if(visLogo!=null) updateLogoPos();
			//gui.onResize();
		}
		function updateLogoPos(){
			/*
			switch(logoX){
				case "left":visLogo.x=0;break;
				case "right":visLogo.x=wDimX;break;
				case "center":visLogo.x=wDimX/2;break;
				default:visLogo.x=Number(logoX);
			}
			switch(logoY){
				case "top":visLogo.y=0;break;
				case "bottom":visLogo.y=wDimY;break;
				case "center":visLogo.y=wDimY/2;break;
				default:visLogo.y=Number(logoY);
			}
			*/
		}
		public function onEF(e=null){
			
		}
	}
}