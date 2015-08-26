package vjyourself4.dson{
	
	public class PrgRandom{
		public var names:Array;
		var v0:Number=0;
		var v1:Number=1;
		function PrgRandom(p:Array){
			names=p[0];
			var pp=p[2];
			for(var i in pp) this[i]=pp[i];
		}
		public function getNext(obj:Object){
			obj[names[0]]=(v0+Math.random()*(v1-v0));
		}
	}
}