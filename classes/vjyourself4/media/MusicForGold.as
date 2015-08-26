package vjyourself2.media{
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.SampleDataEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.media.Microphone;

	public class MusicForGold extends MovieClip{
		var sndSrc = new Sound();
		var rawWaveData:ByteArray = new ByteArray();
		var extract0:Number=0;
		var extract1:Number=0;
		var bufferLength = 2048;
		var offset=0;
		var loop=1;
		var snd:Sound = new Sound();
		var sndCh:SoundChannel;
		var cont=this;
		var pframe=0;
		var num=600;
		var wDimY=540;
		var wDimX=960;
		var d = new Array();

		
		function MusicForGold(){
			for(var i=0;i<num;i++) d.push(0);
		}
		
		public function buildUp(){
			
			/* STREAM */
			//sndSrc.load(new URLRequest("http://scfire-ntc-aa04.stream.aol.com:80/stream/1041")); //"Crabon Based Lifeforms - Epicentre.mp3"));
			//snd.addEventListener(SampleDataEvent.SAMPLE_DATA, processSound);
			//sndCh = snd.play(0,0);
			
			/* MICROPHONE */
			
			var mic:Microphone = Microphone.getMicrophone(); 
			trace("mic:"+mic.name);
			//tfConsole.text+="mic:"+mic.name+"\n";
			mic.setSilenceLevel(0, 4000); 
			mic.gain = 100; 
			mic.rate = 44; 
			mic.addEventListener(SampleDataEvent.SAMPLE_DATA, processSound2); 
			
			
		}

		function processSound(ee:flash.events.SampleDataEvent):void{
			//trace("proc");
		    ee.data.writeBytes(getNextData());
		}

		function processSound2(ee:flash.events.SampleDataEvent):void{
			//trace("proc");
		    //ee.data.writeBytes(getNextData());
			rawWaveData=ee.data;
			rawWaveData.position=0;
			drawSound();
		}
		function getNextData():ByteArray{
			
		    rawWaveData.clear();rawWaveData.position=0;
			
			
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
			
			//DRAW WAVE
			rawWaveData.position=0;
			drawSound();
			
			//RETURN WAVE (for playback)
			rawWaveData.position=0;
			return rawWaveData;
		}
		

		function drawSound():void
		{
			//trace("$%^$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
			pframe++;
			cont.graphics.clear();
			
			//Damp
			var bytes=rawWaveData;
			for(var i=0;i<num;i++){
				var val=bytes.readFloat();
				d[i]+=(val-d[i])*0.3;
			}
	
			var y0=0;
			var mul=550;
			bytes.position=0;
			cont.graphics.beginFill(0xffff00);
			cont.graphics.moveTo(0, y0);
			var step=960/num;
			//tfNum.text=bytes.bytesAvailable;
			for(var i=0;i<num;i++){
				var val=d[i]//bytes.readFloat();
				//graphics.lineTo(i*step, -(val+1)*100);//array[Math.floor(i*step)]*100);
				//shift+=0.7;
				//if(i<24) shift+=1.4;
				cont.graphics.lineTo(i*step,val*mul+y0);
			}
			cont.graphics.lineTo((i-1)*step, y0);
			cont.graphics.lineTo(0, y0);
	
		}

	}
}