package vjyourself4.prgs{
	
	public class PrgSpiral2D{
		public var radius:Number=1;
		public var alpha:Number=0;
		public var alphaStep:Number=1;
		public var names:Array;
		function PrgSpiral2D(p:Array){
			names=p[0];
			var pp=p[2];
			for(var i in pp) this[i]=pp[i];
		}
		public function getNext(obj:Object){
			alpha+=alphaStep;
			obj[names[0]]=Math.sin(alpha/180*Math.PI)*radius;
			obj[names[1]]=Math.cos(alpha/180*Math.PI)*radius;
		}
	}
}