package vjyourself4.comp{
	import away3d.containers.ObjectContainer3D;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import vjyourself4.dson.TransJson;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.dson.ParamsManager;

	public class CompManager{
		public var _debug:Object;
		public var _meta:Object={name:"Comps"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var cs:Object;
		public var params:Object;
		public var cont3D:ObjectContainer3D;
		public var vis:Sprite;

		var modules:Array;
		var modulesEF:Array;
		var modulesResize:Array;
		
		public var state:String="";
		public var anal:Array=[];

		var i:int=0;

		public var compPreset:String="";
		public var compParams:ParamsManager;

		public function CompManager(){
			
		}

		public function init(){
			compParams = new ParamsManager();
			compParams.events.addEventListener("CHANGE",onParams,0,0,1);
			cont3D = new ObjectContainer3D();
			vis = new Sprite();
			modules=[];
			modulesEF=[];
			modulesResize=[];
			cs={vis:vis,cont3D:cont3D,me:ns.me};
			cs._glob=ns;
			cs._sys=ns._sys;
		}

		public function build(p){
			if(compPreset!=p.preset){
				decompose();
				compParams.clear();
				var preset=ns._sys.cloud.presets.NS.comp[p.preset];
				compPreset=p.preset;
				compParams.setDesc(preset.paramsDesc);
				compParams.setParams(preset.paramsDef);
				compParams.setParams(p.params);
				

				var es=preset.elems;
				var p:Object;
				for(var i=0;i<es.length;i++){
				var m=es[i];
				log(2,m.n+" :: "+m.cn);
				var c:Class = getDefinitionByName(m.cn) as Class;
				var o = new c();
				cs[m.n]=o;
				//o.ns=ns;
				//o.cns=ns;
				p=TransJson.clone(m);
				if(compParams.params[m.n]!=null) TransJson.over(p,compParams.params[m.n]);
				o.ns=cs;
				o.params=p;
				o._debug=_debug;
				o._meta.name=m.n;
				o._meta.cn=m.cn;
				modules.push({obj:o,meta:m});
				if(o.hasOwnProperty("onEF")) modulesEF.push(o);
				if(o.hasOwnProperty("onResize")) modulesResize.push(o);
				}
				for(var i=0;i<modules.length;i++){
				log(2,"init "+modules[i].meta.n);
				modules[i].obj.init();
				if(modules[i].obj.hasOwnProperty("cont3D")) this.cont3D.addChild(modules[i].obj.cont3D);
				if(modules[i].obj.hasOwnProperty("vis")) this.vis.addChild(modules[i].obj.vis);
				}
				state="built";
				log(1,"Built");
				}else{
					compParams.setParams(p.params);
					

				}
		}

		function onParams(e:DynamicEvent){
			if(state=="built"){
				var pp=e.data.changed;
				for(var i in pp){
					cs[i].setParams(pp[i]);
				}
			}
		}
		public function onEF(e){
			for(var i=0;i<modulesEF.length;i++)modulesEF[i].onEF(e);
		}
	
		public function onResize(e=null){
			for(var i=0;i<modulesResize.length;i++)modulesResize[i].onResize(e);
		}
		
		public function setInput(ch,val){
			anal[ch]=val;
			
		}
		public function setParam(path,val){
			var tar=Eval.evalString2(cs,path);
			var p={};
			p[tar.prop]=val;
			tar.obj.setParams(p);
			//events.dispatchEvent(Event.CHANGE,new DynamicEvent());
		}
		public function setParams(p){

		}
		public function decompose(){
			while(modulesEF.length>0) modulesEF.pop();
			while(modulesResize.length>0) modulesResize.pop();
			var mm:Object;
			while(modules.length>0){
				mm=modules.pop();
				delete(cs[mm.meta.n]);
				if(mm.obj.hasOwnProperty("cont3D")) this.cont3D.scene.removeChild(mm.obj.cont3D);
				if(mm.obj.hasOwnProperty("vis")) this.vis.removeChild(mm.obj.vis);
				mm.obj.dispose();
				mm.obj.ns=null;
				mm.obj.params=null;
				mm.obj._debug=null;
				mm.obj=null;mm.meta=null;
			}
			state="";
			log(1,"Decomposed");
		}
		public function dispose(){
			decompose();
			cs.vis=null;
			cs.cont3D=null;
			log(1,"Disposed");
		}
			
	}
}