package vjyourself4.comp{
	import away3d.textures.BitmapCubeTexture;
	import away3d.primitives.SkyBox;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.TorusGeometry;
	import away3d.materials.TextureMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.entities.Mesh;
	import away3d.tools.helpers.MeshHelper;
	import away3d.lights.*;
	import away3d.materials.lightpickers.*;

	import vjyourself4.patt.WaveFollow;
	import flash.geom.Vector3D;
	
	public class CompCentralObjs{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var cont3D:ObjectContainer3D;

		
		/*
		public var tragns:Object={
			scale:{active:false},
			rot:{active:false},
			rotAni:{active:false},
			customA:{active:false},
			customB:{active:false}
		}*/
		
		var A1:WaveFollow=new WaveFollow({div:3,treshold:0});
		var A2:WaveFollow=new WaveFollow({div:3,treshold:0});
		var A3:WaveFollow=new WaveFollow({div:3,treshold:0});
		var A4:WaveFollow=new WaveFollow({div:3,treshold:0});
		var A5:WaveFollow=new WaveFollow({div:3,treshold:0});
		var A6:WaveFollow=new WaveFollow({div:3,treshold:0});

		var comp:Object={};
		var res:Object={};
		var lightMode:Number=0;

		function CompCentralObjs(){}

		public function init(){
			cont3D = new ObjectContainer3D();
			if(params.obj==null) params.obj="Cube";
			//SKYBOX
			/*
			var skyBoxBmpD =  new BitmapData(512,512,false,0x003333);
			res.skyBoxBmpD=skyBoxBmpD;
			var skyBoxTexture = new BitmapCubeTexture(skyBoxBmpD,skyBoxBmpD,skyBoxBmpD,skyBoxBmpD,skyBoxBmpD,skyBoxBmpD);
			res.skyBoxTexture = skyBoxTexture;
			var skyBox = new SkyBox(skyBoxTexture);
			comp.skyBox = skyBox;
			cont3D.addChild(skyBox);
			*/

			/*******************************************************************
			 COMP
			 *******************************************************************/

			// LIGHT PICKERs
			//Lights
			var dirLight = new DirectionalLight();
			res.dirLight=dirLight;
   			dirLight.direction=new Vector3D(1, 0, 1);
   			dirLight.castsShadows = false;
			dirLight.color = 0xFFFFFF;
			dirLight.ambient = 0.2;
			dirLight.diffuse = 1;
			dirLight.specular =0.1;
   			cont3D.addChild(dirLight); 
			var dirLight2 = new DirectionalLight();
			res.dirLight2=dirLight2;
   			dirLight2.direction=new Vector3D(0, 0, 1);
   			dirLight2.castsShadows = false;
			dirLight2.color = 0xFFFFFF;
			dirLight2.ambient = 0.3;
			dirLight2.diffuse = 1;
			dirLight2.specular =0;
   			cont3D.addChild(dirLight2); 
			var lightPicker = new StaticLightPicker([dirLight]);
			res.lightPicker=lightPicker;
			var lightPicker2 = new StaticLightPicker([dirLight2]);
			res.lightPicker2=lightPicker2;

			// OBJECTS

			var skyCubeGeom = new CubeGeometry(400,400,400,1,1,1,false);
			res.skyCubeGeom=skyCubeGeom;
			var skySphereGeom = new SphereGeometry(400,16,12,false);
			res.skySphereGeom=skySphereGeom;
			var geom=res["sky"+params.obj+"Geom"];

			var skyCubeMatA = new ColorMaterial(0xff0000);
			res.skyCubeMatA=skyCubeMatA;
			//skyCubeMatA.lightPicker=lightPicker;
			skyCubeMatA.blendMode="add";
			var skyCubeMatB = new ColorMaterial(0x00ff00);
			res.skyCubeMatB=skyCubeMatB;
			//skyCubeMatB.lightPicker=lightPicker;
			skyCubeMatB.blendMode="add";
			//var skyCubeMat = new TextureMaterial(new BitmapTexture(skyBoxBmpD));
			//MeshHelper.invertFaces(skyCube);

			comp.vA=0;
			var contA = new ObjectContainer3D();
			cont3D.addChild(contA);
			comp.contA=contA;
			var skyCubeA = new Mesh(geom,skyCubeMatA);
			contA.addChild(skyCubeA);
			comp.boxA=skyCubeA;
			var skyCubeA2 = new Mesh(geom,skyCubeMatA);
			contA.addChild(skyCubeA2);
			comp.boxA2=skyCubeA2;

			comp.vB=0;
			var contB = new ObjectContainer3D();
			cont3D.addChild(contB);
			comp.contB=contB;
			var skyCubeB = new Mesh(geom,skyCubeMatB);
			contB.addChild(skyCubeB);
			comp.boxB=skyCubeB;
			var skyCubeB2 = new Mesh(geom,skyCubeMatB);
			contB.addChild(skyCubeB2);
			comp.boxB2=skyCubeB2;

			//gns.me.setDirect(300,0,0,0,-90,0);
			ns._glob.me.setDirect(0,0,-1000,0,0,0);
		}

		public function setParams(p){
			for(var i in p){
				switch(i){
					case "obj":setObj(p[i]);break;
					case "lightMode":setLightMode(p[i]);break;
				}
			}
		}
		function setObj(obj){
			params.obj=obj;
			var geom=res["sky"+obj+"Geom"];
			comp.boxA.geometry=geom;
			comp.boxA2.geometry=geom;
			comp.boxB.geometry=geom;
			comp.boxB2.geometry=geom;
				
		}
		public function nextLightMode(e=null){
			//trace("NextLightMode");
			setLightMode((lightMode+1)%4);
		}
		public function setLightMode(val){
			lightMode=val;
			switch(lightMode){
				case 0:
				res.skyCubeMatA.lightPicker=null;
				res.skyCubeMatA.blendMode="add";
				res.skyCubeMatB.lightPicker=null;
				res.skyCubeMatB.blendMode="add";
				break;
				case 1:
				res.skyCubeMatA.lightPicker=res.lightPicker;
				res.skyCubeMatA.blendMode="add";
				res.skyCubeMatB.lightPicker=res.lightPicker;
				res.skyCubeMatB.blendMode="add";
				break;
				case 2:
				res.skyCubeMatA.lightPicker=res.lightPicker;
				res.skyCubeMatA.blendMode="normal";
				res.skyCubeMatB.lightPicker=res.lightPicker;
				res.skyCubeMatB.blendMode="normal";
				break;
				case 3:
				res.skyCubeMatA.lightPicker=null;
				res.skyCubeMatA.blendMode="normal";
				res.skyCubeMatB.lightPicker=null;
				res.skyCubeMatB.blendMode="normal";
				break;
			}
		}


		public function onEF(e){
			var s0=ns._glob.input.gamepadManager.getState(0);
			A1.setVal(s0.LeftStick.x);A1.onEF();
			A2.setVal(s0.LeftStick.y);A2.onEF();
			A3.setVal(s0.LeftTrigger);A3.onEF();
			A4.setVal(s0.RightTrigger);A4.onEF();
			A5.setVal(s0.RightStick.x);A5.onEF();
			A6.setVal(s0.RightStick.y);A6.onEF();

			var s=1+A2.val;
			comp.boxA.scaleX=s;
			comp.boxA.scaleY=s;
			comp.boxA.scaleZ=s;
			comp.boxA2.scaleX=s;
			comp.boxA2.scaleY=s;
			comp.boxA2.scaleZ=s;
			comp.boxA.rotationX+=A1.val*6;
			comp.boxA.rotationY+=A1.val*3;
			comp.boxA2.rotationX+=A1.val*6;
			comp.boxA2.rotationY+=A1.val*3;

			comp.boxA.x=A3.val*400;
			comp.boxA2.x=-A3.val*400;

			var s=1+A6.val;
			comp.boxB.scaleX=s;
			comp.boxB.scaleY=s;
			comp.boxB.scaleZ=s;
			comp.boxB2.scaleX=s;
			comp.boxB2.scaleY=s;
			comp.boxB2.scaleZ=s;
			comp.boxB.rotationX+=A5.val*6;
			comp.boxB.rotationY+=A5.val*3;
			comp.boxB2.rotationX+=A5.val*6;
			comp.boxB2.rotationY+=A5.val*3;

			comp.boxB.x=A4.val*400;
			comp.boxB2.x=-A4.val*400;

			comp.contA.rotationZ+=A3.val*2;
			comp.contB.rotationZ-=A4.val*2;
		
			
			
		}

		public function dispose(){

			//SKYBOX
			//cont3D.removeChild(comp.skyBox);
			//comp.skyBox.dispose();
			
			//BOXES
			comp.contA.removeChild(comp.boxA);
			comp.boxA.dispose();
			comp.boxA=null;
			comp.contA.removeChild(comp.boxA2);
			comp.boxA2.dispose();
			comp.boxA2=null
			cont3D.removeChild(comp.contA);
			comp.contA.dispose();
			comp.contA=null;
			
			comp.contB.removeChild(comp.boxB);
			comp.boxB.dispose();
			comp.boxB=null;
			comp.contB.removeChild(comp.boxB2);
			comp.boxB2.dispose();
			comp.boxB2=null
			cont3D.removeChild(comp.contB);
			comp.contB.dispose();
			comp.contB=null;
			
			// RESOURCES

		//	res.skyBoxTexture.dispose();
		//	res.skyBoxBmpD.dispose();

			res.skyCubeGeom.dispose();
			res.skyCubeMatA.dispose();
			res.skyCubeMatB.dispose();

			// LIGHTS

			res.lightPicker.dispose();
			res.lightPicker2.dispose();
			cont3D.removeChild(res.dirLight);
			res.dirLight.dispose();
   			cont3D.removeChild(res.dirLight2);
			res.dirLight2.dispose();

			cont3D.dispose();		
			
		}
		
	}
}