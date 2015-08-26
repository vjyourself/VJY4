package vjyourself4.patt.colors{
	import flash.events.Event;
	public class ColorScale2{
		
		public var state="run";
		public var changed=false;
		public var trans="normal";
		
		public var fader:ColorFader;
		public var cols:Array;
		public var colsInd=0;
		
		public function ColorScale2(p:Object=null){
			fader = new ColorFader();
			fader.events.addEventListener(Event.COMPLETE,faderOnComplete,0,0,1);
		}
		public function init(){
			colsInd=0;
			fader.state="bypass";
			fader.setCol(cols[colsInd]);
			fader.state="wait...";
			colsInd=(colsInd+1)%cols.length;
			fader.setCol(cols[colsInd]);
		}
		function faderOnComplete(e){
			colsInd=(colsInd+1)%cols.length;
			fader.setCol(cols[colsInd]);
		}
		public function onEF(e:*=null){
			fader.onEF();
		}
	}
}