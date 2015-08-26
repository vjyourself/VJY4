package vjyourself4.cycle{
	public class Cycle{
		public var NS:Object;
		public var patt;
		public var pattInd:Number=-1;
		public var cyc:Cycle;
		public var cycLast:Boolean=false;
		public var last:Boolean=false;
		
		public var loops:Number=1;
		var childLoops:Array=[];
		public var loopInd:Number=-1;
		
		public var elemType="value";
		
		public var params:Object;
		
		public function Cycle(ns,n,p){
			if(p.loops!=null){if(p.loops.length>0) loops=p.loops[0];if(p.loops.length>1) childLoops=p.loops.slice(1);}
			NS=ns;
			params=p;
			patt=NS[n];
			trace("Create CYCLE "+n+" - "+patt);
		}
		
		public function getNext(){
		
			//Step or not to step
			switch(elemType){
				case "value":stepToNextElem();break;
				case "cycle": if(cycLast) stepToNextElem();break;
			}
			
			return getElem();
		}
		
		public function getNextFull(){
			var val=getNext();
			return {val:val,last:last}
		}
		
		function stepToNextElem(){
			if(elemType=="cycle"){ cyc.dispose();cyc=null};
			pattInd=(pattInd+1)%patt.length;
			//at first elem in cycle:
			if(pattInd==0) loopInd=(loopInd+1)%loops;
			//at last elem in cycle:
			last=false;
			if(pattInd==(patt.length-1)){
				if(loopInd==loops-1) last=true;
			}
			if(patt[pattInd] is String){
				cyc= new Cycle(NS,patt[pattInd],{loops:childLoops});
				elemType="cycle";
			}else{
				elemType="value";
			}
			
		}
		
		function getElem(){
			var ret;
			switch(elemType){
				case "value":ret=patt[pattInd];break;
				case "cycle":
					var cycRet=cyc.getNextFull();
					ret=cycRet.val;
					cycLast = cycRet.last;
				break;
			}
			return ret;
		}
		
		public function dispose(){
			NS=null;
			if(cyc!=null){ cyc.dispose();cyc=null;}
			childLoops=null;
		}
		
		
	}
}