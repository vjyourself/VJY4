package vjyourself4.cloud{
	public class NamespaceTree{
		public var R;
		public var cont:Object;
		function NamespaceTree(){
			cont={};
		}
		
		public function eval(path:String):Object{
			var pp=path.split(".");
			var tar=cont;
			for(var i=0;i<pp.length;i++){
				if(tar[pp[i]]==null)tar[pp[i]]={};
				tar=tar[pp[i]];
			}
			return tar;
		}
		
	}
}