package vjyourself4.cloud{

	public class Presets{
		public var NS:Object={};
		public var name:String="";
		public var cont:Object;
		
		function Presets(){
			cont=NS;
		}
		public function add(path,data){
			if(NS[path]==null) NS[path]={};
			var ns=NS[path];
			for(var i in data) ns[i]=data[i];
		}
		
	}
}