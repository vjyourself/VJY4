package vjyourself4.gui{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import vjyourself4.sys.WinConsoleLong;
	import flash.display.SimpleButton;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;
	import flash.display.BitmapData;
	import flash.media.CameraRoll;

	public class VJYExp  extends Sprite{
		var cameraRoll:CameraRoll;
			
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var wDimX:Number;
		public var wDimY:Number;
	
	
		var landingWin:MovieClip;
		var landingShade:Sprite;

		var aniLogo:Sprite;
		var scenes:Array;
		var buttMenu;
		var buttHelp;
		var buttReset;
		var buttScreenShot;
		var overlayCtrls:VJYOverlayCtrl;
		public var state:String="";

		public var params:Object;
		public var vis:Sprite;
		public var ns:Object;
		var sys:Object;
		//public var guiMsg:GUIMsg;
		/*
		var landingWin:WinAppLanding;
		var boxControl:BoxControl;
		var boxArtist:BoxArtist;
		var artists:Array;
		var state="";
		*/
		var aniInit_cc:Number=0;
		var aniInit_run:Boolean=false;
		var aniInit_state:Number=0;
		var aniInit_length:Number=30*5;

		public function VJYExp(){
			vis = this;
		}
		public function init(){
			sys=ns.sys;
			start();
			
		}
		public function doShot(){
			sys.screen.saveScreenShot();
		}
		public function start(){
			
			state="start";
			
			overlayCtrls= new VJYOverlayCtrl();
			overlayCtrls.wDimX=wDimX;
			overlayCtrls.wDimY=wDimY;
			overlayCtrls.anal=ns.scene.anal;
			overlayCtrls.ns=ns;
		
			addChild(overlayCtrls);
			overlayCtrls.init();
			
			if(ns.sys.screen.landing){
				overlayCtrls.visible=false;
				var cLandingWin:Class = getDefinitionByName("LandingWin") as Class;
				var cLandingShade:Class = getDefinitionByName("LandingShade") as Class;
				
				var cMenuItem = getDefinitionByName("MenuItem") as Class;
				var cButtMenu = getDefinitionByName("ButtCircMenu") as Class;
				var cButtHelp = getDefinitionByName("ButtCircHelp") as Class;
				var cButtScreenShot = getDefinitionByName("ButtCircScreenShot") as Class;
				var cButtReset = getDefinitionByName("ButtCircReset") as Class;
			
			landingShade = new cLandingShade();
			addChild(landingShade);
			landingWin = new cLandingWin();
			addChild(landingWin);
			landingWin.stop();

			landingWin["buttLogo"].addEventListener(MouseEvent.CLICK,onLogo,0,0,1);

			//add menus
			scenes=sys.cloud.scenes;
			for(var i=0;i<scenes.length;i++){
				var mm = new cMenuItem();
				var imgc=getDefinitionByName("thumb"+scenes[i].name) as Class;
				var img=new imgc();
				mm.img.addChild(img);
				mm.tf.text=sys.cloud.RScenes.NS[scenes[i].name].name;

				mm.x=(i%3)*148;
				mm.y=(Math.floor(i/3))*150-2;
				mm.scaleX=0.89;
				mm.scaleY=0.89;
				mm.butt.addEventListener(MouseEvent.CLICK,onMenuItem,0,0,1);
				mm.name=i;
				landingWin["menus"].addChild(mm);
			}

			buttMenu = new cButtMenu();
			buttMenu.addEventListener(MouseEvent.CLICK,onMenu,0,0,1);
			buttMenu.visible=false;
			addChild(buttMenu);
			buttHelp = new cButtHelp();
			buttHelp.addEventListener(MouseEvent.CLICK,onHelp,0,0,1);
			buttHelp.visible=false;
			addChild(buttHelp);
			buttScreenShot = new cButtScreenShot();
			buttScreenShot.addEventListener(MouseEvent.CLICK,onScreenShot,0,0,1);
			buttScreenShot.visible=false;
			addChild(buttScreenShot);
			buttReset = new cButtReset();
			buttReset.addEventListener(MouseEvent.CLICK,onReset,0,0,1);
			buttReset.visible=false;
			addChild(buttReset);

			}
			
			onResize();
			aniInit_run=true;
			onEF();
			
		}
		var sButtMenu=1;
		public function onResize(e=null){
			wDimX=sys.screen.wDimX;
			wDimY=sys.screen.wDimY;
			
			sButtMenu=wDimY/768;
			
			buttMenu.scaleX=sButtMenu;
			buttMenu.scaleY=sButtMenu;
			buttHelp.scaleX=sButtMenu;
			buttHelp.scaleY=sButtMenu;
			buttScreenShot.scaleX=sButtMenu;
			buttScreenShot.scaleY=sButtMenu;
			buttReset.scaleX=sButtMenu;
			buttReset.scaleY=sButtMenu;
			
			buttMenu.x=15;
			buttMenu.y=15;
			buttHelp.x=wDimX-15-45*sButtMenu;
			buttHelp.y=15;
			buttScreenShot.x=15;
			buttScreenShot.y=wDimY-15-buttScreenShot.height;
			buttReset.x=wDimX-15-45*sButtMenu;
			buttReset.y=wDimY-15-45*sButtMenu;
			
			
			//Logo -> Win
			var ss=wDimY/640; //Math.max(wDimY/640,wDimX/640);
			landingWin.scaleX=ss;
			landingWin.scaleY=ss;
			landingWin.x=wDimX/2;
			landingWin.y=wDimY/2;
			
			landingShade.width=wDimX;
			landingShade.height=0; //wDimY/24;
			landingShade.x=0;
			landingShade.y=wDimY*(1-1/24)/2;
		//	landingShade.visible=false;
			
			overlayCtrls.wDimX=wDimX;
			overlayCtrls.wDimY=wDimY;
			overlayCtrls.onResize();

			sys.io.wLimTop=overlayCtrls.wLimTop;
			sys.io.wLimBottom=overlayCtrls.wLimBottom;
		}

		public var showCtrls:Boolean=true;
		public function openNextScene(sc:Boolean=true){
			showCtrls=sc;
			openScene(sceneInd+1);
		}
		function onMenuItem(e:MouseEvent){
			var ind=e.target.parent.name;
			trace("!!!!!!!!!!!!!!!"+ind);
			openScene(ind);
		}
		var sceneInd:Number=0;
		function openScene(ind){
			sceneInd=(ind%scenes.length);
			ns.scene.setScene(scenes[sceneInd].name,{"rebuild":true,"sceneFlags":true});
			landingWin.visible=false;
			buttMenu.visible=showCtrls;
			buttHelp.visible=showCtrls;
			buttScreenShot.visible=showCtrls;
			buttReset.visible=showCtrls;
			overlayCtrls.updateScene();
			overlayCtrls.visible=showCtrls;
		}
		function onMenu(e){
			overlayCtrls.visible=false;
			buttMenu.visible=false;
			landingWin.visible=true;
			buttHelp.visible=false;
			buttScreenShot.visible=false;
			buttReset.visible=false;
		}
		function onHelp(e){
			overlayCtrls.toggleHelp();
		}
		function onReset(e){
			overlayCtrls.reset();
		}
		function onScreenShot(e){
			var win = new OverlayScreenshot();
			win.x=wDimX/2;
			win.y=wDimY/2;
			win.scaleX=sButtMenu;
			win.scaleY=sButtMenu;
			addChild(win);
			if(cameraRoll==null) cameraRoll = new CameraRoll();
			var bmpD:BitmapData=ns.sys.screen.getScreenShot();
			cameraRoll.addBitmapData(bmpD);
			bmpD.dispose();
		}
		function onLogo(e){
			navigateToURL(new URLRequest("http://vjyourself.com"));
		}
		
		public function onEF(e=null){
		//	landingShade.visible=false;
			if(state=="start"){
				overlayCtrls.onEF();
				if(aniInit_run){
					switch(aniInit_state){
						case 0:
						aniInit_cc++;
						var p=aniInit_cc/6;
						if(p>=1){
							aniInit_state=1;
							aniInit_cc=0;
							landingWin.play();
						}
						landingShade.width=wDimX;
						landingShade.height=wDimY;
						landingShade.x=0;
						landingShade.y=wDimY/2;
						break;

						case 1:
						aniInit_cc++;
						var p=aniInit_cc/90;
						if(p>=1){
							aniInit_state=2;
							aniInit_cc=0;
						}
						landingShade.width=wDimX;
						landingShade.height=wDimY;
						landingShade.x=0;
						landingShade.y=wDimY/2;
						break;

						case 2:
						aniInit_cc++;
						var p=aniInit_cc/60;//1-Math.cos(aniInit_cc/120*Math.PI/2);
						if(p>=1){
							p=1;aniInit_run=false;
							//landingWin["menus"].visible=true;
							landingShade.visible=false;
						}
						var h=1-p;
						landingShade.alpha=h;
						/*
						landingShade.width=wDimX;
						landingShade.height=wDimY*h;
						landingShade.x=0;
						landingShade.y=wDimY/2;*/
						break;
					}
				}
				
			}
			
		}
		
	}
}