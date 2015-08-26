package vjyourself2.wave{
	public class Auto2Points{
		public var x1=0;
		public var y1=0;
		public var x2=0;
		public var y2=0;
		var a=0;
		
		public var waveForm="";
		public var waveForm_cc=0;
		public var waveForm_ind=0;
		public var waveForm_delays=[1,1,1,0.1];
		public var waveForm_items=["y2","FullCircle","Contra","FullRandom"];
		public var loopLength=24*25;
		public var act=true;
		
		public function Auto2Points(p:Object=null){
			waveForm_ind=Math.floor(Math.random()*waveForm_items.length);
			waveForm=waveForm_items[waveForm_ind];
		}
		public function setVal(v:Number){}
		
		public function onEF(e:*=null){
			a+=Math.PI*2/(loopLength);
			waveForm_cc++;
			if(waveForm_cc>=waveForm_delays[waveForm_ind]*loopLength){
				waveForm_ind=(waveForm_ind+1)%waveForm_items.length;
				waveForm=waveForm_items[waveForm_ind];
				waveForm_cc=0;
				a=0;
			}
			
			switch(waveForm){
			case "y2":
			x1=0//Math.sin(a);
			y1=0//Math.cos(a);
			x2=0//-Math.sin(a);
			y2=-Math.sin(a);
			break;
			
			case "FullCircle":
			var r=0.5
			x1=Math.sin(a)*r;
			y1=Math.cos(a)*r;
			x2=Math.sin(a+Math.PI)*r;
			y2=Math.cos(a+Math.PI)*r;
			break;
			
			case "Contra":
			x1=Math.sin(a);
			y1=0//Math.cos(a);
			x2=0//-Math.sin(a);
			y2=-Math.cos(a);
			break;
			
			case "FullRandom":
			x1=Math.random()*2-1;
			y1=Math.random()*2-1;
			x2=Math.random()*2-1;
			y2=Math.random()*2-1;
			break;
		}
		}
	}
}