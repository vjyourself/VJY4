package vjyourself4.patt.colors{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	public class ColorScale{
		public var elems:Array;
		public var events:EventDispatcher = new EventDispatcher();
		public var mode:String=""; // Static, Random,
		
		public function ColorScale(){}
		public function init(){}
		
		public function shift(num:Number=1){
			trace("ColorScale.shift");
			for(var i=0;i<num;i++) elems.push(elems.shift());
			
			events.dispatchEvent(new Event(Event.CHANGE));
		}
		public function setColors(m,col=null){
			mode=m;
			if(col!=null){
				elems=[]
				for(var i=0;i<col.length;i++) elems[i]=ColorConvert.autoToNum(col[i]);
			}
			trace("COLORS>"+elems.toString());
			events.dispatchEvent(new Event(Event.CHANGE));
		}
		public function setMode(m){
			if(mode!=m){
				mode=m;
				events.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		public function setColorsCyc(col,p=null){
			elems=[]
			for(var i=1;i<col.length;i++) elems.push(ColorConvert.autoToNum(col[i]));
			
			trace("COLORS>"+elems.toString());
			events.dispatchEvent(new Event(Event.CHANGE));
		}
		public function getColor(ind){
			var ret;
			switch(mode){
				case "Static":ret=elems[(ind+elems.length)%elems.length];break;
				case "Random":ret=Math.floor(Math.random()*256*256*256);break;
			}
			return ret;
		}
	}
}