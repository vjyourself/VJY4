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
	import flash.system.System;
	import vjyourself4.three.PathSegment;
	
	import vjyourself4.games.*;
	public class GPMultiPath{
		public var ns:Object;
		public var inputVJY:InputVJYourself;
		public var assemblerObj3D:AssemblerObj3D;
		public var cloud;
		public var me:Me;
		public var params:Object;
		
		public var cont3D:ObjectContainer3D;
		public var ctrlPath:CtrlPath;
		
		public var path:Path;
		public var synthPath:SynthPath;
		public var context:Object;
		public var pathA:Path;
		public var synthPathA:SynthPath;
		public var contextA:Object;
		public var pathB:Path;
		public var synthPathB:SynthPath;
		public var contextB:Object;
		
		var spaces:Array;
		var mapSpaces:Array;
		var themes:Array;
		var currThemesInd:Number;
		var themesIndA:Number;
		var themesIndB:Number;
		var crossingActive:Boolean=false;
		
		var crossingCC:Number=0;
		var crossingDelay:Number=60*20;
		
		function GPMultiPath(){
		}
		
		public function init(){
			inputVJY=ns.inputVJY;
			cloud=ns.cloud;
			assemblerObj3D=ns.assemblerObj3D;
			me=ns.me;
			
			//*****************************************************************************
			//analise cloud -> create maps
			
			spaces=[];
			mapSpaces=[];
			var pathprgs=cloud.RPrg.cont.programs.path;
			for(var i in pathprgs){
				switch(i){
					default:
					spaces.push({name:i,prg:i});
					mapSpaces.push(cloud.RPrg.cont.programs.path[i]);
				}
			}
			
			themes=[];
			for(var i in cloud.C3D.NS){
				switch(i){
					case "multiA":
					case "multiB":
					case "Empty":
					break;
					default:
					trace("THEME: "+i);
					themes.push({code:i});
				}
			}
			//********************************************************************
			
			//3D cont
			cont3D = new ObjectContainer3D();
			
			//Path
			path= new Path();
			path.startPos=new Vector3D();
			path.startRot=new Matrix3D();
			//set up path parameters - not supported yet
			path.continuePath = path["path"+"Random"];
			path.continuePath();
			
			//ctrlPath
			ctrlPath= new CtrlPath();
			ctrlPath.path=path;
			ctrlPath.me=me;
			ctrlPath.inputVJY=inputVJY;
			ctrlPath.onEnd=this.onEnd;
			
			//set up context
			context={};
			currThemesInd=Math.floor(Math.random()*themes.length);
			context.multiA=themes[currThemesInd].code;
			context.multiB=themes[currThemesInd].code;
			
			//synthPath
			synthPath = new SynthPath();
			synthPath.cont=cont3D;
			synthPath.path=path;
			synthPath.context=context;
			synthPath.inputVJY=inputVJY;
			//synthPath.params=params.init;
			synthPath.assemblerObj3D=assemblerObj3D;
			synthPath.cloud=ns.cloud as Cloud;
			
			path.synth=synthPath;
			ctrlPath.init();
			synthPath.init();
			
			synthPath.timeline.startMap(mapSpaces);
			//synthPath.timeline.startSpace(ns.cloud.RPrg.cont.programs.path["PrgMultiRegulator"]);
			if(ns.input.gamepad_enabled){
				ns.input.gamepadManager.events.addEventListener("Gamepad0_A",createCrossing,0,0,1);
				ns.input.gamepadManager.events.addEventListener("Gamepad0_B",sceneToOrigo,0,0,1);
			}
			
		}
		
		public function nextContext(){
			currThemesInd=(currThemesInd+1)%themes.length;
			context.multiA=themes[currThemesInd].code;
			context.multiB=themes[currThemesInd].code;
			return themes[currThemesInd].code;
		}
		public function onEnd(){
			trace("ON END");
			trace("make the big diss");
			var dirA:Vector3D=pathA.getRot(400).transformVector(new Vector3D(0,0,1));
			var dirB:Vector3D=pathB.getRot(400).transformVector(new Vector3D(0,0,1));
			var dir:Vector3D=me.rot.transformVector(new Vector3D(0,0,1));
			dirA.decrementBy(dir);
			dirB.decrementBy(dir);
			
			if(dirA.length<dirB.length){
				trace("TAKE A");
				currThemesInd=themesIndA;
				//destroy B
				synthPathB.destroy();
				synthPathB=null;
				pathB.destroy();
				pathB=null;
				
				//destroy Original
				synthPath.destroy();
				synthPath=null;
				path.destroy();
				path=null;
				
				//make A to main
				ctrlPath.startPath(pathA);
				path=pathA;pathA=null;
				synthPath=synthPathA;synthPathA=null;
			}else{
				trace("TAKE B");
				currThemesInd=themesIndB;
				//destroy A
				synthPathA.destroy();
				synthPathA=null;
				pathA.destroy();
				pathA=null;
				
				//destroy Original
				synthPath.destroy();
				synthPath=null;
				path.destroy();
				path=null;
				
				//make A to main
				ctrlPath.startPath(pathB);
				path=pathB;pathB=null;
				synthPath=synthPathB;synthPathB=null;
			}
			crossingActive=false;
			System.gc();
		}
		public function createCrossing(e=null){
			if(!crossingActive){
				trace("CROSSSSSS SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
			ctrlPath.stopGrowing();
			
			//choose contexts
			do{themesIndA=Math.floor(Math.random()*themes.length);}while(themesIndA==currThemesInd);
			do{themesIndB=Math.floor(Math.random()*themes.length);}while((themesIndB==currThemesInd)||(themesIndB==themesIndA));
			trace("ContextA: "+themes[themesIndA].code);
			trace("ContextB: "+themes[themesIndB].code);
			pathA= new Path();
			pathA.startRot=path.getRot(path.length);
			pathA.startPos=path.getPos(path.length);
			//pathA.startPos.incrementBy( pathA.startRot.transformVector(new Vector3D(300,0,300)) );
			pathA.addSegment(new PathSegment({type:"CurveXZ",alpha:90,length:800}));
			pathA.pathStraight();pathA.pathStraight();pathA.pathStraight();
			pathA.continuePath = pathA["path"+"Random"];
			
			contextA={};
			contextA.multiA=themes[themesIndA].code;
			contextA.multiB=themes[themesIndA].code;
			
			synthPathA = new SynthPath();
			synthPathA.lengthPos=400;
			synthPathA.cont=cont3D;
			synthPathA.path=pathA;
			synthPathA.inputVJY=inputVJY;
			synthPathA.assemblerObj3D=assemblerObj3D;
			synthPathA.cloud=ns.cloud as Cloud;
			synthPathA.context=contextA;
			pathA.synth=synthPathA;
			synthPathA.init();
			synthPathA.timeline.startMap(mapSpaces);
			//synthPathA.timeline.startSpace(ns.cloud.RPrg.cont.programs.path["PrgMultiRegulator"]);
			
			pathB= new Path();
			pathB.startPos=path.getPos(path.length);
			pathB.startRot=path.getRot(path.length);
			pathB.addSegment(new PathSegment({type:"CurveXZ",alpha:-90,length:800}));
			pathB.pathStraight();pathB.pathStraight();pathB.pathStraight();
			pathB.continuePath = pathB["path"+"Random"];
	
			contextB={};
			contextB.multiA=themes[themesIndB].code;
			contextB.multiB=themes[themesIndB].code;
			
			synthPathB = new SynthPath();
			synthPathB.lengthPos=400;
			synthPathB.cont=cont3D;
			synthPathB.path=pathB;
			synthPathB.inputVJY=inputVJY;
			synthPathB.assemblerObj3D=assemblerObj3D;
			synthPathB.cloud=ns.cloud as Cloud;
			synthPathB.context=contextB;
			pathB.synth=synthPathB;
			synthPathB.init();
			synthPathB.timeline.startMap(mapSpaces);
			//synthPathB.timeline.startSpace(ns.cloud.RPrg.cont.programs.path["PrgMultiRegulator"]);
			crossingActive=true;
			}
			
		}
		public function onEF(e){
			
			if(!crossingActive){
				crossingCC++;
				if(crossingCC>=crossingDelay){
					crossingCC=0;
					createCrossing();
				}
			}
			ctrlPath.onEF();
			synthPath.onEF();
			if(synthPathA!=null) synthPathA.onEF();
			if(synthPathB!=null) synthPathB.onEF();
			
		}
		
		function sceneToOrigo(e=null){
			if(!crossingActive){
				var shift:Vector3D = new Vector3D(-path.startPos.x,-path.startPos.y,-path.startPos.z);
				trace("SHIFT:"+shift);
				path.coordShift(shift);
				//ctrlPath.sceneToOrigo(shift);
				synthPath.sceneToOrigo(shift);
			}
		}
		
	}
}