package vjyourself4.games.GP{
	import vjyourself4.input.InputVJYourself;
	import vjyourself4.sys.SystemServices;
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import vjyourself4.games.SynthPath;
	import vjyourself4.games.SynthPath2;
	import vjyourself4.three.assembler.AssemblerObj3D;
	import vjyourself4.cloud.Cloud;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import vjyourself4.three.Path;

	import away3d.primitives.PlaneGeometry;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.materials.ColorMaterial;
	
	import vjyourself4.games.*;
	import vjyourself4.ctrl.BindAnalPipe;

	public class GPSinglePath{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		
		public var assemblerObj3D:AssemblerObj3D;
		public var params:Object;
		
		public var cont3D:ObjectContainer3D;

		public var inputVJY:InputVJYourself;
		public var path:Path;
		public var ctrlPath:CtrlPath;
		public var synthPath:SynthPath2;

		public var anal:BindAnalPipe;
		
		var origoResetCC=0;
		var origoResetDelay=60*10;

		//var plane:Sprite3D;
		
		function GPSinglePath(){
		}
		
		public function init(){
			//VJ input
			inputVJY=new InputVJYourself();
			inputVJY.ns=ns;
			inputVJY.input=ns._glob.sys.input;
			if(params.ctrl!=null) for(var i in params.ctrl) inputVJY[i]=params.ctrl[i];
			inputVJY.init();
			ns.inputVJY=inputVJY;
			
			assemblerObj3D = new AssemblerObj3D();
			assemblerObj3D.cloud = ns._sys.cloud as Cloud;
			assemblerObj3D.musicmeta = ns._sys.music.meta;
			assemblerObj3D.context = ns.context;
			
			
			//3D cont
			cont3D = new ObjectContainer3D();
			
			/*var contOverlay = new ObjectContainer3D();
			cont3D.addChild(contOverlay);

			var planeGeom = new PlaneGeometry(100,100,1,1,false);
			var planeMat = new ColorMaterial(0xff0000);
			planeMat.blendMode="add";
			//plane= new Mesh(planeGeom,planeMat);
			plane=new Sprite3D(planeMat,100,100);

			contOverlay.addChild(plane);
			*/
			//Path
			path= new Path();
			//ns.path=path;
			//ctrlPath
			ctrlPath= new CtrlPath();
			if(params.ctrlPath!=null) for(var i in params.ctrlPath) ctrlPath[i]=params.ctrlPath[i];
			ctrlPath._debug=_debug;
			ctrlPath.path=path;
			ctrlPath.me=ns.me;
			ctrlPath.inputVJY=inputVJY;
			
			//set up path parameters - not supported yet
			var pathParams={type:"Random",ll:300};
			if(params.path!=null){
				if(params.path.type!=null) pathParams.type=params.path.type;
				if(params.path.baseLength!=null) pathParams.ll=params.path.baseLength;
				if(params.path.beforeMe!=null ) ctrlPath.beforeMe=params.path.beforeMe;
				if(params.path.afterMe!=null ) ctrlPath.afterMe=params.path.afterMe;
			}
			ctrlPath.startPath(pathParams);
			
			
			//synthPath
			synthPath = new SynthPath2();
			synthPath._debug=_debug;
			synthPath.cont=cont3D;
			synthPath.path=path;
			synthPath.ctrlPath=ctrlPath;
			synthPath.inputVJY=ns.inputVJY;
			synthPath.context=ns.context;
			synthPath.me=ns.me;
			synthPath.ns=ns;
			
			//synthPath.params=params.init;
			synthPath.assemblerObj3D=assemblerObj3D;
			synthPath.cloud=ns._sys.cloud as Cloud;
			
			path.synth=synthPath;
			ctrlPath.init();
			synthPath.init();
			
			//synthPath.timeline.startMap(ns._glob.cloud.spacesMap);
			currSpace=params.space;
			synthPath.start({prgN:params.space});
			
			anal= new BindAnalPipe();
			anal.tar=synthPath.anal;
		}
		//control
		/*
		 change without total rebuild
			GP.path.setParam() --> change path behavior
			GP.synthPath.timeline.startSpace(prg,trans)

		 just rebuild
		 	GP.restart({path,space})
		*/
		var currSpace:String;
		public function setParams(p){
			var rstr=true;
			if(p.restart!=null) rstr=p.restart;

			if(rstr){
				//destroy streams
				synthPath.destroy("all");
				//reset context
				ns.context.reset();
			}
			//start new Path
			if(p.path!=null) ctrlPath.startPath(p.path);
			else if(rstr) ctrlPath.startPath();

			//start new SpacePrg -> Streams
			if(p.space!=null){
				if(!rstr) synthPath.stopGrow("all");
				synthPath.start({prgN:p.space});
					//ns._sys.cloud.RPrg.cont.programs.path["Prg"+p.space]);
				currSpace=p.space;
			}else if(rstr) synthPath.start({prgN:currSpace});
				//ns._sys.cloud.RPrg.cont.programs.path["Prg"+currSpace]);

		}
		public function restart(p){
			//destroy streams
			synthPath.destroy("all");
			//reset context
			ns.context.reset();
			//start new Path
			if(p.path!=null) ctrlPath.startPath(p.path);
			else ctrlPath.startPath();
			//start new SpacePrg -> Streams
			if(p.space!=null){
				currSpace=p.space;
				synthPath.start({prgN:p.space});
			}else synthPath.start({prgN:currSpace});
		}
		public function onEF(e){
			//RESET
			origoResetCC++;
			if(origoResetCC>=origoResetDelay){
				origoResetCC=0;
				sceneToOrigo();
			}
			inputVJY.onEF(e);
			ctrlPath.onEF(e);
			synthPath.onEF(e);

			//plane.position=me.pos;plane.z+=50;
			
		}
		
		function sceneToOrigo(e=null){
			var shift:Vector3D = new Vector3D(-path.startPos.x,-path.startPos.y,-path.startPos.z);
			log(2,"SceneToOrigo"+shift);
			path.coordShift(shift);
			//ctrlPath.sceneToOrigo(shift);
			synthPath.sceneToOrigo(shift);
		}

		public function dispose(){
			
			inputVJY.dispose();
			inputVJY.ns=null
			inputVJY.input=null;
			delete(ns.inputVJY);
			
			assemblerObj3D=null;

			
			//3D cont
			cont3D.dispose();
		
		
			path.dispose();
			path.synth=null;
			
			ctrlPath.dispose();
			ctrlPath.path=null;
			ctrlPath.me=null;
			ctrlPath.inputVJY=null;
			
			synthPath.dispose();
			synthPath.cont=null;
			synthPath.path=null;
			synthPath.ctrlPath=null;
			synthPath.inputVJY=null;
			synthPath.context=null;
			synthPath.me=null;
			synthPath.ns=null;
			synthPath.assemblerObj3D=null;
			synthPath.cloud=null;
			
			path=null;
			ctrlPath=null;
			synthPath=null;	
		}
		
	}
}