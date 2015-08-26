package vjyourself4.dson{
	
	public class PrgRandom2D{
		public var radius:Number=1;
		public var hole:Number=0;
		public var names:Array;
		function PrgRandom2D(p:Array){
			names=p[0];
			var pp=p[2];
			for(var i in pp) this[i]=pp[i];
		}
		public function getNext(obj:Object){
			var alpha=Math.random()*Math.PI*2;
			var r=Math.random()*(radius-hole)+hole;
			obj[names[0]]=Math.sin(alpha)*r;
			obj[names[1]]=Math.cos(alpha)*r;
		}
	}
}