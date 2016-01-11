package vjyourself4.media{
	import flash.utils.ByteArray;
	public class MusicMeta{
		public var enabled:Boolean=true;
		public var _debug:Object;
		public var BPM=0;
		public var defBPM=120;
		public var fps=24;
		public var stage;
		
		public var meter=4
		public var LFO=0;
		public var LFOInc=0;
		
		//256*Float
		public var waveDataDamped:Array; 
		public var waveData:Array;
		
		public var wave_gain:Number=1;

		public var peak_gain:Number=1;

		public var damping_mul=0.8;
		public var damping_gain=1;

		//0.1 - 10
		//0.8 - 2
		public var waveDataLength=512;
		public var waveDataCrop=0; //0: full rawBuffer is scaled down to waveDataLength
		public var peak=0;

		public var beat:MetaBeat;
		public var timeline:MetaTimeline;

		//backward compatibility links
		public var rhythm:MetaBeat;
		public var struct:MetaTimeline;
		public var mixer:MusicMetaMixer;

		public var variables:Object = {
			Wave:false,
			Peak:false,
			Beat:false,
			Timeline:false
		}
		public function MusicMeta(){
			waveData = new Array();
			waveDataDamped = new Array();
			for(var i=0;i<waveDataLength;i++){
				waveData[i]=new Number();
				waveDataDamped[i]=new Number();
			}
			setDamping({preset:"heavy"});
		}
		
		public function init(p:Object=null){
			beat = new MetaBeat();
			beat.stage=stage;
			timeline = new MetaTimeline();
			timeline.beat=beat;

			mixer = new MusicMetaMixer();
			mixer.wave = this;
			mixer.beat = beat;
			mixer._debug=_debug;

			//backward links
			struct=timeline;
			rhythm=beat;

			if(p!=null){
				for(var i in p){
					switch(i){
						case "beat":beat.params=p[i];break;
						case "timeline":timeline.params=p[i];break;
						case "mixer":mixer.params=p[i];break;
						case "wave":
							for(var ii in p[i]) this[ii]=p[i][ii];
						break;

						default:
						this[i]=p[i];
						}
				} 
				/*
				if(p.damping!=null) setDamping(p.damping);
				if(p.wave!=null){
					if(p.wave.gain!=null) wave_gain=Number(p.wave.gain);
					if(p.wave.damping!=null){
						if(p.wave.damping.gain!=null) damping_gain=p.wave.damping.gain;
						if(p.wave.damping.mul!=null) damping_mul=p.wave.damping.mul;
					}
				}
				*/
			}
			beat.init();
			timeline.init();
			mixer.init();
			if(enabled) {variables.Wave=true;variables.Peak=true; }
			if(beat.enabled) {variables.Beat=true; variables.Peak=true; }
			if(timeline.enabled) {variables.Timeline=true; }
		}

		public function setPosition(val){
			beat.setPosition(val);
			timeline.update();
		}
		
		public function addWaveGain(n:Number){
			wave_gain+=n;
		}
		public function setDamping(p:Object){
			if(p.preset!=null){
				switch(p.preset){
					case "no":break;
					
					case "normal":
					damping_mul=0.8;
					damping_gain=2;
					break;
					
					case "heavy":
					damping_mul=0.1;
					damping_gain=10;
					break;
				}
			}
			
		}
		public function feedSrc(p:Object){
			if(p==null) p={};
			if(p.BPM!=null) BPM = p.BPM;
			if(p.meter!=null) meter = p.meter;
			LFOInc = ( BPM/(60*fps) )/meter*360;
			//trace("LFOInc:"+LFOInc);
		}
		public function feedRawWaveData(rawWaveData:ByteArray){
			//trace("MusicMeta.RawWaveData");
			var rawBufferLength=rawWaveData.length/4/2;
			rawWaveData.position=0;
			
			peak=0;
			for(var i=0;i<waveDataLength;i++){
				//rawWaveData.position=(Math.floor(rawBufferLength/waveDataLength*i)*2)*4;
				var val=rawWaveData.readFloat()*wave_gain;
				rawWaveData.readFloat();
				
				if(val>peak) peak=val;
				waveData[i]=val;
				//trace(val+":"+waveData[i]);
				var pval=waveDataDamped[i];
				waveDataDamped[i]=( pval+(val*damping_gain-pval)*damping_mul );
			}
			rawWaveData.position=0;
			peak=peak*peak_gain;if(peak>1) peak=1;
			//peak/=wave_gain;peak*10;if(peak>1) peak=1;
			//trace("wave data:"+waveData);
		}
		
		public function feedRawWaveData2(rawWaveData:ByteArray){
			//trace("MusicMeta.RawWaveData: "+rawWaveData.length);
			
			var rawBufferLength=rawWaveData.length/4/2;
			rawWaveData.position=0;
			
			peak=0;
			for(var i=0;i<waveDataLength;i++){
				//rawWaveData.position=(Math.floor(rawBufferLength/waveDataLength*i)*2)*4;
				var val=rawWaveData.readFloat()*wave_gain;
				//rawWaveData.readFloat();
				
				if(val>peak) peak=val;
				waveData[i]=val;
				//trace(val+":"+waveData[i]);
				var pval=waveDataDamped[i];
				waveDataDamped[i]=( pval+(val*damping_gain-pval)*damping_mul );
			}
			rawWaveData.position=0;
			peak=peak*peak_gain;if(peak>1) peak=1;
			//trace("wave data:"+waveData);
		}

		public function onEF(){
			beat.onEF();
			mixer.onEF();
		}
	}
}
