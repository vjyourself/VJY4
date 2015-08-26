package vjyourself4.cloud{
	import vjyourself4.dson.Eval;
	public class ReloadCloud{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;

		var GP:String="mid.cs.GP";
		var state:String="";
		public function ReloadCloud(){

		}
		public function init(){
			ns.sys.cloud.events.addEventListener("PACKAGE_COMPLETE",onPackageComplete);
		}
		public function reloadCurrSpace(){
			log(1,"reloadCurrSpace");
			
			state="CurrSpace";
			ns.sys.cloud.loadPackage({src:{includes:ns.cloud["spacesP"]}});
		}

		public function onPackageComplete(e){
			switch(state){
				case "CurrSpace":
				log(1,"Spaces Reloaded");
				var _GP = Eval.evalPath(ns,GP);
				_GP.setParams({restart:true});
				//ns.GP.synthPath.timeline.restartSpace();
				//var prg=ns.cloud.RPrg.cont.programs.path[ns.scene.state.space];
				//ns.GP.synthPath.timeline.startSpace(prg);
				break;
			}
			state="";
		}
	}
}