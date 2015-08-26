package vjyourself4.games.GP{
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
	import vjyourself4.games.ContextHandler;
	
	import vjyourself4.games.*;
	public class GPSinglePath{
		public var ns:Object;
		public var inputVJY:InputVJYourself;
		public var assemblerObj3D:AssemblerObj3D;
		public var me:Me;
		public var params:Object;
		
		public var cont3D:ObjectContainer3D;
		public var path:Path;
		public var ctrlPath:CtrlPath;
		public var synthPath:SynthPath;
		public var context:ContextHandler;
		
		var origoResetCC=0;
		var origoResetDelay=60*10;
		
		function GPSinglePath(){
		}
		
		public function init(){
			inputVJY=ns.inputVJY;
			assemblerObj3D=ns.assemblerObj3D;
			me=ns.me;
			
			//3D cont
			cont3D = new ObjectContainer3D();
			
			//Path
			path= new Path();
			path.startPos=new Vector3D();
			path.startRot=new Matrix3D();
			//set up path parameters - not supported yet
			if(params.path!=null) path.setParams({type:params.path.type,ll:params.path.baseLength});
			else path.setParams({type:"Random",ll:300});
			
			path.continuePath();
			
			//ctrlPath
			ctrlPath= new CtrlPath();
			ctrlPath.path=path;
			ctrlPath.me=me;
			ctrlPath.inputVJY=inputVJY;
			
			context = new ContextHandler();
			context.cloud=ns.cloud;
			context.screen=ns.screen;
			context.params=params.context;
			context.init();
			
			//synthPath
			synthPath = new SynthPath();
			synthPath.cont=cont3D;
			synthPath.path=path;
			synthPath.inputVJY=inputVJY;
			synthPath.context=context;
			synthPath.me=me;
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
		
		public function onEF(e){
			//RESET
			origoResetCC++;
			if(origoResetCC>=origoResetDelay){
				origoResetCC=0;
				sceneToOrigo();
			}
			ctrlPath.onEF();
			synthPath.onEF();
			
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