package vjyourself4.ani{
	import flash.display.MovieClip;
	public class AniFlash extends MovieClip{
		public function AniFlash(){
			visible=false;
		}
		public function setInput(n,val){
			visible=val>0.1;
		}
		public function onEF(e){

		}
		public function resize(w,h){

		}
	}
}