package vjyourself4.patt{
	
	public class TrigChannel{
		public var width:Number;
		public var form:String="sin";
		public var val:Number=0;

		public var trigOn:Boolean=false;
		public var cc:Number=0;
		
		public function TrigChannel(){}
		
		public function trig(){
			trigOn=true;
			cc=0;

		}
		public function onEF(p){
			var delta=p.delta;
			if(trigOn){
				cc+=delta;
				var perc=cc/width; if(perc>1)perc=1;
				val=Math.sin(Math.PI*perc);
				if(cc>=width) trigOn=false;
			}
		}
	}
}