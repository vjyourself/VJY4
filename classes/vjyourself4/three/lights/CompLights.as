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
	
	public class CompLights{
		
		public var ns:Object;
		public var input;
		public var cloud;
		public var path;
		public var me;
		public var context;
		public var cont:Scene3D;

		public var tar:String;
		public var _tar:Object;
		public var stream:String
		public var _patt:Object;

		public var params:Object;
		
		
		var effects:Object;
		var effect:Object;
		var effectName:String="";
		
		public var lp:StaticLightPicker;
		var blackout:Boolean=false;
		var lightsBlackout:Array;
		
		
		public function CompLights(){
			PointDir;DualRot;TriRot;Running;Flashy;
			}
		
		
		public function init(){
			
			cloud=ns.sys.cloud;
			cont=ns.view.scene;
			path = ns.GP.path;
			me = ns.me;
			context= ns.GP.context;
			stream=params.stream;
			tar=params.tar;
			_patt=ns.GP.context.cont["colorStream"+stream];
			_patt.events.addEventListener(Event.CHANGE,colorsCHANGE,0,0,1);
			
			lp = new StaticLightPicker([]);
			if(tar=="cloud.R3D") _tar=cloud.R3D;
			else _tar=ns[tar];
			_tar.applyLightPicker(lp);
			
			/*
			lightsBlackout=[new PointLight()];
			lightsBlackout[0].color=0;
			lightsBlackout[0].ambientColor=0;
			*/
			if(params.init!=null) setLights(params.init);
		}

		public function colorsCHANGE(e){
			if(effect!=null) effect.updateColors();
		}
		public function setLights(name){
			//if(effect!=null) effect.dispose();

			var code=ns.cloud.RLights.NS[name];
			var c=getDefinitionByName("vjyourself4.games.lights."+code[0]) as Class;
			effect=new c();
			effect.ns=this;
			effect.stream=stream;
			effect.presets=ns.cloud.presets.NS.lights[code[0]];
			effect.init();
			effect.setPreset(code[1]);
			updateLpLights();
			
		}
		
		/*
		public function setBlackout(vv){
			trace("Set blackout "+vv);
			if(blackout&&!vv){
				blackout=false;
				updateLpLights();
			}
			if(!blackout&&vv){
				blackout=true;
				lp.lights=lightsBlackout;
			}
		}
		*/

		public function updateLpLights(){
			//if((!blackout)&&(
			if(effect!=null) lp.lights=effect.lights;
		}
		
		public function onEF(e){
			if(effect!=null) effect.onEF();
		}
	}
}

