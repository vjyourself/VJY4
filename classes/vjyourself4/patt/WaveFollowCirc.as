package vjyourself.wave{
	public class WaveFollowCirc{
		public var val:Number=0;
		public var dest:Number=0;
		public var mul=6;
		public var treshold=0.01;
		public var act=true;
		public var dir=1;
		public var lim=360;
		public function WaveFollowCirc(p:Object=null){
			if(p!=null){
			if(p.val!=null){
				dest=val;
				val=val;
			}
			if(p.lim!=null) lim=p.lim
			if(p.act!=null) act=p.act;
			if(p.mul!=null) mul=p.mul;
			if(p.treshold!=null) treshold=p.treshold;
			}
		}
		public function setVal(v:Number){
			dest=v;
			if(!act) val=dest;
			var dp=dest-val;if(dp<0) dp=dp+lim;
			var dm=val-dest;if(dm<0) dm=dm+lim;
			dir=1;
			if(dm<dp) dir=-1;
			trace("v:"+val+" d:"+dest+" dir:"+dir);
		}
		public function EF(){
			//if(Math.abs(dest-val)<treshold) val=dest;
			if(dir==1){
				var dp=dest-val;if(dp<0) dp=dp+lim;
				val=val+(dp)/mul;
			}else{
				var dm=val-dest;if(dm<0) dm=dm+lim;
				val=val-(dm)/mul;
			}
			if(val<0) val+=lim;
			if(val>lim) val-=lim;
		}
		public function onEF(e:*=null){
			EF();
		}
	}
}