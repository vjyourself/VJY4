package vjyourself4.cloud{
	import vjyourself4.cycle.Cycle;

	public class Cycles{
		public var NS:Object={};
		public var name:String="";
		public var cont:Object;
		
		function Cycles(){
			cont=NS;
		}
		public function add(data){
			for(var i in data) NS[i]=data[i];
		}
		public function getRaw(n:String):Array{
			var ret:Array;
			if(n.charAt(0)=="#") ret=[{},n.substring(1)];
			else ret=NS[n];
			return ret;
		}
		public function createCycle(n,p:Object=null):Cycle{
			//trace("************");for(var i in NS) trace(i);
			var cyc = new Cycle(NS,n,p);
			return cyc;
		}
	}
}