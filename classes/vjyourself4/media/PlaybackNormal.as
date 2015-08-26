package vjyourself4.media{
	
	import vjyourself4.media.MusicMeta;
	import vjyourself4.media.SoundResource;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.SampleDataEvent;
	import flash.events.Event;
	
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import flash.media.SoundMixer;
	
	public class PlaybackNormal{
		
		//Sound
		var resource:SoundResource;
		public var sndSrc:Sound;
		public var rawWaveData:ByteArray = new ByteArray();
		
		//Extract
		public var extract0:Number=0;
		public var extract1:Number=0;
		var bufferLength = 2048;
		var offset=0;
		
		var state="";
		var pausedPos:Number=0;
		var loop:Boolean=false;
		var pos0:Number=-1; // -1 : not specified
		var pos1:Number=-1;
		var currPlayParams:Object;
		public var pos:Number=0;
		
		public var sndCh:SoundChannel;
		var stf:SoundTransform;
		//meta
		public var meta:MusicMeta;
		var debugId:String;
		
		var volume=1;
		

		function PlaybackNormal(){
			resource = new SoundResource();
			resource.events.addEventListener(Event.COMPLETE,resourceOnComplete,0,0,1);
			//snd.addEventListener(SampleDataEvent.SAMPLE_DATA, processSound);
		}
		
		public function play(p:Object){
			if(p.pos0!=null) pos0=p.pos0;
			if(p.pos1!=null) pos1=p.pos1;
			if(p.loop!=null) loop=p.loop;
		
			currPlayParams=p;
			stop();
			//debugId="?";if(p.srcClassName!=null)debugId=p.srcClassName;
			resource.getResource(p);
			
		}
		function resourceOnComplete(e){
			var p = currPlayParams;
			sndSrc=resource.snd;
			stf =new SoundTransform(volume);
			sndCh = sndSrc.play(((pos0==-1)?0:pos0)*1000,loop?1000:0,stf);
			state="playing...";
			
		}
		
		public function onEF(e=null){
			SoundMixer.computeSpectrum(rawWaveData,false,0);
			meta.feedRawWaveData2(rawWaveData);
			meta.setPosition(sndCh.position);
			pos=Math.floor(sndCh.position/1000);
			if(pos1>-1){
				if(pos>pos1){
					sndCh.stop();
					if(loop) sndCh=sndSrc.play( ((pos0==-1)?0:pos0)*1000,0,stf);
				}
			}
		}

		public function pause(){
			if(state=="playing..."){
				state="paused";
				pausedPos=sndCh.position;
				sndCh.stop();
			}else{
					if(state=="paused"){
						state="playing...";
						var stf =new SoundTransform(volume);
						sndCh=sndSrc.play(pausedPos,0);
					}
			}
		}
		public function stop(){
			if(state=="playing..."){
				sndCh.stop();
				state="";
				}
		}
		
		
		public function setVolume(v:Number){
			trace("SoundPlaybackExtract> setVol:"+v);
			volume=v;
			stf = new SoundTransform(v,0);
			if(sndCh!=null) sndCh.soundTransform = stf;
		}
		
	}
}




