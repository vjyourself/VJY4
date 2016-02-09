/*

[{},1,2,3,4]

*/
package vjyourself4.cycle{
	public class Cycle{
		public var NS:Object;
		public var patt;
		public var pattInd:Number=-1;
		public var pattIndSeq:Number=-1;
		public var delay:Number=1;
		public var delayCC:Number=0;
		public var start:Number=0;
		public var startRnd:Boolean=false;
		public var val;
		
		var cyc:Cycle;
		var cycLoops:Number=1;
		var cycLoopInd:Number=0;
		var cycLast:Boolean=false;
		var meta:Object;
		var n:String;
		var id:String;
		
		public var last:Boolean=false;
		public var first:Boolean=false;
		public var name:String="";
		
		public var elemType="value";
		
		public var params:Object;
		public var seq:String="line";
		public var mixMode:String="plane" //plane / mix
		public var mixCC:Number=0;
		public var mixInd:Number=0;
		public var mixNextInd:Number=0;
		
		var order:Array;
		public function Cycle(ns,n,p=null){
			if(p==null)p={};
			//trace("************>"+ns+" "+n+" ? "+ns[n]);
			NS=ns;
			params=NS[n][0];
			for(var i in params) this[i]=params[i];
			for(var i in p) this[i]=p[i];
			if(startRnd) start=Math.floor(Math.random()*(NS[n].length-1));
			pattInd=start-1;
			delayCC=delay;
			patt=[];
			for(var i=1;i<NS[n].length;i++){
				var data=NS[n][i];
				var el={};
				if( (data is Object)&&(!(data is String))&&(!(data is Boolean))&&(!(data is Number)) ){
					el.type="cycle";
					el.params=data;
					el.name=data.n;
				}else{
					el.type="value";
					el.val=data;
				}
				patt.push(el);
			}
			trace("Create CYCLE "+n+" - "+patt);
		}
		
		public function getNext(){
		
			delayCC++;
			if(delayCC>=delay){
				delayCC=0;
			
				//Step or not to step
				switch(elemType){
					case "value":stepToNextElem();break;
					case "cycle": if(cycLast||(cycLoops==0)) stepToNextElem();break;
				}
				val = getElem();
			}
			
			return val;
		}
		
		public function getNextFull(){
			var val=getNext();
			return {val:val,last:last}
		}
		
		function stepToNextElem(){
			if(elemType=="cycle"){ cyc.dispose();cyc=null};
			pattInd=(pattInd+1)%patt.length;
			switch(seq){
				case "line":pattIndSeq=pattInd;break;
				case "random":pattIndSeq=Math.floor(patt.length*Math.random());break;
			}
			//at first elem in cycle:
			first =( pattInd == 0 );
			//at last elem in cycle:
			last =( pattInd == (patt.length-1) );
			
			switch(patt[pattIndSeq].type){
				case "cycle":
					cyc= new Cycle(NS,patt[pattIndSeq].name);
					cycLoopInd=0;
					cycLoops=1;if(patt[pattIndSeq].params.loops!=null) cycLoops=patt[pattIndSeq].params.loops;
					elemType="cycle";
				break;
					
				case "value":
					elemType="value";
				break;
			}
			
		}
		
		function getElem(){
			var ret;
			switch(elemType){
				case "value":ret=patt[pattIndSeq].val;break;
				case "cycle":
					var cycRet=cyc.getNextFull();
					ret=cycRet.val;
					var locLast=cycRet.last;
					cycLast=false;
					if(locLast){
						cycLoopInd++;
						if(cycLoopInd>=cycLoops){
							cycLast=true;
						}
					}
				break;
			}
			return ret;
		}
		
		public function dispose(){
			NS=null;
			if(cyc!=null){ cyc.dispose();cyc=null;}
			
		}
		
		
	}
}