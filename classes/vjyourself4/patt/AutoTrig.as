package vjyourself2.wave{
	public class AutoTrig{
		public var elems:Object;
		public var reFireDelay=24*5;
		public var act=true;
		
		public function AutoTrig(p:Object=null){
		}
		public function init(){
			for(var i in elems){
				elems[i].v=0;
				elems[i].reFireCC=0;
			}
		}
		
		
		public function onEF(e:*=null){
			for(var i in elems){
				if(elems[i].v==1){
					elems[i].v=0;
					elems[i].reFireCC=reFireDelay;
				}else{
					if(elems[i].reFireCC>0){
						elems[i].reFireCC--;
					}else{
						elems[i].v=(Math.random()<elems[i].r)?1:0;
						if(elems[i].v==1) trace("FIRE "+i);
					}
				}
			}
		}
	}
}