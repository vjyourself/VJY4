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
	
	public class CompFore{
		public var _debug:Object;
		public var _meta:Object={name:"CompFore"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var cont3D:ObjectContainer3D;

		public var contRods:ObjectContainer3D;

		public var ctrl:Boolean=true;

		var inputVJY;

		var skyBoxTexture;
		var skyCubeMat:TextureMaterial;
		var skyStripeMat:ColorMaterial;
		var skyCubeTex:BitmapTexture;
		var skyCube:Mesh;

		var comp:Object={};
		var torusNum=5;
		var lightPicker;

		public var trans:Object={
			scale:{active:false},
			rot:{active:false},
			rotAni:{active:false},
			customA:{active:false},
			customB:{active:false}
		}
		
		public var mode:String="Plane";
		function CompFore(){}

		public function init(){
			cont3D = new ObjectContainer3D();
			//if(params.ctrl!=null) ctrl=params.ctrl;
			
			/*
			var skyBoxBmpD = new BitmapData(16,16,0);
			//skyBoxTexture = new BitmapCubeTexture(skyBoxBmpD,skyBoxBmpD,skyBoxBmpD,skyBoxBmpD,skyBoxBmpD,skyBoxBmpD);
			

			var skyCubeGeom = new CubeGeometry(6000,6000,6000,1,1,1,false);
			skyStripeMat = new ColorMaterial(0xaaaaaa);
			skyCubeTex = new BitmapTexture(skyBoxBmpD);
			skyCubeMat = new TextureMaterial(skyCubeTex);
			
			if(lightPicker!=null){
				skyCubeMat.lightPicker=lightPicker;
				skyStripeMat.lightPicker=lightPicker;
			}
			
			skyCube = new Mesh(skyCubeGeom,skyCubeMat);
			MeshHelper.invertFaces(skyCube);
			cont3D.addChild(skyCube);

			var torusGeom = new TorusGeometry(3000,200,4,4);
			contRods = new ObjectContainer3D();
			for(var i=0;i<torusNum;i++){
				var torus = new Mesh(torusGeom,skyStripeMat);
				comp["torus"+i]=torus;
				contRods.addChild(torus);
			}

			for(var i=0;i<torusNum;i++){
				var torus = new Mesh(torusGeom,skyStripeMat);
				comp["torusB"+i]=torus;
				torus.rotationX=90;
				var ss=0.9;
				torus.scaleX=ss;
				torus.scaleY=ss;
				torus.scaleZ=ss;
				contRods.addChild(torus);
			}*/
			/*
			var torus2 = new Mesh(torusGeom,skyStripeMat);
			//comp.torus2=torus2;
			torus2.rotationX=90;
			cont3D.addChild(torus2);
			*/
		}

		public function start(){
			log(1,"Start");
		}
		public function setMode(m){
			if(m!=mode){
				switch(mode){
					case "Plane":break;
					case "Rods":cont3D.removeChild(contRods);break;
				}
				mode=m;
				switch(mode){
					case "Plane":break;
					case "Rods":cont3D.addChild(contRods);break;
				}
			}
		}
		public function applyLightPicker(lp){
			lightPicker=lp;
			if(skyCubeMat!=null)skyCubeMat.lightPicker=lp;
			if(skyStripeMat!=null)skyStripeMat.lightPicker=lp;
			//ns.cloud.R3D.globalLightPicker;
		}
		public function setTexture(cn){
			var c:Class = getDefinitionByName(cn) as Class;
			var skyBoxBmpD = new c();
			skyCubeTex.bitmapData=skyBoxBmpD;
			skyCubeTex.invalidateContent();
		}
		public function onEF(e){
			/*
			cont3D.position=ns.me.pos;
			
			//TRANS SCALE
			if(trans.scale.active){
				var t=trans.scale;
				var s=1-inputVJY.ctrlsA[t.A];
				cont3D.scaleX=s;
				cont3D.scaleY=s;
				cont3D.scaleZ=s;
			}

			//TRANS ROT ANI
			if(trans.rotAni.active){
				var t=trans.rotAni;
				cont3D.rotationX+=inputVJY.ctrlsA[t.A];
				cont3D.rotationY+=inputVJY.ctrlsA[t.A]*0.5;
			}

			//CUSTOM TRANS
			switch(mode){
				case "Rods":
				if(trans.customA.active){
					var t=trans.customA;
					var ss=1-inputVJY.ctrlsA[t.A];	
					var w=3000*ss;
					for(var i=0;i<torusNum;i++){
						var torus = comp["torus"+i];
						torus.y=w*(i/torusNum*2-1);
					}
					for(var i=0;i<torusNum;i++){
						var torus = comp["torusB"+i];
						torus.z=w*(i/torusNum*2-1);
					}
				}
				break;
			}
			
			*/
		}
		
	}
}