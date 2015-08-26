package vjyourself4.games.GP{
	import vjyourself4.input.InputVJYourself;
	import vjyourself4.sys.SystemServices;
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import vjyourself4.games.SynthPath;
	import vjyourself4.three.assembler.AssemblerObj3D;
	import vjyourself4.cloud.Cloud;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import vjyourself4.games.*;

	public class GPRoaming{
		public var inputVJY:InputVJYourself;
		public var sys:SystemServices;
		public var assemblerObj3D:AssemblerObj3D;
		public var me:Me;
		public var params:Object;
		
		public var cont:ObjectContainer3D;
		//public var ctrlPath:CtrlPath;
		//public var synthPath:SynthPath;
		var dir:Matrix3D;
		var pos:Vector3D;
		var synthRoom:SynthRoom;

		
		function GPRoaming(){
		}
		
		public function init(){
			//3D cont
			cont = new ObjectContainer3D;
			
			pos = new Vector3D(0,0,0);
			dir = new Matrix3D();

			inputVJY.setMode("roaming");
			
			//synthRoom
			synthRoom = new SynthRoom();
			synthRoom.cont=cont;
			synthRoom.me=me;
			synthRoom.params=params.synthRoom;
			synthRoom.assemblerObj3D=assemblerObj3D;
			synthRoom.cloud=sys.cloud as Cloud;
			synthRoom.init();
			cont.addChild(synthRoom.cont);
		}
		
		public function onEF(e){
			/*
			dir = new Matrix3D();
			var cameraX:Vector3D = new Vector3D(1,0,0);
			var cameraY:Vector3D = new Vector3D(0,1,0);
			var cameraZ:Vector3D = new Vector3D(0,0,1);
			dir.appendRotation(inputVJY.cameraRotX,cameraX);
			dir.appendRotation(inputVJY.cameraRotY,cameraY);
			dir.appendRotation(inputVJY.cameraRotZ,cameraZ);
			*/
			
			var mov = new Vector3D(0,0,1);
			mov=inputVJY.look.transformVector(mov);
			mov.scaleBy(inputVJY.speed);
			pos=pos.add(mov);
			//set me rotation + postition;
			me.setTransform(pos,inputVJY.look);
			//trace(inputVJY.cameraRotX,inputVJY.cameraRotY,inputVJY.cameraRotZ);
			synthRoom.onEF(e);
		}
		
		function sceneToOrigo(e=null){
			//var shift:Vector3D = new Vector3D(-ctrlPath.path.startPos.x,-ctrlPath.path.startPos.y,-ctrlPath.path.startPos.z);
			//trace("SHIFT:"+shift);
			
		}
		
	}
}