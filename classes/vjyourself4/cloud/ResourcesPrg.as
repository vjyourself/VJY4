package vjyourself4.cloud{

	public class ResourcesPrg{
		public var NS:NamespaceTree;
		public var cont:Object;
		
		function ResourcesPrg(){
			NS = new NamespaceTree();
			cont=NS.cont;
			
		}
		
		public function processData(path:String,data:Object){
			
			var tar=NS.eval(path);
			
			for(var i in data) tar[i]=data[i];
			
		}
		
	}
}