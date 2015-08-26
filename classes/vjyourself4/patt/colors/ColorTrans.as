package vjyourself4.patt.colors{
	import flash.events.Event;
	public class ColorTrans{
		
	
		public function ColorTrans(){
		
		}
		
		public static function mix(col0,col1,perc):Number{
				var r0=Math.floor(col0/256/256);
				var g0=Math.floor((col0-256*256*r0)/256);
				var b0=col0-256*256*r0-256*g0;
			
				var r1=Math.floor(col1/256/256);
				var g1=Math.floor((col1-256*256*r1)/256);
				var b1=col1-256*256*r1-256*g1;
				
				return Math.floor(r0+(r1-r0)*perc)*256*256 + Math.floor(g0+(g1-g0)*perc)*256+Math.floor(b0+(b1-b0)*perc);
			
		}
	}
}