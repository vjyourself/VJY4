package vjyourself4.sys{
	import flash.display.Sprite;
	public class WinConsole extends Sprite{
		public function WinConsole(){
			tfLine0.text="";
			tfLine1.text="";
			tfLine2.text="";
		}
		public function log(txt:String){
			tfLine0.text=tfLine1.text;
			tfLine1.text=tfLine2.text;
			tfLine2.text=txt;
		}
	}
}