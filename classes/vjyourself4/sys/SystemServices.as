package vjyourself4.sys {
	import flash.display.Sprite
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.DisplayObject;
	import flash.display.BlendMode;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.media.Video;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	//import flash.system.SecurityDomain;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.system.Capabilities;
	
	import vjyourself4.sys.EnterFrame;
	import vjyourself4.input.InputManager;
	import vjyourself4.media.Music;
	import vjyourself4.sys.MetaStream;
	import vjyourself4.cloud.Cloud;
	//import vjyourself4.factory.FactoryVisual;
	
	
	public class SystemServices{
		//META
		public var _meta={name:"SYS"};
		
		public var platform:String="";
		public var browser:Boolean=false;
		
		//INPUT
		public var params:Object;
		var initObj:Object;
		public var stage:Stage;
		
		
		//SERVICES
		public var proj:Object;
		public var globalContext:LoaderContext;
		public var debug:MetaStream;
		public var console:Object;
		public var consoleMini:Object;
		public var enterframe:EnterFrame;
		
		public var screen:ScreenManager;
		public var input:InputManager;
		public var music:Music;
		public var midi:MidiInput;
		public var cloud:Object;
		public var arduino:Arduino;
		
		public var video:Video;
	//	public var factory:FactoryVisual;
		public var vis:Sprite;
		
		public var gui:Object={};
		
		//Events / States
		public var events:EventDispatcher = new EventDispatcher();
		public var ready=false;
		
		
		public function SystemServices(){}
		public function log(level,msg){debug.log(this,level,msg);}
	
		
		//INIT1 :: GlobalContext / Screen / Debug / Components
		public function init0(){

			//Debug
			debug = new MetaStream();
			if(console!=null) debug.registerConsole(console);
			if(consoleMini!=null) debug.registerConsoleMini(consoleMini);
			log(1,"INIT...");
			
			//capabilities
			browser = false;
			switch(Capabilities.playerType){
				case "ActiveX":
				case "PlugIn":
				browser=true;
				break;
				
				case "Desktop":
					//AIR
				break;
				
				case "StandAlone":
					//SA flash
				break;
				
				case "External":
					//in flash CC test
				break;
			}
			log(1,"browser: "+browser);
			// "ActiveX" for the Flash Player ActiveX control used by Microsoft Internet Explorer
			// "PlugIn" for the Flash Player browser plug-in (and for SWF content loaded by an HTML page in an AIR application)
			
			// "Desktop" for the Adobe AIR runtime (except for SWF content loaded by an HTML page, which has Capabilities.playerType set to "PlugIn")
			// "StandAlone" for the stand-alone Flash Player
			
			// "External" for the external Flash Player or in test mode
			var oos=Capabilities.os.toLowerCase();
			platform="Mac";
			if(oos.indexOf("windows")>=0) platform="Win";
			if(oos.indexOf("linux")>=0) platform="Linux";
			log(1,"platform: "+platform);
			//
			globalContext =new LoaderContext(false,ApplicationDomain.currentDomain);
			//globalContext.securityDomain=SecurityDomain.currentDomain;
			if(params==null)params={};
			
			//enterframe
			enterframe = new EnterFrame();
			enterframe.stage=stage;
			enterframe.mstream=debug;
			enterframe.init();
			enterframe.events.addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
		}

		public function init(){
			//debug parameters
			for(var i in params.debug) debug[i]=params.debug[i];
			debug.init();

			//screen
			screen = new ScreenManager();
			var screenParams={};if(params.screen!=null)screenParams=params.screen;
			for(var i in screenParams) screen[i]=screenParams[i];
			screen.stage=stage;
			screen._debug=debug;
			screen.vis=vis;
			screen.init();
			enterframe.setFps(screen.fps);
			
			if(screen.ready) init2(); else screen.events.addEventListener("READY",screenOnReady,0,0,1);
		}
		
		function screenOnReady(e){
			screen.events.removeEventListener("READY",screenOnReady);
			
			init2();
		}
		
		
		//INIT2 Factory / Enterfrane / Input / Music / Cloud
		function init2(e=null){
			events.dispatchEvent(new Event("SCREEN_READY"));
				//log(1,"Factory");
				//factory
				//factory=new FactoryVisual();
							
				
			
				//input
				log(1,"Input");
				input = new InputManager();
				var inputInitObj ={}; if(params.input!=null) inputInitObj = params.input;
				input.wDimX=screen.wDimX;
				input.wDimY=screen.wDimY;
				input.stage=stage;
				input._debug=debug;
				input.screen=screen;
				input.sys=this;
				input.init(inputInitObj);
				screen.setInput(input);
				
				//music
				log(1,"Music");
				music = new Music();
				var musicInitObj ={}; if(params.music!=null) musicInitObj = params.music;
				music.mstream=debug;
				music.init(musicInitObj);
				
				//midi
				midi = new MidiInput();
				if(params.midi!=null){
					midi.params=params.midi;
					midi.init();
				}
				
				video = new Video();
				init2b();
			}
		function init2b(e=null){
				//cloud
				if(params.cloud!=null){
					log(1,"Cloud");
					var cloudInitObj = params.cloud;
					cloud = new Cloud();
					cloud._debug=debug;
					cloud.music=music;
					cloud.context=globalContext;
					cloud.init(cloudInitObj);
				}else{cloud = {ready:true};}
				
				if(cloud.ready){
					init3();
				}else{
					//if(screen.terminalEnabled) screen.visTerminal.back.addChild(cloud.vis);
					cloud.events.addEventListener(Event.COMPLETE,cloudOnComplete,0,0,1);
				}
		}
		
		public function cloudOnComplete(e){
			log(1,"Cloud complete");
			//if(screen.terminalEnabled) screen.visTerminal.back.removeChild(cloud.vis);
			cloud.events.removeEventListener(Event.COMPLETE,cloudOnComplete);
			init3();
		}
		
		
			
		function init3(){
			log(1,"READY");
			
			if(params.arduino!=null){
				arduino = new Arduino();
				arduino.input=input;
				arduino.mstream=debug;
				arduino.init(params.arduino);
			}
			//mstream.enabled=false;
			//if(screen.terminalEnabled) screen.visTerminal.visible=false;
			ready=true;
			guiStart();
			events.dispatchEvent(new Event("READY"));
		}

		function guiStart(){
			if(params.screen.gui!=null){
				console.visible=params.screen.gui.console;
				consoleMini.visible=params.screen.gui.consoleMini;
			}
		}
		
		public function onEF(e:Object){
			if(screen!=null) screen.onEF();
			if(input!=null) input.onEF(e);
			if(music!=null) music.onEF();
			if(cloud!=null) cloud.onEF(e);
			if(arduino!=null) arduino.onEF(e);
		}
		
		public function dispose(){
			
		}
		
	}
}
