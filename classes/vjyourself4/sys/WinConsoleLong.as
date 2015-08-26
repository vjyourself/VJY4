package vjyourself4.sys{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	public class WinConsoleLong extends Sprite{
		public var enabled=true;
		public function WinConsoleLong(){
			addEventListener(MouseEvent.CLICK,onClick,0,0,1);
		}
		public function onClick(e){visible=!visible}
		public function log(txt:String){
			if(enabled){
				tfLines.text+=txt+"\n";
				tfLines.scrollV=tfLines.maxScrollV;
			}
		}
		public function clear(){
			tfLines.text="";
		}
	}
}