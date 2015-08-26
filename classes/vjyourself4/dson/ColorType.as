package vjyourself4.dson{
	public class ColorType{
		public function ColorType(){
			
		}
		
		public static function toNumber(val){
			//trace("ColorType: "+val+" "+(typeof val));
			var rval:Number=0;
			if(typeof val == "number") rval=val;
			if(typeof val == "string"){
				if(val.charAt(0)=="#") val=val.substr(1);
				//trace(val);
				rval = parseInt(val,16);
			}
			return rval;
		}
	}
}