package vjyourself4.patt{
	import flash.events.Event;
	public class ColorScale{
		
		public var colors:Array;
		
		public function ColorScale(p:Object=null){
		
		}
		
		public function getColor(x:Number):Number{
		
			var colInd0=Math.floor(x) % colors.length;
			var colInd1=Math.ceil(x) % colors.length;
			
			if(colInd0==colInd1){
				return colors[colInd0];
			}else{
				var perc=x-colInd0;
				var col0=colors[colInd0];
				var r0=Math.floor(col0/256/256);
				var g0=Math.floor((col0-256*256*r0)/256);
				var b0=col0-256*256*r0-256*g0;
				var col1=colors[colInd1];
				var r1=Math.floor(col1/256/256);
				var g1=Math.floor((col1-256*256*r1)/256);
				var b1=col1-256*256*r1-256*g1;
				
				return Math.round(r0+(r1-r0)*perc)*256*256 + Math.round(g0+(g1-g0)*perc)*256+Math.round(b0+(b1-b0)*perc);
			}
		}
	}
}