package vjyourself4.dson{
	
	public class PrgCircle2D{
		public var radius:Number=1;
		public var alpha:Number=0;
		public var alphaStep:Number=1;
		public var names:Array;
		public var rotation:Boolean=false;
		public var randomAlpha:Boolean=false;
		function PrgCircle2D(p:Array){
			names=p[0];
			var pp=p[2];
			for(var i in pp) this[i]=pp[i];
		}
		public function getNext(obj:Object){
			if(randomAlpha) alpha=Math.random()*360;
			else alpha=(alpha+alphaStep)%360;
			obj[names[0]]=Math.sin(alpha/180*Math.PI)*radius;
			obj[names[1]]=Math.cos(alpha/180*Math.PI)*radius;
			if (names.length>2) obj[names[2]]=180-alpha;
		}
	}
}