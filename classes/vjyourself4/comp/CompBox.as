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
	import flash.events.Event;
	
	public class CompBox{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var cont3D:ObjectContainer3D;
		//var me:Object;

		var lightPicker;
		var skyTexMat;
		var textureStream;
		var skyCube;
		var dim:Number=6000;

		var geom="Cube";
		var rotate:Number=0;
		var rotX:Number=0;
		var rotY:Number=0;
		
		function CompBox(){}

		public function init(){
			
			if(params.dim!=null) dim=params.dim;
			textureStream=ns.context.cont["tex"+params.textureStream];

			cont3D = new ObjectContainer3D();
			if(params.visible!=null) cont3D.visible=params.visible;
			
			if(params.rotate!=null) rotate=params.rotate;
			if(params.geom!=null) geom=params.geom;

			switch(geom){
				case "Sphere":var skyCubeGeom = new SphereGeometry(dim/2,16,12,false);break;
				case "Cube":
				default:
				var skyCubeGeom = new CubeGeometry(dim,dim,dim,1,1,1,false);
			}
			//var skyMat = new ColorMaterial(0x0000ff);
			//skyCubeTex = new BitmapTexture(skyBoxBmpD);
			
			if(cont3D.visible) skyTexMat = cloneMaterial(ns._sys.cloud.R3D.cont.mat[textureStream.getNext()]);
			else skyTexMat = new ColorMaterial();
		
			skyCube = new Mesh(skyCubeGeom,skyTexMat);
			
			MeshHelper.invertFaces(skyCube);
			cont3D.addChild(skyCube);

			textureStream.events.addEventListener(Event.CHANGE,texCHANGE,0,0,1);
			
			if(ns.lights!=null){
				//skyCubeMat.lightPicker=lightPicker;
				lightPicker=ns.lights.lp;
				skyTexMat.lightPicker=lightPicker;
			}
			
		}
		
		function cloneMaterial(m:TextureMaterial):TextureMaterial{
			var ret:TextureMaterial=new TextureMaterial(m.texture);
			ret.alpha=m.alpha;
			ret.blendMode=m.blendMode;
			ret.alphaBlending=m.alphaBlending;
			ret.repeat=m.repeat;
			if(lightPicker!=null) ret.lightPicker=lightPicker;
			else if(m.lightPicker!=null) ret.lightPicker=m.lightPicker;
			return ret;
		}
		
		public function setParams(p){
			log(1,"SetParams "+p.visible);
			if(p.visible!=null) cont3D.visible=p.visible;
			if(p.rotate!=null) rotate=p.rotate;
			if(p.textureStream) textureStream=ns.context.cont["tex"+p.textureStream];
		}
		public function texCHANGE(e=null){
			//skyCube.material=ns._glob.cloud.R3D.cont.mat[ns._glob.context.getNext({type:"texture",stream:"Back",params:{}})];
			//skyCube.material=ns._sys.cloud.R3D.cont.mat[textureStream.getNext()];
			//skyTexMat.texture=ns._sys.cloud.R3D.cont.mat[textureStream.getNext()].texture;
			if(cont3D.visible){
				skyTexMat=cloneMaterial(ns._sys.cloud.R3D.cont.mat[textureStream.getNext()]);
				skyCube.material=skyTexMat;
			}
		}

		
		public function applyLightPicker(lp){
			//lightPicker=lp;
			//if(skyCubeMat!=null)skyCubeMat.lightPicker=lp;
			//if(skyStripeMat!=null)skyStripeMat.lightPicker=lp;
			//ns.cloud.R3D.globalLightPicker;
		}


		public function onEF(e){
			if(rotate!=0){
				rotY+=rotate;
				rotX+=rotate/3;
				skyCube.rotationX=rotX;
				skyCube.rotationY=rotY;
			}
			
		}
		
		public function dispose(){
			//me=null;
			textureStream.events.removeEventListener(Event.CHANGE,texCHANGE);
			textureStream=null;
		}
	}
}