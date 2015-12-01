package vjyourself4.patt{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import vjyourself4.patt.colors.ColorConvert;
	public class Pattern{
		public var elems:Array=[];
		public var elemsInd:Number=-1;
		public var events:EventDispatcher = new EventDispatcher();
		
		//params
		public var params:Object={} // collection of params
		public var progress:String="inc";
		public var delay:Number=1;
		public var delayMul:Number=1;
		public var progressInc:Number=1;
		public var progressRepeat:Number=1;
		public var progressRepeatMul:Number=1;
		public var progressCC:Number=0;
		public var type:String="texture";
		public var context:Object={NS:{}};
		public var start:String="random";
		public var startInd:Number=0;
		
		
		public function Pattern(){}
		public function init(){
			elemsInd=0;
		}
		
		public function reset(){
			progressCC=0;
			switch(start){
				case "random": elemsInd=Math.floor(Math.random()*elems.length);break;
				case "ind": elemsInd=startInd-1;break;
				default:
				elemsInd=-1;
			}
		}
		public function shift(){
			//trace("Pattern.shift");
			elems.push(elems.shift());
			
			events.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setParams(p){
			//trace("p:"+JSON.stringify(p));
			//trace("string?"+(p is String));
			if(p is String) p = {name:p};
			
			for(var i in p) if((i!="name")&&(i!="refresh")) this[i]=p[i];
			for(var i in p) if((i!="refresh"))params[i]=p[i];
			//trace("name:"+p.name);
			if(p.name!=null) setElemsCyc(context.getRaw(p.name));
	
			var refresh:Boolean=true;
			if(p.refresh!=null) refresh=p.refresh;
			if(refresh) events.dispatchEvent(new Event(Event.CHANGE));
		}
		public function getParams():Object{
			return params;
		}
		public function setElemsCyc(elm){
			elems=[];
			if(type=="color") for(var i=1;i<elm.length;i++) elems.push(ColorConvert.autoToNum(elm[i]));
			else for(var i=1;i<elm.length;i++) elems.push(elm[i]);
			
			switch(start){
				case "random": elemsInd=Math.floor(Math.random()*elems.length);break;
				case "ind": elemsInd=startInd-1;break;
				default:
				elemsInd=-1;
			}
			progressRepeat=delay*delayMul;
			progressCC=progressRepeat-1;
			//trace("PATTERN elems>"+elems.toString());
		}
		
		public function trigRefresh(){
			//trace(">TRIG>");
			events.dispatchEvent(new Event(Event.CHANGE));
			//trace(">>>>>>");
		}
		public function getNext(p=null){
			progressRepeat=delay*delayMul;
			if (p==null) p={};
			var ret;
			if( elems==null || elems.length==0 ) ret=(type=="texture")?"Empty":0;
			else{
				if(p.ind!=null) return elems[(p.ind+elems.length)%elems.length];
				else switch(progress){
					case "inc":
						progressCC++;
						if(progressCC>=progressRepeat){progressCC=0;elemsInd=(elemsInd+progressInc)%elems.length;}
						if(elemsInd<0)elemsInd=0; //when we start first call without progress...
						ret=elems[elemsInd];
					break;
					case "random":ret=elems[Math.floor(Math.random()*elems.length)];break;	
				}
			}
		//	trace("Pattern.getNext ("+type+")> ",ret);
			return ret;
		}
	}
}