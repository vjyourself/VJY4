package vjyourself4.media{
	import vjyourself4.patt.TrigChannel;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;

	public class MusicMetaMixer{
		public var _debug:Object;
		public var _meta:Object={name:"MMM"};
		function log(level,msg){_debug.log(this,level,msg);}

		/*
			// parameters
			peak
			VaryFunc
			VaryMos

			// A output
			peak
			Vary1 - Vary4
		*/

		public var params:Object;
		public var beat:MetaBeat;
		public var wave:Object;

		public var enabled:Boolean=true;
	
		public var A:Object={};
		public var A_Decl:Object;

		public var litElems:Array=["SLOW","NORM","FAST","TURBO"];
		public var litInd:Number=1;
		public var litVal:String="";
		public var litTurbo:Boolean=false;
		public var litTurboBackInd:Number=0;

		public var peakElems:Array=["wave.peak","beat.Sin1_1"];
		public var peakInd:Number=0;
		public var peakVal:String="";

		public var VaryFuncElems:Array=["ASR","Sin","Insta","None"];
		public var VaryFuncInd:Number=0;
		public var VaryFuncVal:String="";

		public var VaryModElems:Array=[1,2,4];
		public var VaryModInd:Number=0;
		public var VaryModVal:Number=1;

		var VaryVol:Number=1;

		public function MusicMetaMixer(){
			
		}
		public function init(){
			enabled=params.enabled;
			A_Decl = params.A;
			
			peakVal = A_Decl.peak;
			peakInd = findInd(peakElems,peakVal);

			litVal = A_Decl.lit;
			litInd = findInd(litElems,litVal);

			VaryFuncVal = A_Decl.Vary.func;
			VaryFuncInd = findInd(VaryFuncElems,VaryFuncVal);
			
			VaryModVal = A_Decl.Vary.mod;
			VaryModInd = findInd(VaryModElems,VaryModVal);

			VaryVol = A_Decl.Vary.vol;
			
			
			
			A.Vary1 = {val:0};
			A.Vary2 = {val:0};
			A.Vary3 = {val:0};
			A.Vary4 = {val:0};

			A.peak = {val:0};
		}
		public function findInd(a,v){
			for(var i in a) if(a[i]==v) return i;
			return 0;
		}
		public function next(name){
			if(name=="litTurbo"){
				litTurbo=!litTurbo;
				if(litTurbo){
					litTurboBackInd=litInd;
					litInd=litVal.length-1;
				}else{
					litInd=litTurboBackInd;
				}
				litVal=litElems[litInd];
				log(6,"lit : "+litVal);
			}else{
				//stepping lit -> skip turbo
				if((name=="lit")&&(litInd==litVal.length-2))litInd++;
				this[name+"Ind"]=(this[name+"Ind"]+1)%this[name+"Elems"].length;
				this[name+"Val"]=this[name+"Elems"][this[name+"Ind"]];
				log(6,name+" : "+this[name+"Val"]);
			}
		}
		public function onEF(){
			if(enabled){
				if(wave.enabled){
					switch(peakVal){
						case "wave.peak": A.peak.val=wave.peak;break;
						case "beat.Sin1_1": A.peak.val=beat.A.Sin1_1.val;break;
					}
				}

				if(beat.enabled){
					if(VaryFuncVal!="None") for(var i=0;i<4;i++) A["Vary"+(i+1)].val=beat.A[VaryFuncVal+""+VaryModVal+"_"+((i%VaryModVal)+1)].val*VaryVol;
					else for(var i=0;i<4;i++) A["Vary"+(i+1)].val=0;
				}
			}
		}		
	}
}

