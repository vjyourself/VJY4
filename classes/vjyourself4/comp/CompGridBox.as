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
	
	public class CompGridBox{
		public var _debug:Object;
		public var _meta:Object={name:""};
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
		function CompGridBox(){}

		public function init(){
			//if(params.ctrl!=null) ctrl=params.ctrl;
			//inputVJY=ns.inputVJY;
			//var skyBoxBmpD = new BitmapData(16,16,0);
			//skyBoxTexture = new BitmapCubeTexture(skyBoxBmpD,skyBoxBmpD,skyBoxBmpD,skyBoxBmpD,skyBoxBmpD,skyBoxBmpD);
			cont3D = new ObjectContainer3D();
			if(params.visible!=null) cont3D.visible=params.visible;
			//var skyCubeGeom = new CubeGeometry(6000,6000,6000,1,1,1,false);
			skyStripeMat = new ColorMaterial(0xaaaaaa);
			//skyCubeTex = new BitmapTexture(skyBoxBmpD);
			//skyCubeMat = new TextureMaterial(skyCubeTex);
			
			if(ns.lights!=null){
				//skyCubeMat.lightPicker=lightPicker;
				skyStripeMat.lightPicker=ns.lights.lp;
			}
			
			//skyCube = new Mesh(skyCubeGeom,skyCubeMat);
			//MeshHelper.invertFaces(skyCube);
			//cont3D.addChild(skyCube);

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
			}
			/*
			var torus2 = new Mesh(torusGeom,skyStripeMat);
			//comp.torus2=torus2;
			torus2.rotationX=90;
			cont3D.addChild(torus2);
			*/
			cont3D.addChild(contRods);
		}

		public function start(){
			log(1,"Start");
		}
		
		var transRod:Number=0;
		public function setInput(ch,val){//trace("!!!!!",ch,val);
			switch(ch){
				case 0:transRod=val;updateRods();break;
			}
		}

		public function setMode(m){
			/*
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
			*/
		}
		public function applyLightPicker(lp){
			lightPicker=lp;
			//if(skyCubeMat!=null)skyCubeMat.lightPicker=lp;
			if(skyStripeMat!=null)skyStripeMat.lightPicker=lp;
			//ns.cloud.R3D.globalLightPicker;
		}

		
		public function onEF(e){
			/*
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

			*/
		}
		public function setParams(p:Object){
			if(p.visible!=null) cont3D.visible=p.visible;
		}
		function updateRods(){
			var ss=transRod;	
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
		
	}
}