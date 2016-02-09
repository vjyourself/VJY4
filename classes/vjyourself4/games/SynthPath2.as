package vjyourself4.games{

	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.display.BlendMode;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.geom.ColorTransform;
		
	import away3d.containers.ObjectContainer3D;
	import away3d.cameras.Camera3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.TorusGeometry;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.primitives.CylinderGeometry;
	import away3d.tools.helpers.MeshHelper;
	
	//lighting & shadows
	import away3d.materials.lightpickers.*;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.materials.methods.TripleFilteredShadowMapMethod;
	
	import vjyourself4.patt.WaveFollow;
	import vjyourself4.three.*;
	//import vjyourself4.prgs.*;
	
	import vjyourself4.three.vef.*;
	//import vjyourself4.games.ways.streams.*;
	//import vjyourself4.games.ways.programs.*;
	import vjyourself4.streams.*;
	import vjyourself4.ctrl.CtrlMovement;
	import vjyourself4.three.assembler.AssemblerObj3D;
	import vjyourself4.cloud.Resources3D;
	import vjyourself4.cloud.Cloud;
	import vjyourself4.games.TimelineSpaces;
	import vjyourself4.games.CtrlPath;
	import vjyourself4.IdSet;
	import vjyourself4.ctrl.*;
	import vjyourself4.DynamicEvent;
	
	
	public class SynthPath2{
		public var _debug:Object;
		public var _meta:Object={name:"SynthPath"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		//in
		public var params:Object;
		public var assemblerObj3D:AssemblerObj3D;
		public var cloud:Cloud;
		public var path:Path;
		public var ctrlPath:CtrlPath;
		public var context:Object;
		public var ctrlMovement;
		public var me:Me;
		public var ns:Object;
		public var mixMode:String = "cut";
		
		//self
		var spaces:Array=[];
		public var cont:ObjectContainer3D;
		public var anal:BindAnalPipes;

		public var maxLevel:Number = 4;
		public var level:Number=maxLevel;
		public var objBuildDelay:Number=1;
		public var pipeBuildDelay:Number=1;
		
		function SynthPath2(){}
		
		public function init(){
			if(context==null)context={};
			
			anal=new BindAnalPipes();
			anal.init();

			spaces=[];
		}

		//START A NEW PathSpace
		//p:{n:"name",prgN:"program name"}
		public function start(p:Object){
			var lev = level;
			if(p.level!=null) lev=p.level;
			stopGrow("all");

			var lp=path.p0;
			if(spaces.length>0) lp=path.p1; //spaces[spaces.length-1].space.lengthPos;

			var e={};spaces.push(e);
			e.prgN=p.prgN;
			e.n=p.prgN;if(p.n!=null) e.n=p.n;
			log(1,"START Space "+e.n);
			e.space = new PathSpace();
			e.space.pipeBuildDelay=pipeBuildDelay;
			e.space.objBuildDelay=objBuildDelay;
			e.space.level=lev;
			e.space.maxLevel=maxLevel;
			e.space.context=context;
			e.space.assemblerObj3D=assemblerObj3D;
			e.space.cloud=cloud;
			e.space.path=path
			e.space.ctrlMovement=ctrlMovement;
			e.space.ns=ns;
			e.space.cont=cont;
			e.space.init();
			
			e.space.startSpace(ns._sys.cloud.RPrg.cont.programs.path[p.prgN],lp);
			anal.tars.push(e.space.anal);
		}
		public function levelUp(){
			for(var i in spaces) spaces[i].space.levelUp();
			if(spaces.length>0) level = spaces[spaces.length-1].space.level;
		}
		public function levelDown(){
			for(var i in spaces) spaces[i].space.levelDown();
			if(spaces.length>0) level = spaces[spaces.length-1].space.level;
		}
		public function setLevel(lev:Number,p:Object=null){
			for(var i in spaces) spaces[i].space.setLevel(lev,p);
			if(spaces.length>0) level = spaces[spaces.length-1].space.level;
		}
		public function setLastLevel(lev:Number,p:Object=null){
			trace("setLastLevel !!");
			if(spaces.length>0) spaces[spaces.length-1].space.setLevel(lev,p);
			if(spaces.length>0) level = spaces[spaces.length-1].space.level;
		}
		//Stop A Space to grow (will be destroyed if empted out)
		//Stop grow, then listen when fully decomoposed, then remove
		public function stopGrow(selector:String){
			
			switch(selector){
				case "all":
				for(var i=0;i<spaces.length;i++){
					log(1,"STOP GROW "+spaces[i].n);
					spaces[i].space.decomposeStreamAll();
				}
				break;
			}
		}

		public function onEF(e:DynamicEvent){
			for(var i=0;i<spaces.length;i++) {
				spaces[i].space.onEF(e);
				//if a space totally run out::
				if(spaces[i].space.state=="empty"){
					log(1,"Empty "+spaces[i].n);
					destroySpaceInd(i);
					i--;
				}
			}
		}

		//Totaly Destroy a Space instantly
		public function destroy(selector:String){
			switch(selector){
				case "all":
				while(spaces.length>0) destroySpaceInd(0);
				break;
			}
		}

		public function destroySpaceInd(ind){
			log(1,"DESTROY "+spaces[ind].n);
			var fi=-1;
			for(var ii=0;ii<anal.tars.length;ii++) if(anal.tars[ii]==spaces[ind].space.anal) fi=ii;
			anal.tars.splice(fi,1);
			spaces[ind].space.dispose();
			spaces[ind].space=null;
			spaces.splice(ind,1);
		}

		public function sceneToOrigo(shift){
			//for(var i=0;i<streams.list.length;i++) streams.list[i].coordShift(shift);
		}
		
		public function dispose(){
			destroy("all");
			params=null;
			assemblerObj3D=null;
			cloud=null;
			path=null;
			context=null;
			ctrlMovement=null;
			cont=null;
		}
		
	}
}