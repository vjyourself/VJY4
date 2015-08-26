package neuralbox2.wave{
	public class RandomInterval{
		var val0_w=0;
		var val0_x=0;
		public var dim=960;
		public function RandomInterval(){
			
		}
		public function getVal(w:Number){
			var x=0;
			do{
				x=Math.random()*dim;
			}while(! ((x-w/2>=val0_x+val0_w/2)||(x+w/2<=val0_x-val0_w/2)) );
			val0_w=w;
			val0_x=x;
			return x;
		}
	}
}