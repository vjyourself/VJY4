package neuralbox2.wave{
	public class WaveFollow{
		public var val:Number=0;
		public var dest:Number=0;
		public var mul=6;
		public var treshold=0.01;
		public var act=true;
		public function WaveFollow(p:Object=null){
			if(p!=null){
			if(p.val!=null){
				dest=val;
				val=val;
			}
			if(p.act!=null) act=p.act;
			if(p.mul!=null) mul=p.mul;
			if(p.treshold!=null) treshold=p.treshold;
			}
		}
		public function setVal(v:Number){
			dest=v;
			if(!act) val=dest;
		}
		public function EF(){
			if(Math.abs(dest-val)<treshold) val=dest;
			val=val+(dest-val)/mul;
		}
		public function onEF(e:*=null){
			EF();
		}
	}
}