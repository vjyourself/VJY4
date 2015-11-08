package vjyourself4.timeline{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.dson.TransJson;
	
	public class TimelineMusic{
		public var _debug:Object;
		public var _meta:Object={name:"Timeline"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var input;
		public var music;
		
		var track:Array;
		var trackInd:Number;
		var section:Object;
		var frames:Array;
		var framesInd:Number;
		var state:String="";
		var pre:Number=0;
		var ppos:Number=0;

		var path_length:Number;
		var path_speed:Number;
		
		public function TimelineMusic(){}
		var initSeq=-1;
		public function init(){
			initSeq=0;
		}
		public function init1(){
			
			path_length=ns.mid.cs.GP.ctrlPath.beforeMe;
			path_speed=ns.mid.cs.GP.ctrlMovement.speedMin;

			//global pre
			if(params.pre!=null) pre=params.pre;
			input=ns.input;
			music=ns.sys.music;
			music.events.addEventListener("START",onMusicStart);

			frames=TransJson.clone(params.frames);
			for(var i=0;i<frames.length;i++){
				var ff=frames[i];
				if(ff.time!=null) ff.time=timeStrToSec(ff.time)*1000-pre;
				else if(ff.beat!=null) ff.time=music.meta.struct.beatToTime(ff.beat)-pre;
				if(ff.pre!=null) ff.time-=ff.pre;
				if(ff.path_synch!=null){
					var pr=(path_length-ff.path_synch.pixelShift)/(path_speed*60)*1000;
					ff.time-=pr;
				}
			}

			frames.sortOn("time",Array.NUMERIC);
			framesInd=-1;
			ppos=0;

		}
		
		public function onMusicStart(e){
			state="run";
			framesInd=-1;
		}

		public function onEF(e=null){
			if(initSeq<3){
				initSeq++;
				if(initSeq==3) init1();
			}
			if(state=="run"){
				var pos=music.playback.sndCh.position;
				if(ppos<pos){
					ppos=pos;
					if(framesInd<frames.length-1){
						var nextFrame=frames[framesInd+1];
						if(nextFrame.time<=pos) doFrame(framesInd+1);
					}
				}
				//if restarred::
				if(ppos>pos){
					ppos=0;
					framesInd=-1;
				}
			}
		}
		
		
		/* Do Frame */
		function doFrame(fr){
			framesInd=fr;
			var comm=frames[framesInd].comm;
			var tar=Eval.evalString(ns,comm[0]);
			tar[comm[1]].apply(tar,comm[2]);
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
	}
}