package vjyourself4.gui{
	import flash.display.Sprite;
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
	
	
		var winLanding:Sprite;
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
		var winLanding:WinAppLanding;
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
				var cWinLanding:Class = getDefinitionByName("WinLanding") as Class;
				var cMenuItem = getDefinitionByName("MenuItem") as Class;
				var cButtMenu = getDefinitionByName("ButtCircMenu") as Class;
				var cButtHelp = getDefinitionByName("ButtCircHelp") as Class;
				var cButtScreenShot = getDefinitionByName("ButtCircScreenShot") as Class;
				var cButtReset = getDefinitionByName("ButtCircReset") as Class;
			winLanding = new cWinLanding();
			addChild(winLanding);
			winLanding["mid"].visible=false;
			//add menus
			scenes=sys.cloud.scenes;
			for(var i=0;i<scenes.length;i++){
				var mm = new cMenuItem();
				var imgc=getDefinitionByName("thumb"+scenes[i].name) as Class;
				var img=new imgc();
				mm.img.addChild(img);
				mm.tf.text=sys.cloud.RScenes.NS[scenes[i].name].name;

				mm.x=45+(i%3)*145-280;
				mm.y=305+(Math.floor(i/3))*145-280;
				mm.butt.addEventListener(MouseEvent.CLICK,onMenuItem,0,0,1);
				mm.name=i;
				winLanding["mid"].addChild(mm);
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
			buttHelp.x=wDimX-15-buttHelp.width;
			buttHelp.y=15;
			buttScreenShot.x=15;
			buttScreenShot.y=wDimY-15-buttScreenShot.height;
			buttReset.x=wDimX-15-buttReset.width;
			buttReset.y=wDimY-15-buttReset.height;
			
			winLanding.x=0;
			winLanding.y=0;
			//mid
			var sMid:Number=wDimY/768;
			winLanding["mid"].scaleX=sMid;
			winLanding["mid"].scaleY=sMid;
			winLanding["mid"].x=wDimX/2;
			winLanding["mid"].y=wDimY/2;
			
			winLanding["shade"].width=wDimX;
			winLanding["shade"].height=wDimY/24;
			winLanding["shade"].x=0;
			winLanding["shade"].y=wDimY*(1-1/24)/2;
		//	winLanding["shade"].visible=false;

			winLanding["shade2"].width=wDimX/24;
			winLanding["shade2"].height=wDimY;
			winLanding["shade2"].x=wDimX*(1-1/24)/2;
			winLanding["shade2"].y=0;
			winLanding["shade2"].visible=false;
			
			overlayCtrls.wDimX=wDimX;
			overlayCtrls.wDimY=wDimY;
			overlayCtrls.onResize();

			sys.input.wLimTop=overlayCtrls.wLimTop;
			sys.input.wLimBottom=overlayCtrls.wLimBottom;
		}

		public function openNextScene(){
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
			winLanding.visible=false;
			buttMenu.visible=true;
			buttHelp.visible=true;
			buttScreenShot.visible=true;
			buttReset.visible=true;
			overlayCtrls.updateScene();
			overlayCtrls.visible=true;
		}
		function onMenu(e){
			overlayCtrls.visible=false;
			buttMenu.visible=false;
			winLanding.visible=true;
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
		
		public function onEF(e=null){
		//	winLanding["shade"].visible=false;
			if(state=="start"){
				overlayCtrls.onEF();
				if(aniInit_run){
					switch(aniInit_state){
						case 0:
						aniInit_cc++;
						var p=aniInit_cc/10;
						if(p>=1){
							aniInit_state=1;
							aniInit_cc=0;
						}
						winLanding["shade"].width=wDimX;
						winLanding["shade"].height=wDimY;
						winLanding["shade"].x=0;
						winLanding["shade"].y=0;
						break;

						case 1:
						aniInit_cc++;
						var p=aniInit_cc/200;
						if(p>=1){
							p=1;aniInit_run=false;
							winLanding["mid"].visible=true;
						}
						var h=(1/24+(23/24)*(1-p));
						winLanding["shade"].width=wDimX;
						winLanding["shade"].height=wDimY*h;
						winLanding["shade"].x=0;
						winLanding["shade"].y=wDimY*(1-h)/2;
						break;
					}
				}
				/*
				ns.scene.anal.setInput(0,overlayCtrls.A0);
				ns.scene.anal.setInput(1,overlayCtrls.A1);
				ns.scene.anal.setInput(2,overlayCtrls.A2);
				//trace("!!",overlayCtrls.A3);
				ns.scene.anal.setInput(3,overlayCtrls.A3);
				*/
				//game.ns.inputVJY.ctrlsA[0]=overlayCtrls.A0;
				//game.ns.inputVJY.ctrlsA[1]=overlayCtrls.A1;
				//game.ns.inputVJY.ctrlsA[2]=overlayCtrls.A2;
				//game.ns.inputVJY.ctrlsA[3]=overlayCtrls.A3;
			}
			/*
			if(state=="game"){
			boxControl.tfSpeed.text=""+Math.round(game.inputVJY.speed/game.inputVJY.speedMax*100);
			boxControl.tfRotate.text=""+Math.round(game.inputVJY.cameraRotZ);
			}
			*/
		}
		/*
		function onStart(e:MouseEvent){
			setState("game");
			winLanding.visible=false;
			shade.visible=false;
			boxArtist.visible=true;
			boxControl.visible=true;
			var ind=e.target.parent.name;
			var th=artists[ind].n;
			boxArtist.tfArtist.text=artists[ind].name;
			sys.cloud.C3D.NS["multiA"]=sys.cloud.C3D.NS[th];
			sys.cloud.C3D.NS["multiB"]=sys.cloud.C3D.NS[th];
			game.gameWays.destroyPRGs();
			game.gameWays.startPRG(game.gameWays.currPrgName);
		}
		function onMenu(e){
			setState("menu");
			boxControl.visible=false;
			winLanding.visible=true;
			shade.visible=true;
			boxArtist.visible=false;
			
		}
		function setState(s){
			state=s;
			switch(state){
				case "menu":
				game.inputVJY.speedMin=0.1;
				game.inputVJY.speed=0.1;
				game.inputVJY.cameraRotXMax=30;
				game.inputVJY.cameraRotYMax=30;
				break;
				case "game":
				game.inputVJY.speedMin=1;
				game.inputVJY.speed=1;
				game.inputVJY.cameraRotXMax=60;
				game.inputVJY.cameraRotYMax=60;
				break;
			}
		}
		function onSubmit(e){
			navigateToURL(new URLRequest("http://www.openartapp.com/"),"_blank");
		}
		function onFullScreen(e){
			sys.screen.toggleFullscreen();
		};
		*/
	}
}