package vjyourself4.dson{
	
	public class PrgRandomSides{
		public var names:Array;
		var yes=0;
		var no=0;
		function PrgRandomSides(p:Array){
			names=p[0];
			var pp=p[2];
			for(var i in pp) this[i]=pp[i];
		}
		public function getNext(obj:Object){
			obj[names[0]]=(no+Math.random()*yes)*( Math.round(Math.random())*2-1 );
		}
	}
}