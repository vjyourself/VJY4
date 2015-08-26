package neuralbox2.wave{
	public class WaveEase{
		public var val:Number=0;
		
		public var tup=0.2;
		public var tdown=0.2;
		public var tconst=0.4;
		public var vmax=0;
		
		public function WaveEase(p:Object=null){
			if(p!=null){
			if(p.t!=null){ tup=p.t;tdown=p.t;}
			if(p.tup!=null) tup=p.tup;
			if(p.tdown!=null) tdown=p.tdown;
			}
			tconst=1-tup-tdown;
			vmax=1/(tup/2+tconst+tdown/2);
		}
		public function setVal(t:Number){
			//speed up
			if(t<=tup){
				var tloc=t;
				val=tloc*tloc*vmax/tup/2;
			}
			//speed const
			if((t>tup)&&(t<1-tdown)){
				var tloc=t-tup;
				val=tup*vmax/2+vmax*tloc;
			}
			//speed down
			if(t>=1-tdown){
				var tloc=1-t;//revers tloc (from the end)
				val=1-(tloc*tloc*vmax/tdown/2);
			}
			
			return val;
		}
		public function EF(){}
		public function onEF(e:*=null){}
	}
}