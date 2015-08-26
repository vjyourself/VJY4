package vjyourself4.three.logic{
	public class LogicPipeFillPerc{
		var logic:Object;
		var ctrl:Number;
		public function LogicPipeFillPerc(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
		}
		
		public function onEF(e=null){
			logic.obj.res.geom.fillPerc=1-logic.input.ctrlsA[ctrl];
			logic.obj.res.geom.updateGeometry();
		}
	}
}