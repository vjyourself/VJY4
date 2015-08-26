package vjyourself4.patt.colors{
	import flash.events.EventDispatcher;
	import flash.events.Event;

	public class ColorFader{
		
		public var state="wait...";
		public var changed=false;
		public var trans="normal";
		public var col=0;
		public var colR=0;
		public var colG=0;
		public var colB=0;
		
		public var destCol=0;
		public var destColR=0;
		public var destColG=0;
		public var destColB=0;
		
		var startCol=0;
		var startColR=0;
		var startColG=0;
		var startColB=0;
		
		public var transNormal_cc=0;
		public var transNormal_delay=24;
		
		public var events:EventDispatcher=new EventDispatcher();
		
		
		public function ColorFader(p:Object=null){
			
		}
		public function setCol(v:Number){
			var r=Math.floor(v/256/256);
			var g=Math.floor((v-256*256*r)/256);
			var b=v-256*256*r-256*g;
			setColRGB(r,g,b);
		}
		public function setColRGB(r,g,b:Number){
			startCol=col;
			startColR=colR;
			startColG=colG;
			startColB=colB;
			destColR=r;
			destColG=g;
			destColB=b;
			transNormal_cc=0;
			if(state=="bypass"){
				
				startColR=destColR;
				startColG=destColG;
				startColB=destColB;
				
				colR=destColR;
				colG=destColG;
				colB=destColB;
				col=colR*256*256+colG*256+colB;
			}
			if(state=="wait...") state="run...";
		}
	
		public function onEF(e:*=null){
			changed=false;
			if(state=="run..."){
				if(transNormal_cc<transNormal_delay){
					transNormal_cc++;
					var perc=transNormal_cc/transNormal_delay;
					colR=Math.floor(startColR+(destColR-startColR)*perc);
					colG=Math.floor(startColG+(destColG-startColG)*perc);
					colB=Math.floor(startColB+(destColB-startColB)*perc);
					col=colR*256*256+colG*256+colB;
					changed=true;
				}else{
					state="wait...";
					events.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
	}
}