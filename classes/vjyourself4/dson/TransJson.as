package  vjyourself4.dson{
	
	public class TransJson {
		public var data;
		public var globals:Object={};
		public function TransJson() {
			// constructor code
		}
		
		public function set(path:String,val){
			var pp:Array=path.split(".");
			var tar:Object=data;
			for(var i=0;i<pp.length-1;i++) tar=tar[pp[i]];
			tar[pp[pp.length-1]]=val;
		}
		public function process(d,rule){
			switch(rule){
				case "over":TransJson.over(data,d);break;
				case "add":TransJson.add(data,d);break;
			}
		}
		public static function add(o:Object,b:Object){
			for(var i in b){
				if(o[i]==null) o[i]=TransJson.clone(b[i]);
					else if((typeof(o[i])=="object")&&(typeof(b[i])=="object")) TransJson.add(o[i],b[i]);
			}
		}

		//recursive container: Object  value clone: Number/Boolean/String + Array
		//container can be overwritten by a non container
		//recursive compare happens if only o[i] & b[i] is container, if one of them only -> it's still simple overwrite
		public static function over(o:Object,b:Object){
			for(var i in b){
				if(o[i]==null) o[i]=TransJson.clone(b[i]); 
				else if( ( (typeof(o[i])=="object") && (!(o[i] is Array)) )&&( (typeof(b[i])=="object") && (!(b[i] is Array)) )){
					TransJson.over(o[i],b[i]);
					} else o[i]=TransJson.clone(b[i]);
			}
		}

		public static function side(o:Object,b:Object){
			for(var i in b){
				if(o[i]==null) o[i]=TransJson.clone(b[i]);
				else if( ( (typeof(o[i])=="object") && (!(o[i] is Array)) )&&( (typeof(b[i])=="object") && (!(b[i] is Array)) )){
					TransJson.side(o[i],b[i]);
				}
			}
		}

		public static function clone(o){
			var ret;
			if( typeof(o)!="object" ) ret=o;
			else {
				if (o is Array){
					ret=[];
					for(var i=0;i<o.length;i++) ret[i]=TransJson.clone(o[i]);
				}else{
					ret={};
					for(var i in o) ret[i]=TransJson.clone(o[i]);
				}
			}
			return ret;
		}
	}
	
}
