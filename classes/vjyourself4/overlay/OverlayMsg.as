package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class OverlayMsg extends MovieClip{
		

		public function OverlayMsg(){
		}
		
		public function showMsg(txt){
			gotoAndPlay(2);
			tf.text=txt;
		}
		
	}
}