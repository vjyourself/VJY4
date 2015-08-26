package vjyourself4.three.logic{
	public class LogicCtrlScale{
		var logic:Object;
		var target:String;
		var ctrl:Number;
		
		public function LogicCtrlScale(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
		}
		
		public function init(){
		}
		public function onEF(e=null){
			var scale=logic.input.ctrlsA[ctrl];
			logic.obj.res[target].scaleY=scale;
		}
	}
}