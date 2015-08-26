﻿package vjyourself4{

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
		var medium:String=""; // Browser / App / Game 
		var urlLocal:String="";
		var urlCloud:String="";
		var gameType:String="";
		var online:Boolean=false;
		var project:String="";
		var startFile:String;
		
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
			CommandList;
			CtrlKey;
			BindRouter;

			//COMP SCENE
			ContextLocal;
			CompBox;
			CompGridBox;
			CtrlSky;
			CompCentralObjs;			
			Lights;
			
			OverlayAni;
			OverlayAniChannels;
			OverlayAniSeq;
			OverlayAniTrans;
			OverlayVideo;
			OverlayMusicTest;
			OverlayConsole;

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
				var backC:Class= getDefinitionByName("VJYBack") as Class;
				back = new backC();
				vis.addChild(back);
				backWidth=params.back.width;
				backHeight=params.back.height;
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
			
			medium=initObj.init.global.medium;
			online=initObj.init.global.online;
//			gameType=initObj.init.game;
			
			//urlLocal=initObj.init.global.world;
			//urlCloud=initObj.init.urlCloud;
			startFile=initObj.init.start;
			
			log(1,"online: "+online+" medium: "+medium+" start:"+startFile);
			
			//load project
			loadProject();
		}
		
		//Load File INIT
		function loadProject(){
			
			//urlpre="";
			log(1,"Loading project.json");

			loadJson = new LoadJson();
			loadJson._meta={name:"loader"};
			loadJson._debug=sys.debug;
			loadJson.debug2=true;
			loadJson.debug4=false;
			loadJson.online=online;
			loadJson.globals=initObj.init.global;
			//loadJson.globals.root=loadJson.globals.cloud;
			loadJson.events.addEventListener(Event.COMPLETE,projectOnComplete,0,0,1);
			loadJson.start(startFile);
		}
		
		//Activate SYS
		function projectOnComplete(e){
			projObj=loadJson.trans.data;
			projObj.sys.cloud.baseURL=loadJson.globals.cloud;
			projObj.sys.cloud.src=online?"online":"local";
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
