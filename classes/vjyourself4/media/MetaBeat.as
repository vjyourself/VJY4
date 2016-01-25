package vjyourself4.media{
	import vjyourself4.patt.TrigChannel;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;

	public class MetaBeat{
		public var params:Object;
		public var stage:Stage;

		public var enabled:Boolean=true;
		public var sync:String="tap"; // tap / playback

		public var tapParams:Object={};
		public var playback:Object={
			tack:0,
			start:0
		};

		//Output
		/* Analogue : runs up before the beat, climax on the beat
			A[0] - every bit
			A[1] - A[4]  4/4 1. - 4. beat
		*/
		public var A:Object;
		public var ADeclaration:Array=[
			{n:"Insta1_1",mod:1,ind:0,trig:{pre:0,length:0.4},func:{t:"insta"}},
			{n:"Insta2_1",mod:2,ind:0,trig:{pre:0,length:0.4},func:{t:"insta"}},
			{n:"Insta2_2",mod:2,ind:1,trig:{pre:0,length:0.4},func:{t:"insta"}},
			{n:"Insta4_1",mod:4,ind:0,trig:{pre:0,length:0.4},func:{t:"insta"}},
			{n:"Insta4_2",mod:4,ind:1,trig:{pre:0,length:0.4},func:{t:"insta"}},
			{n:"Insta4_3",mod:4,ind:2,trig:{pre:0,length:0.4},func:{t:"insta"}},
			{n:"Insta4_4",mod:4,ind:3,trig:{pre:0,length:0.4},func:{t:"insta"}},

			{n:"ASR1_1",mod:1,ind:0,trig:{pre:0.1,length:0.4},func:{t:"ASRSin",A:0.2,S:0.3,R:0.5}},
			{n:"ASR2_1",mod:2,ind:0,trig:{pre:0.1,length:0.4},func:{t:"ASRSin",A:0.2,S:0.3,R:0.5}},
			{n:"ASR2_2",mod:2,ind:1,trig:{pre:0.1,length:0.4},func:{t:"ASRSin",A:0.2,S:0.3,R:0.5}},
			{n:"ASR4_1",mod:4,ind:0,trig:{pre:0.1,length:0.4},func:{t:"ASRSin",A:0.2,S:0.3,R:0.5}},
			{n:"ASR4_2",mod:4,ind:1,trig:{pre:0.1,length:0.4},func:{t:"ASRSin",A:0.2,S:0.3,R:0.5}},
			{n:"ASR4_3",mod:4,ind:2,trig:{pre:0.1,length:0.4},func:{t:"ASRSin",A:0.2,S:0.3,R:0.5}},
			{n:"ASR4_4",mod:4,ind:3,trig:{pre:0.1,length:0.4},func:{t:"ASRSin",A:0.2,S:0.3,R:0.5}},

			{n:"Sin1_1",mod:1,ind:0,trig:{pre:0.3,length:0.6},func:{t:"HalfSin"}},
			{n:"Sin2_1",mod:2,ind:0,trig:{pre:0.3,length:0.6},func:{t:"HalfSin"}},
			{n:"Sin2_2",mod:2,ind:1,trig:{pre:0.3,length:0.6},func:{t:"HalfSin"}},
			{n:"Sin4_1",mod:4,ind:0,trig:{pre:0.3,length:0.6},func:{t:"HalfSin"}},
			{n:"Sin4_2",mod:4,ind:1,trig:{pre:0.3,length:0.6},func:{t:"HalfSin"}},
			{n:"Sin4_3",mod:4,ind:2,trig:{pre:0.3,length:0.6},func:{t:"HalfSin"}},
			{n:"Sin4_4",mod:4,ind:3,trig:{pre:0.3,length:0.6},func:{t:"HalfSin"}},

			{n:"FullSin1_1",mod:1,ind:0,trig:{pre:0,length:1},func:{t:"FullSin"}},
			{n:"FullSin2_1",mod:2,ind:0,trig:{pre:0,length:2},func:{t:"FullSin"}},
			{n:"FullSin2_2",mod:2,ind:1,trig:{pre:0,length:2},func:{t:"FullSin"}},
			
			{n:"Saw1_1",mod:1,ind:0,trig:{pre:0,length:1},func:{t:"Saw"}},
			{n:"Saw2_1",mod:2,ind:0,trig:{pre:0,length:2},func:{t:"Saw"}},
			{n:"Saw4_1",mod:4,ind:0,trig:{pre:0,length:4},func:{t:"Saw"}},
			{n:"Saw8_1",mod:8,ind:0,trig:{pre:0,length:8},func:{t:"Saw"}},
			{n:"Saw16_1",mod:16,ind:0,trig:{pre:0,length:16},func:{t:"Saw"}},

		];

		var AState:Array;

		/* Trigger
		*/
		public var T:Array;
		
		/* Counter
		*/
		public var C:Array;

		/*
			Inner Calculations
		*/

		var start:Number=0;
		public var tack:Number=500;
		public var bpm:Number=120;
		var time:Number=0;
		var time0:Number=0;
		
		public var beatCounter:Number=0;
		public var beatFrame:Boolean=false;

		// beat Fractions
		/// 1 1/2 1/4 1/8
		public var beatFractions=[
			{counter:0,beatFrame:false},
			{counter:0,beatFrame:false},
			{counter:0,beatFrame:false},
			{counter:0,beatFrame:false}
		]
		

		public function MetaBeat(){
			
		}
		public function init(){
			enabled=params.enabled;
			sync=params.sync;
			tapParams=params.tap;
			playback=params.playback;
			
			if(sync=="playback"){
				tack=params.playback.tack;
				start=params.playback.start;
				bpm=60000/tack;
			}
			if(sync=="tap"){
				stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			}
			T=[0,0,0,0,0];
			C=[0,0,0,0,0];
			
			//Analogue
			A={};AState=[];
			for(var i=0;i<ADeclaration.length;i++){
				var decl=ADeclaration[i];
				var e={
					n:decl.n,
					counter:0,
					mod:decl.mod,
					ind:decl.ind
				};
				e.ch = new TrigChannel();
				e.ch.func=decl.func;
				AState.push(e);
				A[e.n]=(e.ch);
			}
			restartCalculations();
		}
		
		//Restart
		public function restartCalculations(){
			C[0]=0;
			C[1]=0;
			C[2]=0;
			C[3]=0;
			C[4]=0;

			beatCounter=0;
			beatFractions[0].counter=0;
			beatFractions[1].counter=0;
			beatFractions[2].counter=0;
			beatFractions[3].counter=0;
			
			//Analogue
			for(var i=0;i<AState.length;i++){
				var e = AState[i];
				var decl = ADeclaration[i];
				e.counter=0;
				e.pre=tack*decl.trig.pre;
				e.length=tack*decl.trig.length;
				e.ch.length=e.length;
			}
		}

		public function beatToTime(bb){
			return start+(bb-1)*tack;
		}
		

		/* Play Sync */
		public function setPosition(pos:Number){
			if(sync=="playback"){
				//if music restarted
				if(pos<time0) restartCalculations();
				time=pos;
			}
		}

		/* Tap Sync */
		var spaceTime0:Number=0;
		var spaceTime1:Number=0;
		var taps:Array=[];

		public function onKeyDown(e:KeyboardEvent){
			if(e.charCode==32){
				tap();
			}
		}
		public function tap(){
			trace("TAP");
			spaceTime1=new Date().getTime();
			var delta=spaceTime1-spaceTime0;
			if(delta<2000){
				start=spaceTime1;
				taps.push(delta);
				var summ=0;
				for(var i=0;i<taps.length;i++) summ+=taps[i];
				tack=summ/taps.length;
				bpm=60000/tack;
				trace(delta+" "+Math.round(60000/delta)+" : "+Math.round(tack)+" "+Math.round(bpm));

				restartCalculations();
			}else{
				trace("START");
				taps=[];
				start=spaceTime1;
			}
			spaceTime0=spaceTime1;
		}
		
	

		/*
			calc output from
			- time
			- start
			- tack - beat distance
		*/

	

		public function onEF(){
			trace("BEAT: "+time);
			if(sync=="tap"){
				time=new Date().getTime();
			}
			if(time>=start){
			var delta = time-time0;
			time0 = time;

			//Counters
			beatFrame=false;		
			var v=Math.floor((time-start)/tack);
			if(v!=beatCounter){
				beatCounter=v;
				C[0]=v;
				C[1]=v%2;
				C[2]=v%4;
				C[3]=v%8;
				C[4]=v%16;
				beatFrame=true;
			}

			//Beat Fractions
			// 1
			beatFractions[0].counter=beatCounter;
			beatFractions[0].beatFrame=beatFrame;
			// 1/2
			beatFractions[1].beatFrame=false;
			v=Math.floor((time-start)/tack*2);
			if(v!=beatFractions[1].counter){
				beatFractions[1].counter=v;
				beatFractions[1].beatFrame=true;
			}
			// 1/4
			beatFractions[2].beatFrame=false;
			v=Math.floor((time-start)/tack*4);
			if(v!=beatFractions[2].counter){
				beatFractions[2].counter=v;
				beatFractions[2].beatFrame=true;
			}
			// 1/8
			beatFractions[3].beatFrame=false;
			v=Math.floor((time-start)/tack*8);
			if(v!=beatFractions[3].counter){
				beatFractions[3].counter=v;
				beatFractions[3].beatFrame=true;
			}
			

			//Analogue
			for(var i=0;i<AState.length;i++){
				var e=AState[i];
				v=Math.floor((time+e.pre-start)/tack);
				if(v!=e.counter){
					e.counter=v;
					if(e.counter%e.mod==e.ind) e.ch.trig();
				}
				e.ch.onEF({delta:delta});
			}
	
		}
			
		}
}
		
	}

