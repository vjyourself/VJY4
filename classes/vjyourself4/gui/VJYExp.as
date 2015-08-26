package vjyourself4.gui{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import vjyourself4.sys.WinConsoleLong;
	import flash.display.SimpleButton;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;

	public class VJYExp  extends Sprite{
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
			//setState("menu");
			trace("mikk");
			trace("#################################################");
			//trace(JSON.stringify(sys.cloud.scenes));
			/*
			if(sys.input.gamepad_enabled){
				sys.input.gamepadManager.events.addEventListener("Gamepad0_RB",doShot,0,0,1);
			}*/
			//console.visible=false;
			//console.enabled=false;
			//console.clear();
			//removeChild(console as Sprite);
			
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
				var cButtTriMenu = getDefinitionByName("ButtTriMenu") as Class;
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
				mm.x=85+(i%2)*183;
				mm.y=240+(Math.floor(i/2))*115;
				mm.butt.addEventListener(MouseEvent.CLICK,onMenuItem,0,0,1);
				mm.name=i;
				winLanding["mid"].addChild(mm);
			}
			buttMenu = new cButtTriMenu();
			buttMenu.x=15;
			buttMenu.y=15;
			buttMenu.addEventListener(MouseEvent.CLICK,onMenu,0,0,1);
			buttMenu.visible=false;
			addChild(buttMenu);
			}
			// winLanding.buttStart.addEventListener(MouseEvent.CLICK,onStart,0,0,1);
			//winLanding.buttFullscreen.addEventListener(MouseEvent.CLICK,onFullScreen,0,0,1);
			//winLanding.buttSubmit.addEventListener(MouseEvent.CLICK,onSubmit,0,0,1);
			
			/*
			boxControl = new BoxControl();
			addChild(boxControl);
			boxControl.buttMenu.addEventListener(MouseEvent.CLICK,onMenu,0,0,1);
			boxControl.visible=false;
			sys.screen.events.addEventListener(Event.RESIZE,onResize,0,0,1);
			
			boxArtist = new BoxArtist();
			addChild(boxArtist);
			boxArtist.visible=false;
			
			//get artists
			var ca=sys.cloud.C3D.NS["Artists"];
			artists=[];
			for(var i=1;i<ca.length;i++) {artists.push(ca[i]);trace("AAA:"+ca[i].name);}
			
			var xx=0;var yy=0;
			for(var i=0;i<artists.length;i++){
				var it=new ItemArtist();
				it.tfName.text=artists[i].name;
				winLanding.addChild(it);
				it.x=60+xx*174;
				it.y=164+yy*34;
				it.butt.addEventListener(MouseEvent.CLICK,onStart,0,0,1);
				it.name=i;
				xx++;if(xx>=2){xx=0;yy++}
			}
			*/
			onResize();
			aniInit_run=true;
			onEF();
			//consoleMini.visible=false;
		}
		function onMenuItem(e:MouseEvent){
			var ind=e.target.parent.name;
			trace("!!!!!!!!!!!!!!!"+ind);
			ns.scene.setScene(scenes[ind].name,{"rebuild":true,"sceneFlags":true});
			winLanding.visible=false;
			buttMenu.visible=true;
			overlayCtrls.updateScene();
			overlayCtrls.visible=true;
		}
		function onMenu(e){
			overlayCtrls.visible=false;
			buttMenu.visible=false;
			winLanding.visible=true;
		}
		public function onResize(e=null){
			wDimX=sys.screen.wDimX;
			wDimY=sys.screen.wDimY;
			
			/*
			shade.x=0;
			shade.width=sys.screen.wDimX;
			shade.height=sys.screen.wDimY;
			
			boxControl.x=0;
			boxControl.y=sys.screen.wDimY-34;
			boxArtist.x=(sys.screen.wDimX-boxArtist.width)/2;
			boxArtist.y=-2;
			*/
			
			var sButtMenu=wDimY/768;
			
			buttMenu.scaleX=sButtMenu;
			buttMenu.scaleY=sButtMenu;
			
			buttMenu.x=15;
			buttMenu.y=15;


			winLanding.x=0;
			winLanding.y=0;
			//mid
			var sMid:Number=wDimY/768;
			winLanding["mid"].scaleX=sMid;
			winLanding["mid"].scaleY=sMid;
			winLanding["mid"].x=(wDimX-560)/2;
			winLanding["mid"].y=(wDimY-550)/2;
			
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
		public function onEF(e=null){
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