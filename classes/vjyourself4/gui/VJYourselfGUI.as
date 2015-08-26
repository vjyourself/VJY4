package vjyourself4.gui{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import vjyourself4.sys.WinConsoleLong;
	import flash.display.SimpleButton;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class VJYourselfGUI  extends Sprite{
		public var sys:Object;
		public var game:Object;
		var shade:ShadeApp;
		public var console:Object;
		public var consoleMini:Object;
		//public var guiMsg:GUIMsg;
		/*
		var winLanding:WinAppLanding;
		var boxControl:BoxControl;
		var boxArtist:BoxArtist;
		var artists:Array;
		var state="";
		*/
		public function VJYourselfGUI(){
			
		}
		public function init(){
			//guiMsg = new GUIMsg();
			//addChild(guiMsg);
			//shade = new ShadeApp();
			//addChild(shade);
			console = new WinConsoleLong();
			consoleMini = new WinConsoleMini();
			addChild(console as Sprite);
			addChild(consoleMini as Sprite);
			console.x=(stage.stageWidth-console.width)/2;
			console.y=(stage.stageHeight-console.height)/2;
			consoleMini.x=(stage.stageWidth)/2;
			consoleMini.y=0;
			consoleMini.visible=false;
			
			
			
		}
		public function doShot(){
			//sys.screen.saveScreenShot();
		}
		public function start(){
			//setState("menu");
			//trace("mikk");
			/*
			if(sys.input.gamepad_enabled){
				sys.input.gamepadManager.events.addEventListener("Gamepad0_RB",doShot,0,0,1);
			}*/
			//console.visible=false;
			//console.enabled=false;
			//console.clear();
			//removeChild(console as Sprite);
			
			//shade.visible=false;
		//	removeChild(shade);
			/*
			winLanding = new WinAppLanding();
			addChild(winLanding);
			// winLanding.buttStart.addEventListener(MouseEvent.CLICK,onStart,0,0,1);
			winLanding.buttFullscreen.addEventListener(MouseEvent.CLICK,onFullScreen,0,0,1);
			winLanding.buttSubmit.addEventListener(MouseEvent.CLICK,onSubmit,0,0,1);
			
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
			//consoleMini.visible=false;
		}
		public function onResize(e=null){
			consoleMini.x=sys.screen.wDimX/2;
			consoleMini.y=0;
			var s=sys.screen.wDimX/1920;
			consoleMini.scaleX=s;
			consoleMini.scaleY=s;

			console.x=(sys.screen.wDimX-console.width)/2;
			console.y=(sys.screen.wDimY-console.height)/2;
			/*
			shade.x=0;
			shade.width=sys.screen.wDimX;
			shade.height=sys.screen.wDimY;
			winLanding.x=(sys.screen.wDimX-winLanding.width)/2;
			winLanding.y=(sys.screen.wDimY-winLanding.height)/2;
			boxControl.x=0;
			boxControl.y=sys.screen.wDimY-34;
			boxArtist.x=(sys.screen.wDimX-boxArtist.width)/2;
			boxArtist.y=-2;
			*/
		}
		function onEF(e){
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