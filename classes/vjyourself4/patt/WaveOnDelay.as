package neuralbox2.wave{
	import neuralbox2.wave.WaveFollow;
	public class WaveOnDelay{
		public var val:Number=0;
//		public var act=true;
		public var delay=24;
		public var state=0;
		var cc=0;
		var dest=0;
		
		var WF:WaveFollow;
		public function WaveOnDelay(p:Object=null){
			WF = new WaveFollow(p);
			if(p!=null){
			if(p.delay!=null) delay=p.delay;
			}
		}
		public function setVal(v:Number){
			trace("setVal:"+v);
			dest=v;
			switch(state){
				//zero
				case 0: if(v==1){
					WF.setVal(1);
					state=1;
					dest=1;
					}
					break;
				//run up
				case 1:
					dest=v;
					break;
				//delay
				case 2:
					if(v==1){
						state=1;
						cc=0;
					}
					break;
				//run down
				case 3:
					if(v==1){
						state=1;
						WF.setVal(1);
					}
					break;
				}
		}
		public function EF(){
			onEF();
		}
		public function onEF(e:*=null){
			switch(state){
				//zero
				case 0:break;
				//run up - one
				case 1:
				WF.onEF();
				if((WF.val==1)&&(dest==0)){
					state=2;
					cc=0;
				}
				break;
				//delay
				case 2:
				cc++;
				if(cc>=delay){
					state=3;
					WF.setVal(0);
				}
				break;
				//run down
				case 3:
				WF.onEF();
				if(WF.val==0) state=0;
				break;
			}
			val=WF.val;
		}
		
		
	}
}