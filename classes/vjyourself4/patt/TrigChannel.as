package vjyourself4.patt{
	
	public class TrigChannel{
		public var length:Number;
		public var func:Object={t:"none"};
		
		public var trigOn:Boolean=false;
		public var cc:Number=0;
		
		public var val:Number=0;

		public function TrigChannel(){}
		
		public function trig(){
			trigOn=true;
			cc=0;
			val=1;
		}
		public function onEF(p){
			var delta=p.delta;
			if(trigOn){
				cc+=delta;
				var perc=cc/length; if(perc>1)perc=1;
				switch(func.t){
					
					case "none": val=0;break;
					case "insta": val=1;break;
					case "HalfSin":val = Math.sin(Math.PI*perc);break;
					case "FullSin":val = Math.cos(Math.PI*2*perc);break;
					case "Saw":val=perc;break;
					case "ASRSin":
						if(perc<func.A) val=Math.sin(Math.PI/2*perc/func.A);
						if(perc>func.A+func.S) val=Math.cos(Math.PI/2*(perc-func.A-func.S)/func.R);
					break;
					
				}

				if(cc>=length) {
					trigOn=false;
					val=0;
				}
			}
		}
	}
}