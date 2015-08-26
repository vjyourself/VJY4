package vjyourself4.three{
	import vjyourself4.three.elem.Sprite;vjyourself4.three.elem.Sprite;
	import vjyourself4.three.elem.SnailStairs;SnailStairs;
	import vjyourself4.three.elem.ObjPlane;ObjPlane;
	import vjyourself4.three.elem.Pipe;Pipe;
	import vjyourself4.three.elem.PipeWire;PipeWire;
	import vjyourself4.three.elem.ObjString;ObjString;
	import vjyourself4.three.elem.Blossom;Blossom;
	import vjyourself4.three.elem.Assembler;
	
	import vjyourself4.three.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import vjyourself2.wave.WaveFollow;
	import flash.utils.getDefinitionByName;
	import flash.geom.Vector3D;
	import flash.geom.Matrix;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import flash.geom.Vector3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	import away3d.primitives.*;
	import away3d.tools.helpers.*;
	import away3d.core.math.Matrix3DUtils;
	import away3d.containers.View3D;
	//import away3d.core.base.Vertex;
	import vjyourself2.primitives.CubeGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.entities.SegmentSet;
	
	import away3d.primitives.LineSegment;
	import away3d.materials.lightpickers.*;
	import away3d.entities.Sprite3D;
	
	
	import away3d.textures.BitmapCubeTexture;
	import away3d.materials.SkyBoxMaterial;
	import away3d.primitives.SkyBox;
	import away3d.primitives.ConeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.core.base.Geometry;
	
	import away3d.filters.BlurFilter3D;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import flash.display.BlendMode;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import vjyourself2.src.SrcInput;
	import vjyourself2.wave.WaveFollow;
	import vjyourself2.media.Music;
	import vjyourself2.cloud.Cloud;

	import away3d.debug.data.TridentLines;
	import vjyourself2.post.PostService;
	import away3d.tools.helpers.*;
	public class CompShiftTunnel{
		
		public static var classMeta={
			
			cn:"vjyourself4.comp.CompCraft",
			name:"CanvasMirror",categories:"Composition",
			desc:"",
			//////////////////////////////////////////////
			params:{
				cn:{t:"Array"},
				dimX:{def:960},
				dimY:{def:540}
			},
			system:{enterframe:{},input:{},musicMeta:{}},
			needs:{},
			//////////////////////////////////////////////
			vis:[{n:"vis",origo:"topleft",cn:"flash.display.Sprite"}],
			viscont:[],
			data:{},
			functions:{},
			events:{}	
		}
		
		public var vis:ObjectContainer3D;
		public var musicMeta:Object;
		public var input:Object;
		
		public var streams:Array;
		public var elems:Array;
		
		public var zMin=-6000;
		public var zMax=6000;
		public var aLength=1000;
		public var aShift=0;
		
		public var items;
		public var iMaterials;
		public var iElems;
		
		var WFSpeed= new WaveFollow({treshold:0});
		var WFRY = new WaveFollow({treshold:0});
		var WFLX = new WaveFollow({treshold:0});
		var WFLY = new WaveFollow({treshold:0});
		var WFPeak = new WaveFollow({treshold:0});
		var mspeed=0;
		
		public function CompShiftTunnel(){}
		
		public function init(){
			vis = new ObjectContainer3D();
			
			
			//create elems
			elems=[];
			for(var i=0;i<streams.length;i++){
				streams[i].pattInd=-1;
				trace(streams[i].pattern);
				elems[i]={};
				elems[i].elemsNum=1;
				elems[i].elemsAInd0=0;
				elems[i].elemsInd0=0;
				elems[i].elemsNum=(zMax-zMin)/aLength;
				elems[i].elems=[];
				
				var se=elems[i];
				var posZ=zMin;
				for(var ii=0;ii<se.elemsNum;ii++){
					var el=createNextElem(i);
					el.vis.z=posZ;
					el.depth=Math.abs(el.vis.z)/zMax;
					posZ+=el.length;
					el.onEF();
					se.elems.push({el:el});
					trace("insert:"+se.elems.length);
					vis.addChild(el.vis);
				}
			}
			
		}
		
		public function createNextElem(sInd){
			//trace(streams[sInd].pattInd);
			//trace(streams[sInd].pattern);
			streams[sInd].pattInd=(streams[sInd].pattInd+1)%streams[sInd].pattern.length;
			return createElem(streams[sInd].pattern[streams[sInd].pattInd],{radius:streams[sInd].radius});
		}
		
		public function createElem(prg:Object,p:Object){
			
			trace("createElem:"+prg);
			var elm=items[prg];
			var c:Class = getDefinitionByName(elm.cn) as Class;
			var el = new c();
			for(var i in elm.p){
				switch(i){
					case "material": el["material"]=iMaterials[elm.p[i]].m;break;
					case "elem": el["elem"]=iElems[elm.p[i]].e;break;
					default: el[i]=elm.p[i];break;
				}
			}
			for(var ii in p) el[ii]=p[ii];
			el.buildUp();
			
			return el;
			//return {vis:cont,length:1000};
		}
		
		function removeElem(sInd,ind){
			var se=elems[sInd];
			vis.removeChild(se.elems[ind].el.vis);
			se.elems[ind].el.dispose();
			se.elems.splice(ind,1);
		}
		function addElem(sInd,ind){
			var se=elems[sInd];
			var el = createNextElem(sInd);
			if(ind==0){
				el.vis.z=se.elems[0].el.vis.z-el.length;
				se.elems.splice(0,0,{el:el});
			}else{
				el.vis.z=se.elems[se.elems.length-1].el.vis.z+se.elems[se.elems.length-1].el.length;
				se.elems.push({el:el});
			}
			el.onEF();
			vis.addChild(el.vis);
		}
		public function onEF(e=null){
			switch(input.def){
				case "gamepad":
				var s0=input.gamepadManager.getState(0);
				WFSpeed.setVal(0.3+s0.RightTrigger*10);WFSpeed.onEF();
				//WFRY.setVal(s0.RightStick.y-0.5);WFRY.onEF();
				//WFLX.setVal(s0.LeftStick.x);WFLX.onEF();
				//WFLY.setVal(s0.LeftStick.y-0.1);WFLY.onEF();
				break;
				case "mobile":
				WFSpeed.setVal(2);WFSpeed.onEF();
				break;
				case "mkb":
				/*
				if(input.mouse.butt==1){
					mspeed+=0.001;
					if(mspeed>0.2) mspeed=0.2;
				}else{
					mspeed-=0.001;
					if(mspeed<-0.02) mspeed=-0.02;
				}
				WFLY.setVal(-mspeed);WFLY.onEF();
				WFRX.setVal(input.mouse.rX/4);WFRX.onEF();
				WFRY.setVal(input.mouse.rY/4);WFRY.onEF();
				*/
				WFSpeed.setVal(1);WFSpeed.onEF();
				break;
			
			}
			//WFPeak.setVal(musicMeta.peak);
			//WFPeak.onEF();
			//WFSpeed.setVal(1+WFPeak.val);
			//setPeak(musicMeta.peak);
			//WFSpeed.val=1;//peak*10;
			//WFSpeed.onEF();
			/*
			var ss=1+musicMeta.peak*2;
			var ringGeom = new RingGeometry(100,200);
			ringGeom.ringInR=80;
			ringGeom.ringInAmp=20;
			ringGeom.ringOutR=100;
			ringGeom.ringOutAmp=0;
			ringGeom.wave=musicMeta.waveData;
				*/
			for(var i=0;i<streams.length;i++){
				var se=elems[i];
				var speed=streams[i].speed;
				var minSpeed=streams[i].minSpeed;
				var incZ=(WFSpeed.val*speed+minSpeed)*5;
				var rot=streams[i].rot;
				for(var ii=0;ii<se.elems.length;ii++){
					var el=se.elems[ii].el;
					el.depth=Math.abs(el.vis.z)/zMax;
					el.vis.z-=incZ;
					el.vis.rotationZ+=rot;
					el.onEF();
				/*
				//Balls
				var visBalls=el.visBalls;
				for(var iii=0;iii<visBalls.length;iii++){
					var wf=visBalls[iii].wf;
					var mesh=visBalls[iii].mesh;
					wf.scaleX=ss;
					wf.scaleY=ss;
					wf.scaleZ=ss;
					mesh.scaleX=ss;
					mesh.scaleY=ss;
					mesh.scaleZ=ss;
				}
				
				//Ring
				el.ring.mesh.geometry=ringGeom;
				*/
				}
			
				var elFirst=se.elems[0].el;
				var elLast=se.elems[se.elems.length-1].el;
				//remove
				if((elFirst.vis.z+elFirst.length)<zMin) removeElem(i,0);
				if(elLast.vis.z>zMax) removeElem(i,se.elems.length-1);
				//add
				if(elFirst.vis.z>zMin) addElem(i,0);
				if(elLast.vis.z+elLast.length<zMax) addElem(i,se.elems.length-1);
				
			}
			/*
			var ww=musicMeta.waveDataDamped;
			
			
			for(var i=0;i<elems.length;i++){
				elems[i].vis.rotationY+=WFRY.val*(1/(i+1)*((i%2)*2-1));
				elems[i].vis.rotationX+=WFRX.val*(1/(i+1)*((i%2)*2-1));
			}
			elemsR0+=WFLY.val*10;
			if(elemsR0<rMin){
				elemsInd0++;
				elemsR0+=rGap;
			}
			if(elemsR0>rMin+rGap){
				elemsInd0=(elemsInd0-1+elems.length)%elems.length;
				elemsR0-=rGap;
			}
			for(var i=0;i<elems.length;i++){
				var el=elems[(elemsInd0+i)%elems.length];
				el.r=elemsR0+i*rGap;
				el.objScale=WFPeak.val;
				el.update();
			}*/
			/*
			switch(input.def){
				case "gamepad":
				var s0=input.gamepadManager.getState(0);
				var stickX=0;
				var stickY=0;
				switch(inputPos){
					case "right":
					stickX=s0.RightStick.x;
					stickY=s0.RightStick.y;
					break;
					case "left":
					stickX=s0.LeftStick.x;
					stickY=s0.LeftStick.y;
					break;
				}*/
		}
		
		var peak=0;
		function setPeak(val){
			if(val>peak)peak=val;
			peak*=0.95;
		}
	}
}