package vjyourself4.three.logic{
	public class LogicCtrlDoor{
		var logic:Object;
		var ctrl:Number;
		
		var openX:Number=0;
		var closedX:Number=0;
		var dir:String="Hori";
		public function LogicCtrlDoor(lg,p){
			logic=lg;
			for(var i in p) this[i]=p[i];
		}
		
		public function init(){
			switch(dir){
				case "Hori":
				logic.obj.res.doorA.x=-openX;
				logic.obj.res.doorB.x=openX;
				break;
				case "Vert":
				logic.obj.res.doorA.y=-openX;
				logic.obj.res.doorB.y=openX;
				logic.obj.res.doorA.rotationZ=90;
				logic.obj.res.doorB.rotationZ=90;
				break;
				
			}
			
		}
		public function onEF(e=null){
			var pos=openX+(closedX-openX)*logic.input.ctrlsA[ctrl];
			if(dir=="Hori"){
				logic.obj.res.doorA.x=-pos;
				logic.obj.res.doorB.x=pos;
			}else{
				logic.obj.res.doorA.y=-pos;
				logic.obj.res.doorB.y=pos;
			}
		}
	}
}