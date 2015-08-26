package vjyourself4.patt{
	public class WaveFollow{
		public var val:Number=0;
		public var dest:Number=0;
		public var div=6;
		public var treshold=0.01;
		public var act=true;
		public function WaveFollow(p:Object=null){
			//trace("SDFDSFSDFDSF");
			if(p!=null){
			if(p.val!=null){
				dest=val;
				val=val;
			}
			if(p.act!=null) act=p.act;
			if(p.mul!=null) div=1/p.mul;
			if(p.div!=null) div=p.div;
			if(p.treshold!=null) treshold=p.treshold;
			}
		}
		public function setVal(v:Number){
			dest=v;
			if(!act) val=dest;
		}
		public function setValAbs(v:Number){
			dest=v;
			val=v;
		}
		public function EF():Number{
			if(Math.abs(dest-val)<treshold) val=dest;
			val=val+(dest-val)/div;
			return val;
		}
		public function onEF(e:*=null){
			EF();
		}
	}
}