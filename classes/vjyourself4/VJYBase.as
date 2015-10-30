package vjyourself4{
	public class VJYBase{
		public var _debug:Object;
		public var _meta:Object={name:"",path:"",cn:""};
		
		public function VJYBase(){

		}	

		public function log(ch,msg){_debug.logMeta(this._meta,ch,msg);}
	
	}
}