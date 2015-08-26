package vjyourself3.games{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself3.dson.Eval;
	
	public class CtrlTimelineMusicScenes{
		public var ns:Object;
		public var params:Object;
		public var input;
		public var music;
		
		var track:Array;
		var trackInd:Number;
		var trackSceneLightInd:Number;
		var section:Object;
		var frames:Array;
		var framesInd:Number;
		public var state:String="";
		public var sceneState:String="";
		var ppos:Number=0;

		var timelines:Array;
		var timelinesInd:Number=-1;
		var timeline:Object;
		
		public function CtrlTimelineMusicScenes(){}
		
		public function init(){
			
			input=ns.input;
			music=ns.sys.music;
			timelines=ns.cloud.timelines;
			
			//processCtrl(params,"next",doNext);
			processCtrl(params,"nextSceneLight",doNextSceneLight);
			processCtrl(params,"start",doStart);
			processCtrl(params,"pause",doPause);

			/* parms
				showTime=5,
                init.timelineInd = 0,
                init.trackInd:0
        	*/
			if(params.init.timelineInd!=null) buildTimelineInd(params.init.timelineInd);
				
		}
		
		public function buildTimelineInd(ind){
			timelinesInd=ind;
			buildTimeline(ns.cloud.RTimelines.NS[timelines[ind].name]);
		}
		public function buildTimeline(tl){
			timeline=tl;
			track=timeline.track;
			trackInd=-1;
			if(timeline.speedMin!=null) ns.inputVJY.speedMin=timeline.speedMin;

		}
		function doStart(e=null){
			trackInd=params.init.trackInd;
			timeline.music.pos=timeStrToSec(track[trackInd].time)*1000;
			
			music.play(timeline.music);
			trackInd--;
			trackSceneLightInd=trackInd;
			framesInd=-1;
			state="run";
			sceneState="starting";
		}
		function doPause(e=null){
				music.playback.pause();
		}
		function doNextSceneLight(e=null){
			if(trackSceneLightInd<trackInd){
				trackSceneLightInd++;
				if(track[trackSceneLightInd].type=="scene") ns.scenes.setScene(track[trackSceneLightInd].name,false,{space:false,lighting:true});
			}
			
		}
		function doNext(e=null){
			if(sceneState=="space"){
				ns.scenes.setScene(section.name,false,{space:false,lighting:true});
				sceneState="spaceNlighting";
			}else{
				if(framesInd<frames.length-1){
					framesInd=framesInd+1;
					execFrame(frames[framesInd]);
				}
			}
		};

		public function onEF(e=null){
			
			if(state=="run"){
				var pos=Math.floor(music.playback.sndCh.position/1000);
				if((pos!=ppos)&&(pos%params.showTime==0)){ ns.sys.mstream.logSimple(timeSecToStr(pos));ppos=pos;}
				if(trackInd<track.length-1){
					var nextSection=track[trackInd+1];
					if((timeStrToSec(nextSection.time)+nextSection.dt)<=pos+timeline.pre) startNextSection();
				}
			}
		}
		
		function startNextSection(){
			trackInd++;
			//exec remainig frames
			if(trackInd>0){
				//for(var i=framesInd+1;i<frames.length;i++) execFrame(frames[i]);
			}
			
			switch(track[trackInd].type){
				case "scene":
				section=track[trackInd];
				frames=section.frames;
				framesInd=0;
				ns.sys.mstream.logSimple("> "+section.name);
				ns.scenes.setScene(section.name,(sceneState=="starting"),{space:true,lighting:(sceneState=="starting")});
				if(sceneState=="starting"){ trackSceneLightInd=trackInd;}else{};
				sceneState="scene";
				execFrame(frames[0]);
				break;
				case "perm":
				ns.scenes.setScenePerm(track[trackInd].perm);
				break;
			}
		}
		function timeStrToSec(str){
			var tt=str.split(":");
			return parseInt(tt[0])*60+parseInt(tt[1]);
		}
		function timeSecToStr(sec){
			var mm=Math.floor(sec/60);
			var ss=sec-mm*60;
			var ss_str=""+ss;if(ss_str.length==1) ss_str="0"+ss_str;
			return mm+":"+ss_str;
		}
		/* Exec Frame */
		function execFrame(fr){
			var comm:Array;
			var tar:Object;
			for(var i=0;i<fr.length;i++){
				comm=fr[i];
				tar=Eval.evalString(ns,comm[0]);
				tar[comm[1]].apply(tar,comm[2]);
			}
		}
		public function processCtrl(p,name,func){
			if(p[name]){
				var ct=p[name];
				if((ct.gamepad)&&(ct.gamepad!="")&&input.gamepad_enabled) input.gamepadManager.events.addEventListener("Gamepad0_"+ct.gamepad,func,0,0,1);
				if((ct.click)&&input.mkb_enabled) input.stage.addEventListener(MouseEvent.CLICK,func,0,0,1);
			}
		}
	}
}