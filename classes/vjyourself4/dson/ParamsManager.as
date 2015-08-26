package vjyourself4.dson{
	import vjyourself4.dson.TransJson;
	import vjyourself4.DynamicEvent;
	import flash.events.EventDispatcher;

	public class ParamsManager{
		public var events:EventDispatcher=new EventDispatcher();

		public var desc:Object;
		public var params:Object;

		function ParamsManager(){
		}
		public function setDesc(o){
			desc=TransJson.clone(o);
			processDesc(params,desc);
		}
		function processDesc(ns,desc){
			for(var i in desc){
				if(i is String){ switch(i){
					case "Boolean":ns[i]=false;break;
					case "Number":ns[i]=0;break;
					case "Int":ns[i]=0;break;
					case "String":ns[i]="";break;
					default:ns[i]="";
					}
				}else {
						if(ns[i]==null)ns[i]={};
						processDesc(ns[i],desc[i]);
					}
			}
		}
		public function setParams(p){
			TransJson.over(params,p);
			events.dispatchEvent(new DynamicEvent("CHANGE",{changed:p}));
		}
		public function setParam(path:String,val){
			var objs=path.split(".");
			var p={};var pp=p;
			for(var i=0;i<objs.length-1;i++){
				p[objs[i]]={};p=p[objs[i]];
			}
			p[objs[objs.length-1]]=val;

			setParams(pp);
		}
		public function getParam(path){
			return Eval.evalString(params,path);
		}
		public function getDesc(path){
			return Eval.evalString(desc,path);
		}
		public function clear(){
			desc={};
			params={};
		}

		
	}
}