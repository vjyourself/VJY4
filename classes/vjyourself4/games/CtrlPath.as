package vjyourself4.games{
	
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.display.BlendMode;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.geom.ColorTransform;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.cameras.Camera3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.TorusGeometry;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.primitives.CylinderGeometry;
	import away3d.tools.helpers.MeshHelper;
	
	//lighting & shadows
	import away3d.materials.lightpickers.*;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.materials.methods.TripleFilteredShadowMapMethod;
	
	import vjyourself4.patt.WaveFollow;
	import vjyourself4.three.*;

	import vjyourself4.input.InputVJYourself;
	
	
	public class CtrlPath{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		//in
		public var me:Me;
		public var inputVJY:InputVJYourself;
		public var path:Path;
		public var onEnd:Function; //callback
		
		//self
		public var doGrow:Boolean=true;
		public var pMe:Number=0;
		public var speed:Number=0;
		public var cameraRotX:Number=0;
		public var cameraRotY:Number=0;
		public var cameraRotZ:Number=0;
		public var pathRot:Matrix3D;
		
		public var beforeMe:Number=2400;
		public var afterMe:Number=200;

		public var cameraMode:String="beginning";
		var cameraModeChanged:Boolean=false;
	
		public var state:String="run";
		
		function CtrlPath(){}
		
		public function init(){}

		public function startPath(p=null){
			log(1,"Start New Path");
			path.destroyPath();
			path.startPos=new Vector3D();
			path.startRot=new Matrix3D();
			if(p!=null) path.setParams(p);
			pMe=afterMe;
			path.setp0(pMe-afterMe);
			path.setp1(pMe+beforeMe);
			pathRot = new Matrix3D();
			cameraModeChanged=true;
			onEF();
		}
		public function nextCameraMode(){
			switch(cameraMode){
				case "end":cameraMode="beginning";break;
				case "beginning":cameraMode="end";break;
			}
			cameraModeChanged=true;
		}
		public function setCameraMode(str){
			cameraMode=str;
			cameraModeChanged=true;
		}
		/*
		public function stopGrowing(){
			//trace("STOP ME GROW BABE");
			//doGrow=false;
		}
		
		*/

		//public function sceneToOrigo(shift){path.coordShift(shift);}
					
		public function onEF(e=null){

			//INPUT
			speed=inputVJY.speed;
			cameraRotX=inputVJY.cameraRotX;
			cameraRotY=inputVJY.cameraRotY;
			cameraRotZ=inputVJY.cameraRotZ;
			
			//move pMe
			pMe+=speed;
			
			//calculate CAMERA
			var mePos:Vector3D;
			var rtp:Number;
			var pathNewRot:Matrix3D;
			var axesY:Vector3D;
			switch(cameraMode){
					case "beginning":
					mePos = path.getPos(pMe);
					rtp=pMe+200; if(rtp>path.p1) rtp=path.p1;
					pathNewRot=path.getRot(rtp);
					break;
					case "middle":
					mePos = path.getPos(pMe+(beforeMe-400)/2);
					rtp=pMe+(beforeMe-400)/2; if(rtp>path.p1) rtp=path.p1;
					pathNewRot=path.getRot(rtp);
					axesY=new Vector3D(0,1,0);
					pathNewRot.appendRotation(180,axesY);
					break;
					case "end":
					mePos = path.getPos(pMe+(beforeMe-400));
					rtp=pMe+(beforeMe-400); if(rtp>path.p1) rtp=path.p1;
					pathNewRot=path.getRot(rtp);
					axesY=pathNewRot.transformVector(new Vector3D(0,1,0));
					pathNewRot.appendRotation(180,axesY);
					break;
			}
				
			if(cameraModeChanged){
				cameraModeChanged=false;
				pathRot=pathNewRot.clone();
			}
			var transCam=Matrix3D.interpolate(pathRot,pathNewRot,speed*0.01+0.01);
			pathRot.copyFrom(transCam);
			//B.2.add relative camera rotation
			var cameraX:Vector3D = transCam.transformVector(new Vector3D(1,0,0));
			var cameraY:Vector3D = transCam.transformVector(new Vector3D(0,1,0));
			var cameraZ:Vector3D = transCam.transformVector(new Vector3D(0,0,1));
			transCam.appendRotation(cameraRotX,cameraY);
			transCam.appendRotation(cameraRotY,cameraX);
			transCam.appendRotation(cameraRotZ,cameraZ);
			
			//set me rotation + postition;
			//trace(pMe+" "+mePos.z);
			me.setTransform(mePos,transCam);
			
			//ADJUST PATH
			path.setpMe(pMe);
			path.setp0(pMe-afterMe);
			path.setp1(pMe+beforeMe);
		}

		public function dispose(){
			
		}
		
	}
}