package vjyourself4.comp{
	import away3d.textures.BitmapCubeTexture;
	import away3d.primitives.SkyBox;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.TorusGeometry;
	import away3d.materials.TextureMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.entities.Mesh;
	import away3d.tools.helpers.MeshHelper;
	import flash.events.Event;
	
	public class CompSkyBox{
		public var _debug:Object;
		public var _meta:Object={name:"CompBack"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var cont3D:ObjectContainer3D;
		var me:Object;

		var lightPicker;
		var skyTexMat;
		var textureStream;
		var skyCube;

		
		function CompSkyBox(){}

		public function init(){
			me=ns._glob.me;
			textureStream=ns._glob.context.cont.textureStreamBack;

			cont3D = new ObjectContainer3D();

			var skyCubeGeom = new CubeGeometry(6000,6000,6000,1,1,1,false);
			//var skyMat = new ColorMaterial(0x0000ff);
			//skyCubeTex = new BitmapTexture(skyBoxBmpD);
			//skyTexMat = new TextureMaterial(skyCubeTex);
			
		
			skyCube = new Mesh(skyCubeGeom,ns._glob.cloud.R3D.cont.mat[textureStream.getNext()]);
			MeshHelper.invertFaces(skyCube);
			cont3D.addChild(skyCube);

			textureStream.events.addEventListener(Event.CHANGE,texCHANGE,0,0,1);
			

		}
		
		public function texCHANGE(e=null){
			//skyCube.material=ns._glob.cloud.R3D.cont.mat[ns._glob.context.getNext({type:"texture",stream:"Back",params:{}})];
			skyCube.material=ns._glob.cloud.R3D.cont.mat[textureStream.getNext()];
		
		}

		
		public function applyLightPicker(lp){
			//lightPicker=lp;
			//if(skyCubeMat!=null)skyCubeMat.lightPicker=lp;
			//if(skyStripeMat!=null)skyStripeMat.lightPicker=lp;
			//ns.cloud.R3D.globalLightPicker;
		}


		public function onEF(e){
			cont3D.position=me.pos;
			
		}
		
		public function dispose(){
			me=null;
			ns._glob.context.cont.textureStreamBack.events.removeEventListener(Event.CHANGE,texCHANGE);
		}
	}
}