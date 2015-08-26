package vjyourself4.three{
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.geom.Vector3D;
	
	public class CtrlRotate{
		public var target:Object;
		public var stage:Stage;
		
		var mouseState:String="Up";
		var mouseX0:Number=0;
		var mouseY0:Number=0;
		var tarRotX:Number=0;
		var tarRotY:Number=0;
		var tarRotX0:Number=0;
		var tarRotY0:Number=0;
		
		public function CtrlRotate(){
			
		}
		public function init(){
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown,0,0,1);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUp,0,0,1);
		}
		function mouseDown(e){mouseState="Down";mouseX0=stage.mouseX;mouseY0=stage.mouseY;}
		function mouseUp(e){mouseState="Up";}
		
		public function onEF(e=null){
			if(mouseState=="Down"){
				var rotY=-(stage.mouseX-mouseX0);
				var rotX=-(stage.mouseY-mouseY0);
				tarRotX+=rotX;
				tarRotY+=rotY;
				mouseX0=stage.mouseX;
				mouseY0=stage.mouseY;
			}
			
			if((tarRotX!=tarRotX0)||(tarRotY!=tarRotY0)){
				target.rotationX=0;
				target.rotationY=0;
				target.rotationZ=0;
				target.rotate(new Vector3D(1,0,0),tarRotX);
				target.rotate(new Vector3D(0,1,0),tarRotY);
				tarRotX0=tarRotX;
				tarRotY0=tarRotY;
			}
		}
	}
}