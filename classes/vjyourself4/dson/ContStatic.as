package vjyourself4.dson{
	import flash.utils.getDefinitionByName;
	//import vjyourself4.ContArray;

	public class ContStatic{
		var d;
		function ContStatic(data){
			d=data;
		}
		public function getNext(){
			trace("> get next");
			return d;
		}
		
	}
}