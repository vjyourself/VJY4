package vjyourself4{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import vjyourself4.dson.LoadJson;
	import vjyourself4.dson.DataTransform;

	import vjyourself4.gui.*;
	import vjyourself4.sys.SystemServices;
	import vjyourself4.games.*;
	import vjyourself4.comp.*;
	import vjyourself4.three.lights.*;
	import vjyourself4.overlay.*;
	import vjyourself4.games.GP.*;
	import vjyourself4.ctrl.*;
	import vjyourself4.cloud.*;
	import vjyourself4.timeline.*;
	
	public class VJYourself extends MovieClip{
		public var _meta:Object={name:"App"};

		//Init
		var medium:String="";
		var cloud1:Object={online:false,path:""};
		var cloud:Object={online:false,path:""};
	
		var startFile:String="";
		
		var loadJson:LoadJson;
		var loadInit:LoadJson;
		var plugins:Array;
		//var ctrlPrgTheme:CtrlPrgTheme;
		//var guiMsg:GUIMsg;
		var state:String="";
		var sys:SystemServices;
		var game:Game4;
		var gui:VJYourselfGUI;
		var initObj:Object;
		var projObj:Object;
		var vis:Sprite;
		var back:Sprite;
		var backWidth:Number=0;
		var backHeight:Number=0;
		var back2:Sprite;
		var back2Width:Number=0;
		var back2Height:Number=0;
		var params:Object;
		
		function VJYourself(){

			ContextManager;
			CompManager;
			CompFilters;

			SceneManager;
			SceneVary;

			//CTRL
			GamepadCombo;
			Gamepad;
			Grammar;
			CtrlMIDI;
			CommandList;
			CtrlKey;
			BindRouter;
			CtrlCameraMode;
			SpaceProgress;
			AnyRouter;
			LiveBuilderManager;
			GamepadMapper;

			//COMP SCENE
			ContextLocal;
			CompBox;
			CompGridBox;
			CtrlSky;
			CompCentralObjs;			
			Lights;
			
			//Overlay
			OverlayAni;
			OverlayAniChannels;
			OverlayAniSeq;
			OverlayAniTrans;
			OverlayVideo;
			OverlayMusicMeta;
			OverlayMusicTimeline;
			OverlayConsole;
			OverlayMask;

			GPSinglePath;
			
			ReloadCloud;
			DynoScene;

			//VJYExp;
			GamepadExp;

			TimelineMusic;
			//VJYFullScene;
			/*
			VisLogo;
			
			OverlayArtist;
			CompSkyBox;
			
			GPSinglePath;
			//GPMultiPath;
			
			TriDir;
			
			CompBlend;
			
			CompCameraAngle;
			
			CompBind;
		
			CtrlGamepadFull;
			
			CtrlAuto
			CtrlSafe
			CtrlSpaceProgress;
			CtrlAnal;

			CtrlRemote;
			
			*/
			//InterGUI;
		}
	
		function log(level,msg){sys.debug.log(this,level,msg);}

		function init(p:Object){
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
			params=p;
			var initFile="init.json"; if(p.initFile!=null) initFile=p.initFile;
			vis = new Sprite();
			addChild(vis);

			if(params.back!=null){
				var backC:Class= getDefinitionByName(params.back.cn) as Class;
				back = new backC();
				vis.addChild(back);
				backWidth=params.back.width;
				backHeight=params.back.height;
			}
			if(params.back2!=null){
				var back2C:Class= getDefinitionByName(params.back2.cn) as Class;
				back2 = new back2C();
				vis.addChild(back2);
				back2Width=params.back2.width;
				back2Height=params.back2.height;
				back2.visible=false;
			}
			resizeBack(stage.stageWidth,stage.stageHeight);

			//init basic GUI
			gui =  new VJYourselfGUI();
			vis.addChild(gui);
			gui.init();

			//init SYS ground zero
			sys = new SystemServices();
			gui.sys=sys;
			sys.console=gui.console;
			sys.consoleMini=gui.consoleMini;
			sys.stage=stage;
			sys.vis=vis;
			sys.events.addEventListener("SCREEN_READY",onScreenReady,0,0,1);
			sys.init0();

			log(1,"Loading init.json");

			//load init.json
			loadInit = new LoadJson();
			loadInit._meta={name:"loader"};
			loadInit._debug=sys.debug;
			loadInit.debug2=true;
			loadInit.debug4=false;
			loadInit.online=false;
			loadInit.globals.root="";
			loadInit.events.addEventListener(Event.COMPLETE,initOnComplete,0,0,1);
			loadInit.start(initFile);
		}

		function onScreenReady(e){
			sys.events.removeEventListener("SCREEN_READY",onScreenReady);
			sys.screen.events.addEventListener(Event.RESIZE,onResize,0,0,1);
			onResize();
		}
		function initOnComplete(e){
			initObj = loadInit.trans.data;
			
			medium=initObj.init.medium;
			cloud1.online=initObj.init.cloud1.online;
			cloud1.path=cloud1.online?initObj.init.cloud1.online_path:initObj.init.cloud1.offline_path;
			cloud.online=initObj.init.cloud.online;
			cloud.path=cloud.online?initObj.init.cloud.online_path:initObj.init.cloud.offline_path;
			startFile=initObj.init.startFile;

			log(1,"online: cloud1:"+cloud1.online+" cloud:"+cloud.online);
			log(1,"medium: "+medium+" start:"+startFile);
			
			loadProject();
		}
		
		//Load File INIT
		function loadProject(){
			trace("sdfsdf");
			//urlpre="";
			log(1,"Loading project.json");

			loadJson = new LoadJson();
			loadJson._meta={name:"loader"};
			loadJson._debug=sys.debug;
			loadJson.debug2=true;
			loadJson.debug4=false;
			loadJson.online=cloud1.online;
			loadJson.globals={medium:medium,cloud1:cloud1.path,cloud:cloud.path,player:""};
			loadJson.events.addEventListener(Event.COMPLETE,projectOnComplete,0,0,1);
			loadJson.start(startFile);
		}
		
		//Activate SYS
		function projectOnComplete(e){
			projObj=loadJson.trans.data;
			projObj.sys.cloud.cloud1=cloud1;
			projObj.sys.cloud.cloud2=cloud;
			sys.proj=projObj.proj;

			log(1,"Starting SYS");
			
			sys.params=projObj.sys;
			sys.events.addEventListener("READY",sysReady,0,0,1);
			sys.init();
		}
		var startGameCounter:Boolean=false;
		var startGameCounter_cc:int=0;
		var startGameCounter_delay:int=0;
		//Create-Start GAME
		function sysReady(e){
			startGameCounter=true;
			startGameCounter_cc=0;
			startGameCounter_delay=30;
			if(back!=null){
				back.visible=false;
				vis.removeChild(back);
				back=null;
				if(back2!=null) back2.visible=true;
			}
		}
		function startGame(){
			log(1,"Starting Game > >");
			//no input
			//sys.input.def="none";
			//game
			game = new Game4();
			game._debug=sys.debug;
			game.sys=sys;
			game.app=this;
			game.params=projObj.game;
			//game.guiMsg=gui.guiMsg;
			game.init();
			vis.addChild(game.vis);
			vis.swapChildren(game.vis,gui);
			
			gui.sys=sys;
			gui.game=game;
			gui.start();
		}
		
		function resizeBack(dimX,dimY){
			if(back!=null){
				var ss=Math.max(dimX/backWidth,dimY/backHeight);
				back.scaleX=ss;
				back.scaleY=ss;
			}
			if(back2!=null){
				var ss=dimY/back2Height;
				back2.scaleX=ss;
				back2.scaleY=ss;
				back2.x=dimX/2;
				back2.y=dimY/2;	
			}
		}
		public function onResize(e=null){
			//trace("RRRR EEE SIIZIIZIZ");
			resizeBack(sys.screen.wDimX,sys.screen.wDimY);
			
			gui.onResize();
		}
		
		function onEF(e){
			if(startGameCounter){
				startGameCounter_cc++;
				if(startGameCounter_cc>=startGameCounter_delay){
					startGameCounter=false;
					startGame();
				}
			}
			//back["img"].rotation+=1;
		}

	}
}

