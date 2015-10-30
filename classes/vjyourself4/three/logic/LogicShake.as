package vjyourself4.three.logic{
	public class LogicShake{
		var logic:Object;
		var target:String;
		var ctrl:Number;
		var aa:Number=0;
		var x=0;
		var y=0;
		var z=0;
		var x0=0;
		var y0=0;
		var z0=0;
		
		public function LogicShake(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
		}
		
		public function init(){
			x0=logic.obj.obj3D.x;
			y0=logic.obj.obj3D.y;
			z0=logic.obj.obj3D.z;
		}

		public function onEF(e=null){
			logic.obj.obj3D.x=x0+(Math.random()*2-1)*x;
			logic.obj.obj3D.y=y0+(Math.random()*2-1)*y;	
			logic.obj.obj3D.z=z0+(Math.random()*2-1)*z;	
		}
	}
}