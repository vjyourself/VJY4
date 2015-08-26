package vjyourself4.media{
	import flash.events.SampleDataEvent;
	import flash.media.Microphone;
	public class PlaybackMic{
		
		public var meta:MusicMeta;
		public var microphone:Microphone;
		public var microphone_gain=50;
		
		function PlaybackMic(){
			
		}
		
		function play(p:Object){
			if(p.microphone_gain!=null) microphone_gain=p.microphone_gain;
			microphone = Microphone.getMicrophone(); 
			//mic.setSilenceLevel(0, 4000); 
			if(microphone==null){
				trace("NO MIC");
			}else{
				microphone.gain = microphone_gain; 
				microphone.rate = 44; 
				microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, microphoneOnSampleData); 
			}
			
		}
		function microphoneOnSampleData(eve:SampleDataEvent){
			meta.feedRawWaveData(eve.data);
		}
	}
}