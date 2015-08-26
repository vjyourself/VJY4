package vjyourself4.media{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	//import flash.media.SoundMixer;
	//import flash.media.Sound;
	//import flash.media.SoundTransform;
	import vjyourself4.media.MusicMeta;
	//import vjyourself2.media.SoundResource;
	import vjyourself4.media.PlaybackExtract;
	import vjyourself4.media.PlaybackMic;
	import vjyourself4.media.PlaybackNormal;
	import vjyourself4.sys.MetaStream;
	

	
	public class Music{
		public var _meta:Object={name:"MUSIC"};
		public var msLevel:Number=1;
		public var mstream;
		//var events = new EventDispatcher();
		public var meta:MusicMeta;
		public var volume=1;
		public var autoStart:Boolean=true;
		var currentPlay:Object;
		
		var mode="";
		public var playback;
		var playbackExtract:PlaybackExtract;
		var playbackMic:PlaybackMic;
		var playbackNormal:PlaybackNormal;
		public var extract=false;
		
		//var soundResource:SoundResource;
		//var soundSrc:Sound;

		public var events:EventDispatcher = new EventDispatcher();
		
		public function Music(){
			
			//soundResource = new SoundResource();
			
			
			
			
	
			//
			
			//SoundMixer.soundTransform.volume=0;
		}
		
		public function init(p:Object=null){
			if(p!=null){
				if(p.extract!=null) extract=p.extract;
				if(p.autoStart!=null) autoStart=p.autoStart;
			}

			meta = new MusicMeta();
			
			mstream.log(this,1,"EXTRACT: "+extract);
			playbackMic = new PlaybackMic();
			playbackMic.meta=meta;
			
			//if(extract){
				playbackExtract = new PlaybackExtract()
				playbackExtract.meta=meta;
			//}else{
				playbackNormal = new PlaybackNormal();
				playbackNormal.meta=meta;
			//}
			if(p!=null){
				if(p.meta!=null) meta.init(p.meta);
				if(p.play!=null) play(p.play);
			}
		}
		public function start(){
			autoStart=true;
			play(currentPlay);
			events.dispatchEvent(new Event("START"));
		}
		public function pause(){
			if(playback!=null) playback.pause();
			events.dispatchEvent(new Event("PAUSE"));
		}
		public function play(p:Object){
			playbackExtract.stop();
			playbackNormal.stop();
			currentPlay=p;
			if(autoStart){
				if( (p.src!=null) && (p.src=="Mic") ){mode="Mic";
				}else{mode=extract?"Extract":"Normal";}
			
				switch(mode){
					case "Mic":playbackMic.play(p);break;
					case "Extract":playbackExtract.play(p);playback=playbackExtract;break;
					case "Normal":playbackNormal.play(p);playback=playbackNormal;break;
				}
			}
		}
		
		
		public function onEF(){
			if(mode=="Normal") playbackNormal.onEF();
		}
		
		public function setVolume(v:Number){
			trace("Music> setVol:"+v);
			volume=v;
			if(mode=="Normal") playbackNormal.setVolume(v);
			if(mode=="Extract") playbackExtract.setVolume(v);
		}
	}
}