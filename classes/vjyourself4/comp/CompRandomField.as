package vjyourself4.comp{
	import away3d.textures.BitmapCubeTexture;
	import away3d.primitives.SkyBox;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.TorusGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.materials.TextureMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.entities.Mesh;
	import away3d.tools.helpers.MeshHelper;
	import flash.geom.Vector3D;
	import flash.events.Event;
	
	public class CompRandomField{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var cont3D:ObjectContainer3D;

		public var ctrl:Boolean=true;

		var inputVJY;

		
		var elemNum=60;
		var elems:Array=[];
		var texturePattern;
		var elemMat;
		var lightPicker;

		public var trans:Object={
			scale:{active:false},
			rot:{active:false},
			rotAni:{active:false},
			customA:{active:false},
			customB:{active:false}
		}
		
		var dim:Number = 3000;
		var objDim:Number = 600;
		var geom="Cube";
		var rotate:Number=0;
		var rotX:Number=0;
		var rotY:Number=0;
		var textureStream:String = "A";

		function CompRandomField(){}

		public function init(){

			//Container
			cont3D = new ObjectContainer3D();
			if(params.visible!=null) cont3D.visible=params.visible;

			//Init Params
			if(params.dim!=null) dim=params.dim;
			if(params.textureStream!=null)textureStream=params.textureStream;
			if(params.rotate!=null) rotate=params.rotate;
			if(params.geom!=null) geom=params.geom;

			//Geom
			switch(geom){
				case "Sphere":var elemGeom = new SphereGeometry(objDim/2,16,12,false);break;
				case "Cube":
				default:
				var elemGeom = new CubeGeometry(objDim,objDim,objDim,1,1,1,false);
			}

			//TextureStream >> Material
			texturePattern=ns.context.cont["tex"+textureStream];
			texturePattern.events.addEventListener(Event.CHANGE,texCHANGE,0,0,1);
			if(cont3D.visible) updateMaterial(ns._sys.cloud.R3D.cont.mat[texturePattern.getNext()]);
			else elemMat = new ColorMaterial();
			if(ns.lights!=null){
				lightPicker=ns.lights.lp;
				elemMat.lightPicker=lightPicker;
			}


			for(var i=0;i<200;i++){
				var elem = new Mesh(elemGeom,elemMat); 
				elems.push({vis:elem,rX:(Math.random()*2-1)*0.02,rY:(Math.random()*2-1)*0.02});
					var r=dim;
				var x=0;
				var y=0;
				var z=0;
				do{
					x=Math.random()*2-1;
					y=Math.random()*2-1;
					z=Math.random()*2-1;
				}while(x*x + y*y + z*z > 1);
				var l=Math.sqrt(x*x + y*y + z*z);
				x=x/l*r;
				y=y/l*r;
				z=z/l*r;
				var phi=0;
				var theta=0;
				//var r=dim+Math.random()*1000;
				/*
				var r=dim;
				var u = Math.random();
   				var v = Math.random();
				var theta = 2 * Math.PI * u;
				var phi = Math.acos(2 * v - 1);
				*/
				/*
				var x = (r * Math.sin(phi) * Math.cos(theta));
				var y = (r * Math.sin(phi) * Math.sin(theta));
				var z = (r * Math.cos(phi));
				*/
				/*
				var phi = Math.random()*Math.PI*2;
				var z=(Math.random()*2-1)*r;
				var theta = Math.asin(z/r)*Math.abs(z);
				//var theta =Math.random()*Math.PI;
				*/
				elem.position = new Vector3D(x,y,z);//polarToCart(r,theta,phi);
				
				elems.push({vis:elem,r:r,theta:theta,phi:phi,rAni:0,rX:Math.random()*2-1,rY:Math.random()*2-1});
				
				cont3D.addChild(elem);
			}
/*
			for(var x=0;x<10;x++){
				for(var y=0;y<10;y++){
				var elem = new Mesh(elemGeom,elemMat); 
				elems.push({vis:elem,rX:Math.random()*2-1,rY:Math.random()*2-1});
				elem.position = polarToCart(dim,x/9*Math.PI,y/9*Math.PI*2);
				cont3D.addChild(elem);
			}}
			*/

			elemNum=elems.length;
		}

		function updateMaterial(m:TextureMaterial){
			if(elemMat==null) elemMat = new TextureMaterial(m.texture);
			elemMat.texture = m.texture;
			elemMat.alpha=m.alpha;
			elemMat.blendMode=m.blendMode;
			elemMat.alphaBlending=m.alphaBlending;
			elemMat.repeat=m.repeat;
			if(lightPicker!=null) elemMat.lightPicker=lightPicker;
			else if(m.lightPicker!=null) elemMat.lightPicker=m.lightPicker;
		}
		public function texCHANGE(e=null){
			trace("RandomField TexCHG");
			if(cont3D.visible){
				updateMaterial(ns._sys.cloud.R3D.cont.mat[texturePattern.getNext()]);
				
			}
		}
		public function start(){
			log(1,"Start");
		}
		
		var transRod:Number=0;
		public function setInput(ch,val){//trace("!!!!!",ch,val);
			/*switch(ch){
				case 0:transRod=val;updateRods();break;
			}*/
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
		/*
		public function applyLightPicker(lp){
			lightPicker=lp;
			//if(skyCubeMat!=null)skyCubeMat.lightPicker=lp;
			if(elemMat!=null)elemMat.lightPicker=lp;
			//ns.cloud.R3D.globalLightPicker;
		}*/

		
		public function onEF(e){
			for(var i=0;i<elemNum;i++){
				var e=elems[i];
				e.vis.rotationX+=e.rX*0.1;
				e.vis.rotationY+=e.rY*0.1;

				//e.rAni+=0.01;
				//e.vis.position = polarToCart(Math.sin(e.rAni)*600+e.r,e.theta,e.phi);
			}
		}
		public function setParams(p:Object){
			if(p.visible!=null) cont3D.visible=p.visible;
		}
		
		public function polarToCart(r,theta,phi):Vector3D{
			var x=r*Math.sin(theta)*Math.cos(phi); 
			var y=r*Math.sin(theta)*Math.sin(phi);
			var z=r*Math.cos(theta);
			return new Vector3D(x,y,z);
		}
		
	}
}