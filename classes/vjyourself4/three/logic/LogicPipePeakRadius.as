package vjyourself4.three.logic{
	public class LogicPipePeakRadius{
		var logic:Object;
		var ctrl:Number=0;
		var firstRun:Boolean = true;
		var radius:Number=1;
		public function LogicPipePeakRadius(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
		}
		public function init(){
			
		}
		public function onEF(e=null){
			if(firstRun) {radius=logic.obj.res.geom.radius;firstRun=false}
			var r=radius;if(logic.input.ctrls[ctrl]==1) r=radius*(1+logic.musicmeta.peak);
			if(logic.obj.res.geom.radius!=r){
				logic.obj.res.geom.radius=r;
				logic.obj.res.geom.updateGeometry();
			}
		}
	}
}