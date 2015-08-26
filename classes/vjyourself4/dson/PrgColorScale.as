package vjyourself4.dson{
	
	import vjyourself4.patt.ColorScale;
	public class PrgColorScale{
		public var name:String;
		var colorScale:ColorScale;
		var colors:Array;
		var colInd:Number=0;
		var step:Number=1;
		function PrgColorScale(p:Array){
			name=p[0];
			colors=p[2];
			var pp=p[3];for(var i in pp) this[i]=pp[i];
			colorScale = new ColorScale();
			colorScale.colors=colors;
		}
		public function getNext(obj:Object){
			obj[name]=colorScale.getColor(colInd);
			colInd+=step;if(colInd>colors.length) colInd-=colors.length;
		}
	}
}