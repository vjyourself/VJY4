package neuralbox2.wave{
	public class WaveASR{
		
		public var state="";
		public var val:Number=0;
		public var dest:Number=0;
		var hitlevel:Number=0;
		
		public var A:Number=2;
		public var S:Number=6;
		public var R:Number=20;
		
		var cc=0;
		
		public function WaveASR(p:Object=null){
		}
		public function setVal(v:Number){
			dest=v;
		}
		
		public function onEF(e:*=null){
			switch(state){
				case "":if(dest>0){state="A";cc=0;hitlevel=dest}break;
				case "A":
				cc++;
				val=hitlevel*(cc/A);
				if(cc==A){state="S";cc=0;}
				break;
				case "S":
				cc++;
				val=hitlevel;
				if((cc>=S)&&(dest==0)){
					state="R";
					cc=0;
				}
				break;
				case "R":
				cc++;
				val=hitlevel*(1-cc/R);
				if((cc==R)&&(dest==0)){state="";cc=0;};
				if(dest>0){
					state="S";cc=0;
					hitlevel=dest;
				}
				break;
			}
		}
	}
}