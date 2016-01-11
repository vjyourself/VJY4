package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import vjyourself4.DynamicEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Bitmap;
	
	public class OverlayMusicMeta{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		var wDimX:Number=0;
		var wDimY:Number=0;

		public var ns:Object;
		var beat;
		var timeline;
		public var params:Object;
		var tfStruct:TextField;
		var tfSection:TextField;
		
		

		public var vis:Sprite;
		public var visGap:Number=50;

		var signTrig:MovieClip;
		

		var showWave:Boolean =true;
		var WinWave:Class;
		var winWave:Sprite;

		var showBeat:Boolean =true;
		var WinBeat:Class;
		var winBeat:Sprite;

		var showMixer:Boolean =true;
		var WinMixer:Class;
		var winMixer:Sprite;

		var showKeys:Boolean =true;
		var WinKeys:Class;
		var winKeys:Sprite;

		var BeatSign:Class;
		var LinearSign:Class;
		
		var dot:Sprite;
		var dotA:Sprite;
		var dotB:Sprite;
		
		
		public function OverlayMusicMeta(){
		}
		
		public function init(){
			WinWave = getDefinitionByName("OverlayMusicMeta_Wave") as Class;
			WinBeat = getDefinitionByName("OverlayMusicMeta_Beat") as Class;
			WinMixer = getDefinitionByName("OverlayMusicMeta_Mixer") as Class;
			WinKeys = getDefinitionByName("OverlayMusicMeta_Keys") as Class;
			
			vis = new Sprite();
			vis.x=0;
			vis.y=0;

			//PARAMS
			if(params.visible!=null) vis.visible=params.visible;
			if(params.show==null) params.show={};
			if(params.show.Wave!=null) showWave=params.show.Wave;
			if(params.show.Beat!=null) showWave=params.show.Beat;
			if(params.show.Mixer!=null) showWave=params.show.Mixer;
			if(params.show.Keys!=null) showWave=params.show.Keys;


			if(showWave){
				winWave = new WinWave();
			
				vis.addChild(winWave);
				var bmp = new Bitmap(ns._sys.cloud.R3D.bmpDWave);
				bmp.width=256;
				bmp.height=256;
				winWave["holderBmp"].addChild(bmp);
			}
			if(showBeat){
				winBeat = new WinBeat();
			
				vis.addChild(winBeat);
			}
			if(showMixer){
				winMixer = new WinMixer();
		
				vis.addChild(winMixer);
			}

			if(showKeys){
				winKeys = new WinKeys();
		
				vis.addChild(winKeys);
				var text="";
				for(var i=0;i<params.keys.length;i++) text+=params.keys[i].ch+" : "+params.keys[i].desc+"\n";
				winKeys["keys"].text=text;
			}
			
			onResize();
		}

		public function onResize(e=null){
			visGap=wDimY/40;
			wDimX=ns._sys.screen.wDimX;
			wDimY=ns._sys.screen.wDimY;
			if(showWave){
				
				winWave.x=visGap;
				winWave.y=visGap;
				
			}
			if(showBeat){
				
				winBeat.x=wDimX-visGap-winBeat.width;
				winBeat.y=visGap;
				
			}
			if(showMixer){
				
				winMixer.x=wDimX-visGap-winMixer.width;
				winMixer.y=wDimY-winMixer.height;
				
			}

			if(showKeys){
				
				winKeys.x=visGap;
				winKeys.y=wDimY-winKeys.height;
				
			}
			
		}
		
		public function onEF(e:DynamicEvent){
			if(showWave){
				winWave["peak"].height=256*ns._sys.music.meta.peak;
				winWave["gain"].text="gain: "+Math.round(ns._sys.music.meta.wave_gain*10)/10;
				winWave["drawMode"].text=""+ns._sys.cloud.R3D.waveDrawModeVary[ns._sys.cloud.R3D.waveDrawMode];
				//trace(ns._sys.music.meta.peak);
			}
			if(showBeat){
				var ss = ns._sys.music.meta.beat.A["ASR1_1"].val;
				winBeat["beat1"].scaleX=ss;
				winBeat["beat1"].scaleY=ss;
				ss = ns._sys.music.meta.beat.A["ASR2_1"].val*0.5;
				winBeat["beat2_1"].scaleX=ss;
				winBeat["beat2_1"].scaleY=ss;
				ss = ns._sys.music.meta.beat.A["ASR2_2"].val*0.5;
				winBeat["beat2_2"].scaleX=ss;
				winBeat["beat2_2"].scaleY=ss;
				ss = ns._sys.music.meta.beat.A["ASR4_1"].val*0.5*0.5;
				winBeat["beat4_1"].scaleX=ss;
				winBeat["beat4_1"].scaleY=ss;
				ss = ns._sys.music.meta.beat.A["ASR4_2"].val*0.5*0.5;
				winBeat["beat4_2"].scaleX=ss;
				winBeat["beat4_2"].scaleY=ss;
				ss = ns._sys.music.meta.beat.A["ASR4_3"].val*0.5*0.5;
				winBeat["beat4_3"].scaleX=ss;
				winBeat["beat4_3"].scaleY=ss;
				ss = ns._sys.music.meta.beat.A["ASR4_4"].val*0.5*0.5;
				winBeat["beat4_4"].scaleX=ss;
				winBeat["beat4_4"].scaleY=ss;

				winBeat["bmp"].text = "BPM "+Math.round(ns._sys.music.meta.beat.bpm*10)/10;
				winBeat["ms"].text = Math.round(ns._sys.music.meta.beat.tack)+"ms";
			}

			if(showMixer){
				/*var ss = ns._sys.music.meta.beat.A["ASR1_1"].val;
				winMixer["beat1"].scaleX=ss;
				winMixer["beat1"].scaleY=ss;
				ss = ns._sys.music.meta.beat.A["ASR2_1"].val*0.5;
				winMixer["beat2_1"].scaleX=ss;
				winMixer["beat2_1"].scaleY=ss;
				ss = ns._sys.music.meta.beat.A["ASR2_2"].val*0.5;
				winMixer["beat2_2"].scaleX=ss;
				winMixer["beat2_2"].scaleY=ss;*/
				ss = ns._sys.music.meta.mixer.A["Vary1"].val*0.5;
				winMixer["beat4_1"].scaleX=ss;
				winMixer["beat4_1"].scaleY=ss;
				ss = ns._sys.music.meta.mixer.A["Vary2"].val*0.5;
				winMixer["beat4_2"].scaleX=ss;
				winMixer["beat4_2"].scaleY=ss;
				ss = ns._sys.music.meta.mixer.A["Vary3"].val*0.5;
				winMixer["beat4_3"].scaleX=ss;
				winMixer["beat4_3"].scaleY=ss;
				ss = ns._sys.music.meta.mixer.A["Vary4"].val*0.5;
				winMixer["beat4_4"].scaleX=ss;
				winMixer["beat4_4"].scaleY=ss;

				winMixer["func"].text = ns._sys.music.meta.mixer.VaryFuncVal;
				winMixer["mod"].text = ns._sys.music.meta.mixer.VaryModVal;

				ss = ns._sys.music.meta.mixer.A["peak"].val*0.5;
				winMixer["beatPeak"].scaleX=ss;
				winMixer["beatPeak"].scaleY=ss;
				winMixer["peak"].text = ns._sys.music.meta.mixer.peakVal;
				winMixer["mclpOff"].visible = ! ns._sys.cloud.R3D.mclp;
				winMixer["mclpOn"].visible = ns._sys.cloud.R3D.mclp;

				winMixer["lit"].text = ns._sys.music.meta.mixer.litVal;
			}
			/*
			//BEAT
			if(beat.enabled){
	            var ss=beat.A["ASR1_1"].val/2;
	            dot.scaleX=ss;
	            dot.scaleY=ss;
	            ss=beat.A["ASR2_1"].val;
	            dotA.scaleX=ss;
	            dotA.scaleY=ss;
	            ss=beat.A["ASR2_2"].val;
	            dotB.scaleX=ss;
	            dotB.scaleY=ss;
			}

			//TIMELINE
			if(timeline.enabled){
				tfStruct.text=(timeline.timelineInd+1)+" . "+(timeline.beatInd+1);
				tfSection.text=timeline.timeline[timeline.timelineInd].n;
				
				var chh=channels[0];
				if(chh.val!=timeline.beatInd){
					chh.signs[chh.val].gotoAndStop(1);
					chh.val=timeline.beatInd;
					chh.signs[chh.val].gotoAndStop(2);	
				}
			}*/
			

			/*
			//General Channels
			for(var i=0;i<channels.length;i++){
				var chh=channels[i];
				if(chh.val!=beat.counter[chh.ch]){
					chh.signs[chh.val].gotoAndStop(1);
					chh.val=beat.counter[chh.ch];
					chh.signs[chh.val].gotoAndStop(2);	
				}
			}*/

			/*
			// Analoug
			var ss=beat.chA[0].val*2;
			signTrig.scaleX=ss;
			signTrig.scaleY=ss;
			*/
		}
		
		

		public function dispose(){

		}
	}
}