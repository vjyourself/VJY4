package vjyourself4.patt.colors{
	import flash.events.Event;
	public class ColorConvert{
		
	
		public function ColorConvert(){
			//String :: #FFFFFF 0xffffff ffffff
			//Num :: 1698746
			//RGB :: {r:126,g:12,b:234}
		}
		
		public static function strToNum(s:String):Number{
			var hex:String=s;
			if(s.charAt(0)=="#") hex=hex.substr(1);
			if(s.charAt(1)=="x") hex=hex.substr(2);
			return parseInt(hex,16);
		}
		//public static function numToRGB(n:Number):Object{}
		public static function RGBToNum(o:Object):Number{return o.r*256*256+o.g*256+o.b;}
		//public static function numToString(n:Number,prefix:String=""):String{}
		
		public static function autoToNum(col):Number{
			if(col is Number) return col;
			if(col is String) return strToNum(col);
			if(col is Object) return RGBToNum(col);
			return 0;
		}
	}
}