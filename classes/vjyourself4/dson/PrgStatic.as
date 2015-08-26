package vjyourself4.prgs{
	
	public class PrgStatic{
		public var vals:Object;
		function PrgStatic(p:Object){
			vals=p;
		}
		public function getNext(obj:Object){
			for(var i in vals) obj[i]=vals[i];
		}
	}
}