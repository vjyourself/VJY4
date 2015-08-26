package vjyourself4.cloud{
	import vjyourself4.dson.Eval;
	import com.adobe.serialization.json.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	public class DynoScene{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;


		var state:String="";
		var urlloader:URLLoader;
		
		public function DynoScene(){

		}
		public function init(){
			urlloader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE,dataSaved,0,0,1);
			//ns.sys.cloud.events.addEventListener("PACKAGE_COMPLETE",onPackageComplete);
		}

		public function saveToHeap(){
			var sceneDef=ns.scene.getDef();
			var path=ns.sys.proj.id;

			var url=ns.sys.cloud.baseURL+"scenes/save.php?heap=true&path="+path;
			var data=JSON.stringify(sceneDef,null,3);
			
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var jpgURLRequest:URLRequest = new URLRequest(url);
			jpgURLRequest.requestHeaders.push(header);
			jpgURLRequest.method = URLRequestMethod.POST;
			jpgURLRequest.data = data;
			log(1,"Save Scene > sending post request:"+url);
			urlloader.load(jpgURLRequest);
		}
		
		public function dataSaved(e){
			log(1,"Data Saved > "+urlloader.data);
		}

		public function reloadCurrScene(){
			log(1,"reloadCurrScene");
			
	//		state="CurrSpace";
//			ns.sys.cloud.loadPackage({src:{includes:ns.cloud["spacesP"]}});
		}

		public function onPackageComplete(e){
			/*switch(state){
				case "CurrSpace":
				log(1,"Spaces Reloaded");
				var _GP = Eval.evalPath(ns,GP);
				_GP.setParams({restart:true});
				//ns.GP.synthPath.timeline.restartSpace();
				//var prg=ns.cloud.RPrg.cont.programs.path[ns.scene.state.space];
				//ns.GP.synthPath.timeline.startSpace(prg);
				break;
			}*/
			state="";
		}
	}
}