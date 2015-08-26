package vjyourself4.comp{
	import away3d.containers.ObjectContainer3D;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;

	public class CompManager{
		public var _debug:Object;
		public var _meta:Object={name:"Comps"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var cont3D:ObjectContainer3D;
		public var vis:Sprite;

		var modules:Array;
		var modulesEF:Array;
		var modulesResize:Array;
		


		public function CompManager(){
			
		}

		public function init(){
			cont3D = new ObjectContainer3D();
			vis = new Sprite();
		}

		public function start(p){
			var es=p.elems;

			modules=[];
			modulesEF=[];
			modulesResize=[];
			for(var i=0;i<es.length;i++){
				var m=es[i];
				log(2,m.name+" :: "+m.cn);
				var c:Class = getDefinitionByName(m.cn) as Class;
				var o = new c();
				ns[m.name]=o;
				//o.ns=ns;
				//o.cns=ns;
				o.ns=ns;
				o.params=m;
				o._debug=_debug;
				o._meta.name=m.name;
				o._meta.cn=m.cn;
				modules.push({obj:o,meta:m});
				if(o.hasOwnProperty("onEF")) modulesEF.push(o);
				if(o.hasOwnProperty("onResize")) modulesResize.push(o);
			}
			for(var i=0;i<modules.length;i++){
				log(2,"init "+modules[i].meta.name);
				modules[i].obj.init();
				if(modules[i].obj.hasOwnProperty("cont3D")) this.cont3D.scene.addChild(modules[i].obj.cont3D);
				if(modules[i].obj.hasOwnProperty("vis")) this.vis.addChild(modules[i].obj.vis);
			}
			
		}

		public function onEF(e){
			for(var i=0;i<modulesEF.length;i++)modulesEF[i].onEF(e);
		}
	
		public function onResize(e=null){
			for(var i=0;i<modulesResize.length;i++)modulesResize[i].onResize(e);
		}
		
		
		public function dispose(){
			log(1,"Disposed");
		}
			
	}
}