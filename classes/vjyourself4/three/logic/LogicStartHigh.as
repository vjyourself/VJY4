package vjyourself4.three.logic{
	public class LogicStartHigh{
		var logic:Object;
		var target:String;
		
		var scale:Number=0;
		public var scale0:Number=3;
		public var scale1:Number=1;
		public var length:Number=60;
		var cc:Number=0;

		public function LogicStartHigh(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
		}
		
		public function init(){
			scale=scale0;
			

		}
		public function onEF(e=null){
			//trace("Start High",scale);
			if(cc<length){
				cc++;
				scale=scale0+Math.sin(cc/length*Math.PI/2)*(scale1-scale0);
			}else scale=scale1;
			logic.obj.res[target].scaleX=scale;
			logic.obj.res[target].scaleY=scale;
			//logic.obj.res[target].scaleZ=scale;
		}
	}
}