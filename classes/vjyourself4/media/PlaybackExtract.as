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
	
	public class PlaybackExtract{
		
		//Sound
		var resource:SoundResource;
		public var sndSrc:Sound;
		public var rawWaveData:ByteArray = new ByteArray();
		
		//Extract
		public var extract0:Number=0;
		public var extract1:Number=0;
		var bufferLength = 4096;
		var offset=0;
		
		var state="";
		var pausedPos:Number=0;
		var loop=1;
		var currPlayParams:Object;
		
		public var snd:Sound = new Sound();
		public var sndCh:SoundChannel;
		
		//meta
		public var meta:MusicMeta;
		var debugId:String;
		
		var volume=1;
		

		function PlaybackExtract(){
			resource = new SoundResource();
			resource.events.addEventListener(Event.COMPLETE,resourceOnComplete,0,0,1);
			snd.addEventListener(SampleDataEvent.SAMPLE_DATA, processSound);
		}
		
		public function play(p:Object){
			
			currPlayParams=p;
			stop();
			//debugId="?";if(p.srcClassName!=null)debugId=p.srcClassName;
			resource.getResource(p);
			
			
		}
		function resourceOnComplete(e){
			sndSrc=resource.snd;
			var p = currPlayParams;
			if(sndSrc!=null){
				
				//extract
				meta.feedSrc(p);
				extract0=0;if(p.extract0!=null) extract0=p.extract0;
				extract1=0;if(p.extract1!=null) extract1=p.extract1;
				loop=1;if(p.loop!=null) loop=p.loop;
				offset=0;
				state="playing...";
				
				//play
				var stf =new SoundTransform(volume);
				sndCh = snd.play(0,0,stf);
				//setVolume(volume);
			
				
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
						sndCh=snd.play(pausedPos,0);
					}
			}
		}
		public function stop(){
			if(state=="playing..."){
				sndCh.stop();
				state="";
				}
		}
		
		function getNextData():ByteArray
		{
			if(state=="playing..."){
			//trace("?"+extract1+"::"+(extract0+(pos+1)*bufferLength));
		    rawWaveData.clear();rawWaveData.position=0;
			
			//for streaming: isBuffering = flat line ;)
			if(sndSrc.isBuffering){
				for(var i=0;i<bufferLength;i++){
					rawWaveData.writeFloat(0);
					rawWaveData.writeFloat(0);
				}
			}else{
				
			//calculate the needed interval (crop if exceeds "extract1"
			var inter = bufferLength;
			if(extract1>0) if((extract0+offset+bufferLength)>extract1) inter=extract1-(extract0+offset);
			
		    var n=sndSrc.extract(rawWaveData, inter,extract0+offset);
			//trace(debugId+":"+offset+" + "+n);
			offset+=n;
			if(n<bufferLength){
				//trace("restart:"+inter+"::"+n);
				var b2 = new ByteArray();
				var n2=sndSrc.extract(b2, bufferLength-n,extract0);
				//trace(debugId+": ++ "+offset+" + "+n2);
				b2.position=0;
				rawWaveData.writeBytes(b2,0,b2.bytesAvailable);
				offset=n2;
				b2.clear();
				//events.dispatchEvent(new ProgressEvent("loop"));
				if(loop==0) stop();
			}
			}
			
			//META
			meta.feedRawWaveData(rawWaveData);
			}
			
			rawWaveData.position=0;
			return rawWaveData;
		}
		
		public function setVolume(v:Number){
			trace("SoundPlaybackExtract> setVol:"+v);
			volume=v;
			if(sndCh!=null) sndCh.soundTransform = new SoundTransform(v,0);
		}
		
		function processSound(ee:flash.events.SampleDataEvent):void
		{
			//trace("proc");
		    ee.data.writeBytes(getNextData());
		}
	}
}




