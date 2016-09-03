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
	import vjyourself4.ctrl.BindSpace;
	import vjyourself4.DynamicEvent;
	
	
	public class PathSpace{
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
		
		//self
		public var cont:ObjectContainer3D;
		
		
		////////////////////////////////////////////////
		/// Timeline params ////////////////////////////
		////////////////////////////////////////////////
		
		public var lengthPosAbs0:Number=0;
		public var lengthPos:Number=0;
		public var streams:Array;
		public var state:String=""; // empty -> running -> decomposing -> empty -> disposed
		//var streamsVisible:Number=0;
		//var streamsVisibleStart:Number=0;

		public var anal:BindSpace;
		var variables:Object = {
			MM_Wave:false,
			MM_Peak:false,
			MM_Beat:false,
			MM_Timeline:false
		}

		public var maxLevel:Number = 4;
		public var level:Number=maxLevel;
		public var objBuildDelay:Number=0;
		public var pipeBuildDelay:Number=0;
		
		function PathSpace(){}
		
		public function init(){
			var mmvar=ns._sys.music.meta.variables;
			variables.MM_Wave = mmvar.Wave;
			variables.MM_Peak = mmvar.Peak;
			variables.MM_Beat = mmvar.Beat;
			variables.MM_Timeline = mmvar.Timeline;

			if(context==null)context={};
			streams = [];
			//timeline = new TimelineSpaces();
			//timeline.synth=this;
		
			ns.context.cont.colA.events.addEventListener(Event.CHANGE,colorsCHANGE,0,0,1);
			ns.context.cont.texA.events.addEventListener(Event.CHANGE,texACHANGE,0,0,1);
			ns.context.cont.texB.events.addEventListener(Event.CHANGE,texBCHANGE,0,0,1);
			
			anal=new BindSpace();
			anal.pathSpace=this;
			anal.init();
			state="empty";
			//onEF();
		}

		public function startSpace(prg,lp=null){
			anal.unBind();
			//trace("StartSpace");
			state="running";
			//trace("path.p0:"+path.p0+" path.p1:"+path.p1);
			//init streams;
			streams=[];
			if(lp!=null) lengthPos=lp;
			else lengthPos=path.p0;
			lengthPosAbs0=lengthPos;
			//currSpacePRG=prg;
			for(var i in prg.streams){
				var okay=true;
				if(prg.streams[i].condition!=null){
					var condi=prg.streams[i].condition;
					for(var ii in condi) okay=okay && (variables[condi[ii].n]==condi[ii].v);
					trace("Condition: "+okay);
				}
				if(okay) createStream(prg.streams[i]);
			}
			if(prg.bind!=null) anal.setBind(prg.bind);
			else anal.setBind(anal.defBind);
		}
		
		/*
		public function updatePathLength(inc){
			timeline.updateLength(inc);
			for(var i=0;i<streams.list.length;i++) streams.list[i].updateLength(inc);
		}*/
		/*
		public function setViewPos(pos){
			for(var i=0;i<streams.list.length;i++) streams.list[i].viewPos=pos;
		}*/
		public function createStream(mStrm:Object){
			
			
			var e={m:mStrm};
			streams.push(e);
			if(mStrm.level!=null) e.level=mStrm.level;
			else e.level=[true];
			e.active=isActive(e.level);

			//for(var i in streams.list) if (streams.list[i].lengthPos>lengthPos) lengthPos=streams.list[i].lengthPos;
			//if(streams.list.length==0) lengthPos=path.p0;
			//lengthPos=path.p1-200;
			//trace("start lengthPos:"+lengthPos);
			
			//var mStrm=prgCode.streams[i];
			if(e.active){
				startStream(e,false);
			}

			return e;
		}
		
		public function isActive(lev):Boolean{
			var show = false;
			if(lev.length<=level) show=lev[lev.length-1];
			else show=lev[level];
			return show;
		}

		public function levelUp(){
			setLevel(level+1);
		}
		public function levelDown(){
			setLevel(level-1);
		}
		public function setLevel(lev:Number,p:Object=null){
			if(p==null) p={progressive:false};

			if(lev<0) lev=0;
			if(lev>maxLevel) lev=maxLevel;
			level=lev;

			
			for(var i=0;i<streams.length;i++){
				if(isActive(streams[i].level)){
					if(!streams[i].active) startStream(streams[i],p.progressive);
				}else{
					if(streams[i].active) stopStream(streams[i]);
				}
				//streams[i].strm.cont.visible=isActive(streams[i].level);
			}
			anal.updateBind();
		}

		function startStream(e,progressive){
			e.active=true;
			var mStrm=e.m;
			var strm;
				switch(mStrm.cn){
					case "StreamObjs":strm= new StreamObjs();strm.buildDelay=objBuildDelay;strm.mmMixer=ns._glob.sys.music.meta.mixer;break;
					case "StreamAni":strm= new StreamAni();strm.buildDelay=objBuildDelay;strm.mmMixer=ns._glob.sys.music.meta.mixer;break;
					
					case "StreamMIDI":strm= new StreamMIDI();strm.sys=ns._sys;break;
					case "StreamPipe":strm= new StreamPipe();strm.buildDelay=pipeBuildDelay;strm.musicMeta=ns._glob.sys.music.meta;break;
					case "StreamShiftBox":strm= new StreamShiftBox();strm.me=me;break;
					case "StreamStatic":strm= new StreamStatic();strm.me=me;break;
					
				}
				for(var ii in mStrm) if((ii!="cn")&&(ii!="active")&&(ii!="condition")&&(ii!="level")) strm[ii]=mStrm[ii];
				
				
				strm.ctrlMovement=ctrlMovement;
				strm.lengthPos=lengthPosAbs0;
				if(lengthPosAbs0<path.p0) strm.lengthPos=path.p0;
				if(progressive) strm.lengthPos=path.p1;
				strm.assemblerObj3D=assemblerObj3D;
				strm.path=path;
				strm.cont=new ObjectContainer3D();
				cont.addChild(strm.cont);
				strm.global=this;
				strm.cloud=cloud;
				strm.contextHandler=context;
				strm.init();
				//streamsVisible=streams.list.length+1;
				//streamsVisibleStart=0;
				e.strm=strm;
		}
		function stopStream(e){
			e.active=false;
			cont.removeChild(e.strm.cont);
			e.strm.cont.dispose();
			e.strm.destroy();
		}
		/*
		public function visibleInc(){
			if(streamsVisible<streams.list.length){
				streamsVisible++;
				streams.list[(streamsVisibleStart+streamsVisible-1)%streams.list.length].cont.visible=true;
				ns._glob.sys.mstream.logSimple("STRM "+(streams.list.length)+" / "+streamsVisible+" +"+streamsVisibleStart);
			}
		}
		public function visibleDec(){
			if(streamsVisible>1){
				streams.list[(streamsVisibleStart+streamsVisible-1)%streams.list.length].cont.visible=false;
				streamsVisible--;
				ns._glob.sys.mstream.logSimple("STRM "+(streams.list.length)+" / "+streamsVisible+" +"+streamsVisibleStart);
			}else{
				streams.list[(streamsVisibleStart+streamsVisible-1)%streams.list.length].cont.visible=false;
				streamsVisibleStart=(streamsVisibleStart+1)%streams.list.length;
				streams.list[(streamsVisibleStart+streamsVisible-1)%streams.list.length].cont.visible=true;
				ns._glob.sys.mstream.logSimple("STRM "+(streams.list.length)+" / "+streamsVisible+" +"+streamsVisibleStart);
			}
		}*/

		public function colorsCHANGE(e){
			for(var i=0;i<streams.length;i++) if(streams[i].active) streams[i].strm.updateColors();
		}
		public function texACHANGE(e){
			for(var i=0;i<streams.length;i++) if(streams[i].active) streams[i].strm.updateTex("A");
		}
		public function texBCHANGE(e){
			trace("TEX B - CHG");
			for(var i=0;i<streams.length;i++) if(streams[i].active) streams[i].strm.updateTex("B");
		}
		
		public function sceneToOrigo(shift){
			for(var i=0;i<streams.length;i++) if(streams[i].active) streams[i].strm.coordShift(shift);
		}
/*
		public function decomposeStream(id){
			var strm=streams.getItem(id);
			if(strm!=null){
				strm.decompose();
			}
		}*/

		public function decomposeStreamAll(){
			
			for(var i=0;i<streams.length;i++){
				if(streams[i].active){
					var strm=streams[i].strm;
					strm.decompose();
				}else{
					destroyStream(i);
				}
			}
			state="decomposing";
		}
		
		public function destroyStream(ind){
			if(streams[ind].active){
				var strm=streams[ind].strm;
				cont.removeChild(strm.cont);
				strm.cont.dispose();
				strm.destroy();
			}
			streams.splice(ind,1);
			if(streams.length==0) state="empty";
		}

		public function destroyStreamAll(){
			anal.unBind();
			while(streams.length>0) destroyStream(0);
			lengthPos=0;
		}
		
		public function restartStreams(){
			//destroyStreamAll();
			lengthPos=0;
			//timeline.mapNextStep();
		}
		public function dispose(){
			anal.unBind();
			ns.context.cont.colA.events.removeEventListener(Event.CHANGE,colorsCHANGE);
			ns.context.cont.texA.events.removeEventListener(Event.CHANGE,texACHANGE);
			ns.context.cont.texB.events.removeEventListener(Event.CHANGE,texBCHANGE);
			destroyStreamAll();
			streams=null;
			params=null;
			assemblerObj3D=null;
			cloud=null;
			path=null;
			context=null;
			ctrlMovement=null;
			cont=null;
			state="disposed";
		}
		
		
		public function onEF(e:DynamicEvent){
			//timeline.onEF(e);
			for(var i=0;i<streams.length;i++){
				if(streams[i].active){
					streams[i].strm.onEF(e);
					if(streams[i].strm.lengthPos>lengthPos)lengthPos=streams[i].strm.lengthPos;
					if(streams[i].strm.state=="Finished"){
						destroyStream(i);
						i--;
					}
				}
			}
			//trace(path.p1+" : "+lengthPos);
		}

		
		
		
		
	}
}