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
	import vjyourself4.input.InputVJYourself;
	import vjyourself4.three.assembler.AssemblerObj3D;
	import vjyourself4.cloud.Resources3D;
	import vjyourself4.cloud.Cloud;
	import vjyourself4.games.TimelineSpaces;
	import vjyourself4.games.CtrlPath;
	import vjyourself4.IdSet;
	import vjyourself4.ctrl.BindSpace;
	
	
	public class SynthPath{
		//in
		public var params:Object;
		public var assemblerObj3D:AssemblerObj3D;
		public var cloud:Cloud;
		public var path:Path;
		public var ctrlPath:CtrlPath;
		public var context:Object;
		public var inputVJY;
		public var me:Me;
		public var ns:Object;
		
		//self
		public var cont:ObjectContainer3D;
		
		
		////////////////////////////////////////////////
		/// Timeline params ////////////////////////////
		////////////////////////////////////////////////
		public var timeline:TimelineSpaces;
		public var lengthPos:Number=0;
		public var streams:IdSet;
		var streamsVisible:Number=0;
		var streamsVisibleStart:Number=0;

		public var anal:BindSpace;
		
		function SynthPath(){}
		
		public function init(){
			if(context==null)context={};
			streams = new IdSet();
			timeline = new TimelineSpaces();
			timeline.synth=this;
		
			ns.context.cont.colA.events.addEventListener(Event.CHANGE,colorsCHANGE,0,0,1);
			ns.context.cont.texA.events.addEventListener(Event.CHANGE,texACHANGE,0,0,1);
			
			anal=new BindSpace();
			anal.synthPath=this;
			anal.init();
			onEF();
		}

		public function colorsCHANGE(e){
			for(var i=0;i<streams.list.length;i++) streams.list[i].updateColors();
		}
		public function texACHANGE(e){
			for(var i=0;i<streams.list.length;i++) streams.list[i].updateTex("A");
		}
		
		public function sceneToOrigo(shift){
			for(var i=0;i<streams.list.length;i++) streams.list[i].coordShift(shift);
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
		public function startStream(mStrm:Object){
			trace("SynthPath Start Stream");
			trace("path.p0:"+path.p0+" path.p1:"+path.p1);
			//init streams;
			lengthPos=path.p0;
			for(var i in streams.list) if (streams.list[i].lengthPos>lengthPos) lengthPos=streams.list[i].lengthPos;
			if(streams.list.length==0) lengthPos=path.p0;
			//lengthPos=path.p1-200;
			trace("start lengthPos:"+lengthPos);
			
			//var mStrm=prgCode.streams[i];
			var strm;
			switch(mStrm.cn){
				case "StreamObjs":strm= new StreamObjs();break;
				case "StreamMIDI":strm= new StreamMIDI();strm.sys=ns._sys;break;
				case "StreamPipe":strm= new StreamPipe();strm.musicMeta=ns._glob.sys.music.meta;break;
				case "StreamShiftBox":strm= new StreamShiftBox();strm.me=me;break;
				case "StreamStatic":strm= new StreamStatic();strm.me=me;break;
				
			}
			for(var ii in mStrm) if((ii!="cn")&&(ii!="active")) strm[ii]=mStrm[ii];
			strm.inputVJY=inputVJY;
			strm.lengthPos=lengthPos;
			strm.assemblerObj3D=assemblerObj3D;
			strm.path=path;
			strm.cont=new ObjectContainer3D();
			cont.addChild(strm.cont);
			strm.global=this;
			strm.cloud=cloud;
			strm.contextHandler=context;
			strm.init();
			streamsVisible=streams.list.length+1;
			streamsVisibleStart=0;
			return streams.addItem(strm);
		}
		
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
		}
		public function decomposeStream(id){
			var strm=streams.getItem(id);
			if(strm!=null){
				strm.decompose();
			}
		}
		public function decomposeStreamAll(){
			anal.unBind();
			for(var i=0;i<streams.list.length;i++){
				var strm=streams.list[i];
				strm.decompose();
			}
		}
		
		public function destroyStream(id){
			var strm=streams.removeItem(id);
			if(strm!=null){
				var scont=strm.cont;
				strm.destroy();
				cont.removeChild(scont);
				scont.dispose();
				
			}
		}
		public function destroyStreamAll(){
			anal.unBind();
			for(var i=0;i<streams.list.length;i++){
				var scont=streams.list[i].cont;
				streams.list[i].destroy();
				cont.removeChild(scont);
				scont.dispose();
			}
			streams.empty();
			lengthPos=0;
		}
		
		public function restartStreams(){
			//destroyStreamAll();
			lengthPos=0;
			//timeline.mapNextStep();
		}
		public function dispose(){
			ns._glob.context.cont.colorStreamLights.events.removeEventListener(Event.CHANGE,colorsCHANGE);
			ns._glob.context.cont.textureStreamA.events.removeEventListener(Event.CHANGE,texACHANGE);
			
			destroyStreamAll();
			streams.destroy();
			params=null;
			assemblerObj3D=null;
			cloud=null;
			path=null;
			context=null;
			inputVJY=null;
			cont=null;
		}
		
		
		public function onEF(e=null){
			timeline.onEF(e);
			for(var i=0;i<streams.list.length;i++){
				streams.list[i].onEF(e);
				if(streams.list[i].state=="Finished"){
					cont.removeChild(streams.list[i].cont);
					streams.list[i].cont.dispose();
					streams.removeItemRef(streams.list[i]);
					i--;
				}
			}
		}
		
		
	}
}