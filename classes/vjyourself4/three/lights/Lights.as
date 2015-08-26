package vjyourself4.three.lights{
	import flash.geom.Matrix3D;
	import away3d.cameras.Camera3D;
	import away3d.materials.lightpickers.*;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.containers.Scene3D;
	import flash.geom.Vector3D;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import vjyourself4.dson.Eval;
	
	public class Lights{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;

		public var cloud;
		public var path;
		
		public var context;
		public var me;
		public var cont:Scene3D;

		
		
		
		var effects:Object;
		var effect:Object;
		var effectName:String="";
		var global:Boolean=false;
		
		public var lp:StaticLightPicker;
		var blackout:Boolean=false;
		var lightsBlackout:Array;

		var mode:String="";
		
		var tmp:TriDir;

		var colorStream;
		public function Lights(){
			PointDir;DualRot;TriRot;Running;Flashy;TriDir;
		}
		
		
		public function init(){
			
			cloud=ns._sys.cloud;
			context=ns.context;
			me=ns.me;
			
			if(params.global!=null) global=params.global;
			if(params.mode!=null) mode=params.mode;
			if(params.path!=null) path = Eval.evalString(ns,params.path);
			//me = ns.me;
			colorStream = context.cs["col"+params.colorStream];

			colorStream.events.addEventListener(Event.CHANGE,colorsCHANGE,0,0,1);
			
			effects={};
			var ll=cloud.presets.NS.lights;
			var lll;
			var lllc:Class;
			for(var i in ll){
				lllc=getDefinitionByName("vjyourself4.three.lights."+i) as Class;
				lll=new lllc();
				lll.stream=params.colorStream;
				lll.ns=this;
				lll.presets=ll[i];
				lll.init();
				effects[i]=lll;
			}
			
			lp = new StaticLightPicker([]);
			if(global) ns._sys.cloud.R3D.applyLightPicker(lp);
			
			lightsBlackout=[new PointLight()];
			lightsBlackout[0].color=0;
			lightsBlackout[0].ambientColor=0;
			
			
			setMode(mode);
			//setLights("TriRot","Norm");
		}

		public function setParams(p){
			if(p.mode!=null) setMode(p.mode);
		}
		public function colorsCHANGE(e){
			if(effect!=null) effect.updateColors();
		}
		public function setMode(name){
			var ll=ns._sys.cloud.RLights.NS[name];
			setLights(ll[0],ll[1]);
		}
		public function setLights(eff,effPres){
			//trace("SETLIGHTS> "+eff+effPres);
			effectName=eff;
			effect=effects[effectName];
			updateLpLights();
			effect.setPreset(effPres);
		}
		
		public function setBlackout(vv){
		//	trace("Set blackout "+vv);
			if(blackout&&!vv){
				blackout=false;
				updateLpLights();
			}
			if(!blackout&&vv){
				blackout=true;
				lp.lights=lightsBlackout;
			}
		}
		public function updateLpLights(){if((!blackout)&&(effect!=null)) lp.lights=effect.lights;}
		
		public function onEF(e){
			if(effect!=null) effect.onEF();
		}
	}
}

