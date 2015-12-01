package vjyourself4.three.logic{
	import flash.geom.Vector3D;
	import vjyourself4.DynamicEvent;

	public class LogicCirco{
		var logic:Object;
		var target:String;
		var ctrl:Number;
		var aa:Number=0;
		var x0=0;
		var y0=0;
		var x=0;
		var y=0;
		var radius=200;
		var speed=1;
		public function LogicCirco(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
		}
		
		public function init(){
			x0=0;//logic.obj.obj3D.x;
			y0=0;//logic.obj.obj3D.y;
		}
		public function onEF(e:DynamicEvent){
		//	var scale=logic.input.ctrlsA[ctrl];
			
			aa+=0.1*speed*e.data.mul;
			x=Math.sin(aa)*radius+x0;
			y=Math.cos(aa)*radius+y0;
			var v=new Vector3D(x,y,0);
			v=logic.coordTrans.transformVector(v);
			logic.obj.obj3D.x=v.x;
			logic.obj.obj3D.y=v.y;
			logic.obj.obj3D.z=v.z;
			
			
			//logic.obj.obj3D.x=x+(Math.random()*2-1)*10;
			//logic.obj.obj3D.y=y+(Math.random()*2-1)*10;
				
		}
	}
}