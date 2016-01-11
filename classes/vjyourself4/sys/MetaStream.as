package vjyourself4.sys{
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import vjyourself4.rules.RuleAB_C;
	import flash.events.EventDispatcher;
	import vjyourself4.DynamicEvent;

	public class MetaStream{
		
		public var enabled=false;
		public var filter:Object={act:false};
		
		public var events:EventDispatcher = new EventDispatcher();

		
		public var console:Object;
		public var consoleMini:Object;
		
		public var rule:RuleAB_C;
		function MetaStream(){}
		
		public function init(){
			if(filter.act) rule = new RuleAB_C(filter.rule);
			enabled=true;
		}
		
		public function registerConsole(con:Object){
			console=con;
		}
		public function registerConsoleMini(con:Object){
			consoleMini=con;
		}
		
		public function logMeta(meta:Object,ch,msg:String){
			log({_meta:meta},ch,msg);
				
		}
		public function log(obj:Object,level,msg:String){
			//trace("LOg "+msg);
			if(enabled){
					var name:String="?";
					if(obj["_meta"]!=null) name=obj._meta.name;
					else{
						name=getQualifiedClassName(obj);
						if(name.lastIndexOf("::")>=0)name=name.substr(name.lastIndexOf("::")+2);
					}
					events.dispatchEvent(new DynamicEvent("LOG",{n:name,level:level,msg:msg}));
					if(level==6) consoleMini.tf.text=msg;
					var show:Boolean=true;
					if(filter.act) show=rule.getVal(level,name)
					
					if(show){
						var txt=name+"> "+msg;
						trace(txt);
						if(console!=null){
							console.log(txt);
							if(msg.substr(0,7)=="Resize "){
								if(console.hasOwnProperty("tfSide")) console["tfSide"].text=msg.substr(7);
							}
						}
						//if(consoleMini!=null) consoleMini.tf.text=txt;
					}
			}
				
		}
		
		public function logSimple(txt:String){
			trace("simple> "+txt);
					if( console!=null){
						console.log(txt);
						//var logtxt="";for(var i=0;i<topLogNum;i++) logtxt+=topLog[(i+topLogInd+2)%topLogNum].txt+"\n";console.tfConsole.text=logtxt;
					}
					if( consoleMini!=null){
						consoleMini.tf.text=txt;
						//var logtxt="";for(var i=0;i<topLogNum;i++) logtxt+=topLog[(i+topLogInd+2)%topLogNum].txt+"\n";console.tfConsole.text=logtxt;
					}
			
				
		}
	}
}