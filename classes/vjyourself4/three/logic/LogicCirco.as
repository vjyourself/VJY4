package vjyourself4.three.logic{
	public class LogicCirco{
		var logic:Object;
		var target:String;
		var ctrl:Number;
		var aa:Number=0;
		var x=0;
		var y=0;
		var radius=200;
		var speed=1;
		public function LogicCirco(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
		}
		
		public function init(){
			x=logic.obj.obj3D.x;
			y=logic.obj.obj3D.y;
		}
		public function onEF(e=null){
		//	var scale=logic.input.ctrlsA[ctrl];
			
			aa+=0.1*speed;
			logic.obj.obj3D.x=Math.sin(aa)*radius+x;
			logic.obj.obj3D.y=Math.cos(aa)*radius+y;
			
			//logic.obj.obj3D.x=x+(Math.random()*2-1)*10;
			//logic.obj.obj3D.y=y+(Math.random()*2-1)*10;
				
		}
	}
}