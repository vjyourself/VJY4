package vjyourself4.patt.colors{
	import flash.events.EventDispatcher;
	import flash.events.Event;

	public class ColorScale3{
		
		public var cols:Array;
		
		
		public function ColorScale3(p:Object=null){
			
		}
		public function getColor(perc:Number):int{
			var ind0=Math.floor((cols.length-1)*perc);
			var ind1=ind0+1;if(ind1>=cols.length) ind1=cols.length-1;
			var cp=(perc-ind0*(1/(cols.length-1)))/(1/(cols.length-1));
			var col0=getRGB(cols[ind0]);
			var col1=getRGB(cols[ind1]);

			var cR=Math.floor(col0.r+(col1.r-col0.r)*cp);
			var cG=Math.floor(col0.g+(col1.g-col0.g)*cp);
			var cB=Math.floor(col0.b+(col1.b-col0.b)*cp);
			var c=cR*256*256+cG*256+cB;
			return c;
		}
		public function getRGB(v:Number):Object{
			var o={};
			o.r=Math.floor(v/256/256);
			o.g=Math.floor((v-256*256*o.r)/256);
			o.b=v-256*256*o.r-256*o.g;
			return o;
		}
	
	}
}