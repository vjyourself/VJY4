package vjyourself4.comp{
	import vjyourself4.input.InputVJYourself;
	import vjyourself4.sys.SystemServices;
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import vjyourself4.games.SynthPath;
	import vjyourself4.three.assembler.AssemblerObj3D;
	import vjyourself4.cloud.Cloud;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import vjyourself4.three.Path;
	import vjyourself4.games.ContextManager;

	import away3d.primitives.PlaneGeometry;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.materials.ColorMaterial;
	
	import vjyourself4.games.*;
	public class CompSpace{
		public var ns:Object;
		public var inputVJY:InputVJYourself;
		public var assemblerObj3D:AssemblerObj3D;
		public var me:Me;
		public var params:Object;
		
		public var cont3D:ObjectContainer3D;
		public var path:Path;
		public var ctrlPath:CtrlPath;
		public var synthPath:SynthPath;
		public var context:ContextManager;
		
		var origoResetCC=0;
		var origoResetDelay=60*10;

		var plane:Sprite3D;
		
		function GPSinglePath(){
		}
		
		public function init(){
			//VJ input
			/*
			inputVJY=new InputVJYourself();
			inputVJY.ns=ns;
			inputVJY.input=sys.input;
			if(params.ctrl!=null) for(var i in params.ctrl) inputVJY[i]=params.ctrl[i];
			inputVJY.init();
			ns.inputVJY=inputVJY;
			*/
			inputVJY=ns.inputVJY;
			assemblerObj3D=ns.assemblerObj3D;
			me=ns.me;
			
			//3D cont
			cont3D = new ObjectContainer3D();
			var contPath = new ObjectContainer3D();
			cont3D.addChild(contPath);
			
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
			
			//ctrlPath
			ctrlPath= new CtrlPath();
			ctrlPath.path=path;
			ctrlPath.me=me;
			ctrlPath.inputVJY=inputVJY;
			
			//set up path parameters - not supported yet
			var pathParams={type:"Random",ll:300};
			if(params.path!=null) pathParams={type:params.path.type,ll:params.path.baseLength};
			ctrlPath.startPath(pathParams);
			
			
		
			
			//synthPath
			synthPath = new SynthPath();
			synthPath.cont=cont3D;
			synthPath.path=path;
			synthPath.ctrlPath=ctrlPath;
			synthPath.inputVJY=inputVJY;
			synthPath.context=context;
			synthPath.me=me;
			synthPath.ns=ns;
			
			//synthPath.params=params.init;
			synthPath.assemblerObj3D=assemblerObj3D;
			synthPath.cloud=ns.cloud as Cloud;
			
			path.synth=synthPath;
			ctrlPath.init();
			synthPath.init();
			cont3D.addChild(synthPath.cont);
			
			synthPath.timeline.startMap(ns.cloud.spacesMap);
			//synthPath.timeline.startSpace(ns.cloud.RPrg.cont.programs.path["PrgMultiRegulator"]);
			
		}
		//control
		/*
		 change without total rebuild
			GP.path.setParam() --> change path behavior
			GP.synthPath.timeline.startSpace(prg,trans)

		 just rebuild
		 	GP.restart({path,space})
		*/
		public function restart(p){
			//destroy streams
			synthPath.timeline.destroyAll();
			//reset context
			context.reset();
			//start new Path
			if(p.path!=null) ctrlPath.startPath(p.path);
			else ctrlPath.startPath();
			//start new SpacePrg -> Streams
			if(p.space!=null) synthPath.timeline.startSpace(p.space);
			else synthPath.timeline.startSpace(synthPath.timeline.currPRG);
		}
		public function onEF(e){
			//RESET
			origoResetCC++;
			if(origoResetCC>=origoResetDelay){
				origoResetCC=0;
				sceneToOrigo();
			}
			ctrlPath.onEF(e);
			synthPath.onEF(e);

			//plane.position=me.pos;plane.z+=50;
			
		}
		
		function sceneToOrigo(e=null){
			var shift:Vector3D = new Vector3D(-path.startPos.x,-path.startPos.y,-path.startPos.z);
			trace("SHIFT:"+shift);
			path.coordShift(shift);
			//ctrlPath.sceneToOrigo(shift);
			synthPath.sceneToOrigo(shift);
		}
		
	}
}