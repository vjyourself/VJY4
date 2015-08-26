package vjyourself4.media{
	import vjyourself4.patt.TrigChannel;

	public class MetaRhythm{
		public var params:Object;
		var tack:Number=0;
		var start:Number=0;
		var pos:Number=0;

		public var absBeatCount:Number=0;

		public var tackCounter:Number=0;
		public var tackCounterPre:Number=0;
		public var counter:Array;
		public var chA:Array;
		var preShift:Number;

		public function MetaRhythm(){
			
		}
		public function init(){
			tack=params.tack;
			start=params.start;
			preShift=tack*0.2;
			counter=[0,0,0,0];
			chA=[];
			for(var i=0;i<3;i++){
				var ch= new TrigChannel();
				ch.width=tack;
				if(i==0) ch.width=tack*0.6;
				ch.form="sin";
				chA.push(ch);
			}
		}
		public function beatToTime(bb){
			return start+(bb-1)*tack;
		}
		public function setPosition(val){
			var delta=(val-pos);if(delta<0)delta=0;
			pos=val;
			if(pos<start) absBeatCount=0;
			else{
				var v=Math.floor((val-start)/tack);
				absBeatCount=v;
				counter[0]=v;
				counter[1]=v%2;
				counter[2]=v%4;
				counter[3]=v%16;

				if(v!=tackCounter){
					//trace("TACK"+v);
				}
				tackCounter=v;

				v=Math.floor((val-start+preShift)/tack);
				if(v!=tackCounterPre){
					//and we're on the last tack in beat .... TRIG TRIGGER TRIGG !
					if(counter[1]==1) chA[0].trig();
					if(counter[2]==3) chA[1].trig();
					if(counter[3]==15) chA[2].trig();
				}
				tackCounterPre=v;
				  
			}
			chA[0].onEF({delta:delta});
			chA[1].onEF({delta:delta});
			chA[2].onEF({delta:delta});
		}
		
	}
}
