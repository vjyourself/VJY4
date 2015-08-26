package vjyourself4.gui{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import vjyourself4.sys.WinConsoleLong;
	import flash.display.SimpleButton;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;

	public class VJYourselfGUI_IOS  extends Sprite{
		public var wDimX:Number;
		public var wDimY:Number;
		public var sys:Object;
		public var game:Object;
		var shade:ShadeApp;
		public var console:Object;
		public var consoleMini:Object;
		var winLanding:Sprite;
		var scenes:Array;
		var buttMenu;
		var overlayCtrls:VJYOverlayCtrl;
		public var state:String="";
		//public var guiMsg:GUIMsg;
		/*
		var winLanding:WinAppLanding;
		var boxControl:BoxControl;
		var boxArtist:BoxArtist;
		var artists:Array;
		var state="";
		*/
		public function VJYourselfGUI_IOS(){
			
		}
		public function init(){
			wDimX=stage.stageWidth;
			wDimY=stage.stageHeight;
			//guiMsg = new GUIMsg();
			//addChild(guiMsg);
			console = new WinConsoleLong();
			consoleMini = new WinConsoleMini();
			addChild(console as Sprite);
			addChild(consoleMini as Sprite);
			console.x=(stage.stageWidth-console.width)/2;
			console.y=(stage.stageHeight-console.height)/2;
			consoleMini.x=(stage.stageWidth)/2;
			consoleMini.y=0
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
			state="init";
			
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
			overlayCtrls.sys=sys;
			overlayCtrls.game=game;
			addChild(overlayCtrls);
			overlayCtrls.init();
			
			if(sys.screen.landing){
				overlayCtrls.visible=false;
				var cWinLanding:Class = getDefinitionByName("WinLanding") as Class;
				var cMenuItem = getDefinitionByName("MenuItem") as Class;
				var cButtTriMenu = getDefinitionByName("ButtTriMenu") as Class;
			winLanding = new cWinLanding();
			addChild(winLanding);
			//add menus
			scenes=sys.cloud.scenes;
			for(var i=0;i<scenes.length;i++){
				var mm = new cMenuItem();
				mm.tf.text=sys.cloud.RScenes.NS[scenes[i].name].name;
				mm.x=150+(i%2)*265;
				mm.y=355+(Math.floor(i/2))*40;
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
			//consoleMini.visible=false;
		}
		function onMenuItem(e:MouseEvent){
			var ind=e.target.parent.name;
			trace("!!!!!!!!!!!!!!!"+ind);
			game.ns.scene.setScene(scenes[ind].name,{"rebuild":true,"sceneFlags":true});
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
			if(consoleMini){
				consoleMini.x=wDimX/2;
				consoleMini.y=0;
				var s=wDimX/1920;
				consoleMini.scaleX=s;
				consoleMini.scaleY=s;
			}
			if(winLanding){
				winLanding.x=0;
				winLanding.y=(wDimY-winLanding.height)/2;
				winLanding["shade"].width=wDimX;
				winLanding["mid"].x=(wDimX-winLanding["mid"].width)/2
			}
			/*
			shade.x=0;
			shade.width=sys.screen.wDimX;
			shade.height=sys.screen.wDimY;
			
			boxControl.x=0;
			boxControl.y=sys.screen.wDimY-34;
			boxArtist.x=(sys.screen.wDimX-boxArtist.width)/2;
			boxArtist.y=-2;
			*/
			overlayCtrls.wDimX=wDimX;
			overlayCtrls.wDimY=wDimY;
			overlayCtrls.onResize();
		}
		public function onEF(e){
			if(state=="start"){
				overlayCtrls.onEF();
				game.ns.scene.anal.setInput(0,overlayCtrls.A0);
				game.ns.scene.anal.setInput(1,overlayCtrls.A1);
				game.ns.scene.anal.setInput(2,overlayCtrls.A2);
				game.ns.scene.anal.setInput(3,overlayCtrls.A3);

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