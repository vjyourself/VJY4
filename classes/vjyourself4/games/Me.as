package vjyourself4.games{
	import flash.geom.Matrix3D;
	import away3d.cameras.Camera3D;
	import away3d.materials.lightpickers.*;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.containers.Scene3D;
	import flash.geom.Vector3D;
	import flash.events.MouseEvent;

	public class Me{
		public var _debug:Object;
		public var _meta:Object={name:"Me"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		//in
		public var ns:Object;
		var camera:Camera3D;
		var input;
		var screen;
		public var params:Object;
		
		//self
		public var pos:Vector3D = new Vector3D();
		public var rot:Matrix3D = new Matrix3D();
		
		//var gui:GUIMe;
		/*
		public var x:Number=0;
		public var y:Number=0;
		public var z:Number=0;
		public var sx:Number=0;
		public var sy:Number=0;
		public var sz:Number=0;
		public var speed:Number=0;
		public var cameraRotX:Number=0;
		public var cameraRotY:Number=0;
		public var cameraRotZ:Number=0;
		public var cameraRot:Matrix3D;
		*/
		
		
		public var cameraMode:String="inside" // inside / outside
		var cameraModes:Array=["inside","outside"];
		var cameraAnglesInd:Number=0;
	
		
		public function Me(){}
		
		public function setCameraMode(b){
			cameraMode=b;
		}

		public function nextCameraMode(){
			if(cameraMode=="inside")cameraMode="outside";
			else cameraMode="inside";
			/*
			cameraAnglesInd=(cameraAnglesInd+1)%cameraAngles.length;
			cameraAngle=cameraAngles[cameraAnglesInd];
			*/
		}
		public function init(){
			camera = ns.camera;
			input = ns.input;
			screen = ns.screen;
			if(params==null) params={};
			if(params.lights==null)params.lights={gamepad:"",click:false};
			/*
			if(params.gui){
				gui = new GUIMe();
				if(params.gui.display!=null) gui.visible=params.gui.display;
				//screen.gui.addChild(gui,params.gui);
			}*/
		
			//Craft
			/*
			var craftMC = new ColorMaterial(0x66aa33);
			var craftGeom = new CubeGeometry(10,10,30);
			craft = new Mesh(craftGeom,craftMC);
			cont.addChild(craft);
			*/

			//Camera
			camera.x=0;
			camera.y=0;
			camera.z=-1000;
			camera.rotationX=0;
			camera.rotationY=0;
			camera.rotationZ=0;
			
		}
		
		public function setDirect(x,y,z,rotX,rotY,rotZ){
			camera.x=x;
			camera.y=y;
			camera.z=z;
			camera.rotationX=rotX;
			camera.rotationY=rotY;
			camera.rotationZ=rotZ;
		}
		public function setTransform(vPos,mRot){
			pos=vPos;
			rot=mRot;
			switch(cameraMode){
				case "inside":
				camera.transform=rot;
				camera.x=pos.x;
				camera.y=pos.y;
				camera.z=pos.z;
				break;
				case "outside":
				camera.transform=rot;
				var npos:Vector3D = pos.clone();
				npos.incrementBy(rot.transformVector(new Vector3D(0,300,0)));
				camera.x=npos.x;
				camera.y=npos.y;
				camera.z=npos.z;
				break;
			}
			
			//if(gui) gui.tfPos.text=Math.floor(pos.x)+" / "+Math.floor(pos.y)+" / "+Math.floor(pos.z);
		}
		
		public function toOrigo(){
			setTransform(new Vector3D(0,0,0),rot);
		}
		public function onEF(e=null){
			
			//meState.tfX.text=""+me.pos.x;
			//meState.tfY.text=""+me.pos.y;
			//meState.tfZ.text=""+me.pos.z;
			
			/*
			craft.transform=me.rot;
			craft.x=me.pos.x;
			craft.y=me.pos.y;
			craft.z=me.pos.z;
			*/
			
		}
	}
}