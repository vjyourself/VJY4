package vjyourself4.cloud{

	public class ResSimple{
		public var NS:Object={};
		public var name:String="";
		public var cont:Object;
		
		function ResSimple(){
			cont=NS;
		}
		public function add(path,data){
			var ns=NS;
			if(path!=""){
				if(NS[path]==null) NS[path]={};
				ns=NS[path];
			}
			for(var i in data) ns[i]=data[i];
		}
		
	}
}