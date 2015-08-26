package vjyourself2.colors{
	import flash.display.MovieClip;
	public class ColorSrcMC extends MovieClip{
		function ColorSrcMC(){
			//trace("hello");
			//trace(col0);
		}
		public function getArray(num:Number):Array{
			var cols=new Array();
			for(var i=0;i<totalFrames;i++){
				gotoAndStop(i+1);
				var c=[];
				for(var ii=0;ii<num;ii++){
					c.push(this["col"+ii].transform.colorTransform.color);
				}
				cols.push(c);
			}
			return cols;
		}
		public function getJSON(num:Number):String{
			var str="[\n";
			for(var i=0;i<totalFrames;i++){
				gotoAndStop(i+1);
				str+="[";
				for(var ii=0;ii<num;ii++){
					str+=toHex(col0.transform.colorTransform.color);
					if(ii!=num-1) str+=",";
				}
				if(i<totalFrames-1){
					str+="],\n";
				}else{
					str+="]\n";
				}
			}
			str+="]";
			return str;
		}
		function toHex(n:Number):String{
			var ret:String=n.toString(16).toUpperCase();
			while(ret.length<6) ret="0"+ret;
			return "0x" + ret;
		}
	}
}