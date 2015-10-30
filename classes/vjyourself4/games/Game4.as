package vjyourself4.games{
		import flash.geom.Vector3D;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.filters.BlurFilter;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.utils.getDefinitionByName;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	 import away3d.cameras.Camera3D;
 import away3d.containers.Scene3D;
 import away3d.containers.View3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.debug.Trident;
	import away3d.primitives.*;
	import away3d.tools.helpers.*;
	import away3d.core.math.Matrix3DUtils;
	import away3d.containers.View3D;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.entities.SegmentSet;
	import away3d.primitives.LineSegment;
	import away3d.materials.lightpickers.*;
	import away3d.entities.Sprite3D;
	import away3d.filters.*;
	import away3d.textures.BitmapCubeTexture;
	import away3d.materials.SkyBoxMaterial;
	import away3d.primitives.SkyBox;
	import away3d.primitives.ConeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.core.base.Geometry;
	import away3d.filters.BlurFilter3D;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.debug.data.TridentLines;
	import away3d.tools.helpers.*;
	//Lights & Shadows
	import away3d.lights.DirectionalLight;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.materials.methods.TripleFilteredShadowMapMethod;
	import away3d.core.pick.PickingColliderType;
	import away3d.filters.RadialBlurFilter3D;
	
	import 	away3d.cameras.lenses.*;
//	import vjyourself2.src.SrcInput;
	import vjyourself4.patt.WaveFollow;
	import vjyourself4.media.Music;
	import vjyourself4.cloud.Cloud;
	import vjyourself4.three.*;
//	import vjyourself2.post.PostService;
	
	//import vjyourself4.games.ways.GameWaysDynamic;
	import vjyourself4.sys.MetaStream;
	import com.adobe.serialization.json.JSONEncoder;
	import vjyourself4.input.InputVJYourself;
	import vjyourself4.sys.SystemServices;
	//import vjyourself4.games.CtrlSpaceThemes;
	//import vjyourself4.games.CtrlSpaceThemes2;
	//import vjyourself4.games.GPMultiPath;
	import vjyourself4.dson.ColorType;
	//import vjyourself4.games.GP.*;
	import vjyourself4.three.assembler.AssemblerObj3D;
	//import vjyourself4.CallProxy;
	import away3d.debug.AwayStats;
	
	public class Game4{
		public var _debug:Object;
		public var _meta:Object={name:"Game4"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		public var app:Object;
		
		public var dimX=960;
		public var dimY=540;
		
		public var vis:flash.display.Sprite;
		public var view:View3D;
		public var view2:View3D;
		var cam:Camera3D;
		var cam2:Camera3D;
		var lens:LensBase;;
		
		public var params:Object;
		public var sys:SystemServices;
		
		
		
		public var ns:Object;		
		
		public var assemblerObj3D:AssemblerObj3D;
		
		
		var modules:Array;
		var modulesEF:Array;
		var modulesResize:Array;
		
		var awayStats:AwayStats;
		
		var Split3D:Boolean=false;
		var mode_split:Object;
		public var lens_fov:Number=60;

		public function Game4(){
		}
		
		public function init(p:Object=null){
			ns={cloud:sys.cloud,input:sys.input,screen:sys.screen,console:sys.console,sys:sys};
			ns._glob=ns;
			ns._sys=sys;
			ns.game=this;
			log(1,"Init");
			//set up 3D view
			sys.screen.events.addEventListener(Event.RESIZE,onResize,0,0,1);
			if(sys.screen.In3D.mode=="split"){
				Split3D=true;
				mode_split=sys.screen.In3D.mode_split;
			}
			sys.enterframe.events.addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
			vis = new flash.display.Sprite();

			var scene = new Scene3D();
			if(Split3D){
				var lensP:PerspectiveScaleLens = new PerspectiveScaleLens(lens_fov);
				if(mode_split.split=="horizontal"){
					lensP.scaleX=0.5;
					lensP.scaleY=1;
				}else{
					lensP.scaleX=1;
					lensP.scaleY=0.5;
				}
				lens=lensP;
				cam = new Camera3D(lens);
				cam2 = new Camera3D(lens);
			}else{
				lens = new PerspectiveLens(lens_fov)	
				cam = new Camera3D(lens);
			}
			/*cam.lens.matrix.appendScale(0.5,1,1);
			cam.lens = new FreeMatrixLens();
			cam.lens.matrix = new Matrix3D();
			cam.lens.updateMatrix();
			cam.lens.matrix.appendScale(0.5,1,1);
			cam.lens.aspectRatio=2;
			*/

			view = new View3D(scene,cam);
			view.backgroundColor = ColorType.toNumber(params.backgroundColor);
			view.antiAlias = 4;
			view.width = dimX;
			view.height = dimY;
			view.camera.lens.far=40000;
			view.camera.x=0;
			view.camera.y=0;
			view.camera.z=0;
			view.camera.rotationX=0;
			vis.addChild(view);

			if(Split3D){
			view2 = new View3D(scene,cam2);
			view2.backgroundColor = ColorType.toNumber(params.backgroundColor);
			view2.antiAlias = 4;
			view2.width = dimX;
			view2.height = dimY;
			view2.camera.lens.far=40000;
			view2.camera.x=0;
			view2.camera.y=0;
			view2.camera.z=0;
			view2.camera.rotationX=0;
			vis.addChild(view2);
			if(mode_split.split=="horizontal"){
				view.width=dimX/2;
				view.x=0;
				view2.width=dimX/2;
				view2.x=dimX/2;
			}else{
				view.height=dimY/2;
				view.y=0;
				view2.height=dimY/2;
				view2.y=dimY/2;
			}
			}

			/*
			//Tried to scale view without lens, but doesn't work
			view.camera.scaleY=0.5;
			view.scaleY=0.5;
			view.x=100;
			*/

			vis.addEventListener(Event.ADDED_TO_STAGE,onStage);
			sys.screen.addView(view);
			ns.view=view;
			if(ns.sys.screen.stats){
				awayStats = new AwayStats(view);
				vis.addChild(awayStats);
			}
			

			//assembler
			assemblerObj3D = new AssemblerObj3D();
			assemblerObj3D.cloud=sys.cloud as Cloud;
			//assemblerObj3D.input=inputVJY;

			assemblerObj3D.musicmeta = sys.music.meta;
			ns.assemblerObj3D = assemblerObj3D;
			
			ns.camera = view.camera;

			//create me
			/*
			me = new Me();
			me.camera=view.camera;
			me.screen=sys.screen;
			me.input=sys.input;
			me.params=params.me;
			me.init();
			ns.me=me;
			*/
			
			log(1,"Modules");
			//build up modules
			modules=[];
			modulesEF=[];
			modulesResize=[];
			for(var i=0;i<params.elems.length;i++){
				var m=params.elems[i];
				log(2,m.n+" :: "+m.cn);
				var c:Class = getDefinitionByName(m.cn) as Class;
				var o = new c();
				ns[m.n]=o;
				o.ns=ns;
				o.params=m;
				o._debug=_debug;
				o._meta.name=m.n;
				o._meta.cn=m.cn;
				modules.push({obj:o,meta:m});
				if(o.hasOwnProperty("onEF")) modulesEF.push(o);
				if(o.hasOwnProperty("onResize")) modulesResize.push(o);
			}
			for(var i=0;i<modules.length;i++){
				log(2,"init "+modules[i].meta.n);
				modules[i].obj.init();
				if(modules[i].obj.hasOwnProperty("cont3D")) this.view.scene.addChild(modules[i].obj.cont3D);
				if(modules[i].obj.hasOwnProperty("vis")) this.vis.addChild(modules[i].obj.vis);
			}
			
			if(ns.context!=null){
				assemblerObj3D.context=ns.context;
			}

			//Ctrl Remote
			/*
			ctrlRemote = new CtrlRemote();
			ctrlRemote.ns=ns;
			ctrlRemote.params=params.remote;
			ctrlRemote.init();
			*/
			
			return vis;
		}
		
		public function show(n){
			var comp=ns[n];
			if(comp.hasOwnProperty("vis")) comp.vis.visible=!comp.vis.visible;
			if(comp.hasOwnProperty("cont3D")) comp.cont3D.visible=!comp.cont3D.visible;
		}
		function onStage(e=null){
			onResize();
			//trace(">>>onstage");
			//view.filters3d = [new RadialBlurFilter3D()];
		}
		public function onEF(e){
			for(var i=0;i<modulesEF.length;i++)modulesEF[i].onEF(e);
			lens["fieldOfView"]=lens_fov;
			view.render();
			
			if(Split3D){
				var t:Matrix3D = cam.transform.clone();
				//var sss=t.transformVector(new Vector3D(100,0,0));
				t.appendTranslation(mode_split.eyeDistance,0,0);
				cam2.transform=t;
				view2.render();
			}
			
		}
	
		public function onResize(e=null){
			dimX = vis.stage.stageWidth;
			dimY = vis.stage.stageHeight;

			if(Split3D){
				if(mode_split.split=="horizontal"){
					view.width=dimX/2;
					view.height=dimY;
					view.x=0;
					view2.width=dimX/2;
					view2.height=dimY;
					view2.x=dimX/2;
				}else{
					view.height=dimY/2;
					view.width=dimX;
					view.y=0;
					view2.height=dimY/2;
					view2.width=dimX;
					view2.y=dimY/2;
				}
			}else{
				view.width=dimX;
				view.height=dimY;
			}

			for(var i=0;i<modulesResize.length;i++)modulesResize[i].onResize(e);
		}
		
		
		public function dispose(){
			log(1,"Disposed")
			//mstream.log(this,1,"destroy");
			sys.screen.events.removeEventListener(Event.RESIZE,onResize);
			view.dispose();
			
			//narrator=null;
			//input=null;
			//music=null;
			//video=null;
			//mstream=null;
		}

		
	}
}