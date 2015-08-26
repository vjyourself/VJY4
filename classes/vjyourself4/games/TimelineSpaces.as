package vjyourself4.games{
	public class TimelineSpaces{
		public var synth:SynthPath;
		
		var transActive:Boolean=false;
		var transInd:Number=-1;
		var transCC:Number=0;
		var transDelay:Number=60*5;
		var transLength:Number=0;
		var transLengthMax:Number=1600;
		var transListOff:Array;
		var transListOn:Array;
		
		public var map:Array;
		public var mapActive:Boolean=false;
		public var mapInd:Number=0;
		public var mapProgress:String="random";
		var mapLength:Number=0;
		var mapLengthMax:Number=3200;
		
		public var currSpacePRG:Object;
		
		public function TimelineSpaces(){
				
		}
		public function startSpace(prg,p:Object=null){
			trace("TimelineSpaces StartSpace");
			currSpacePRG=prg;
				if(p==null)p={trans:"none"};
			if(p.trans=="none"){
				transActive=false;
				mapActive=false;
				synth.decomposeStreamAll();
				for(var i in prg.streams) synth.startStream(prg.streams[i]);
				if(prg.bind!=null) synth.anal.setBind(prg.bind);
				else synth.anal.setBind(synth.anal.defBind);
			}else{
				transActive=true;
				transListOff=[];
				for(var i in synth.streams.ids) transListOff.push(i);
				transListOn=[];
				for(i in prg.streams) transListOn.push(prg.streams[i]);
				transInd=-1;
				transCC=0;
				transLength=0;
				transNextStep();
			}
		}
		public function restartSpace(){
			synth.destroyStreamAll();
			startSpace(currSpacePRG);
		}
		public function destroyAll(){
			synth.destroyStreamAll();
			transActive=false;
			mapActive=false;
		}
		public function transNextStep(){
			transInd++;
			trace("TRANS"+transInd);
			if(transListOff.length>transInd) synth.decomposeStream(transListOff[transInd]);
			if(transListOn.length>transInd) synth.startStream(transListOn[transInd]);
			if( (transListOff.length<=transInd+1)&&(transListOn.length<=transInd+1) ){
				transActive=false;
				transListOff=[];
				transListOn=[];
				transInd=-1;
			}
		}
		public function startMap(m,p=null){
			map=m;
			mapActive=true;
			mapInd=-1;
			mapLength=0;
			mapNextStep(p);
		}
		public function mapNextStep(p=null){
			var nInd;
			do{
				nInd=Math.floor(Math.random()*map.length);
			}while(nInd==mapInd);
			mapInd=nInd;
			trace("MAP"+mapInd);
			startSpace(map[mapInd],p);
		}
		public function updateLength(inc){
			trace("UPDATE LENGTH "+inc);
			if(transActive){
				transLength-=inc;
				if(transLength>=transLengthMax){
					transLength-=transLengthMax;
					transNextStep();
				}
			}else{
				if(mapActive){
					mapLength-=inc;
					if(mapLength>=mapLengthMax){
						mapLength-=mapLengthMax;
						mapNextStep({"trans":"linear"});
					}
				}
			}
		}
		
		public function onEF(e=null){
			
			/*
			if(transActive){
				transCC++;
				if(transCC>=transDelay){
					transCC=0;
					transNextStep();
				}
			}*/
		}
	}
}