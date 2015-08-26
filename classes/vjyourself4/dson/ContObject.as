package vjyourself4.dson{
	import flash.utils.getDefinitionByName;
//	import vjyourself2.cont.ContArray;
	import vjyourself4.cloud.Cloud;

	public class ContObject{
		public var subPrgs:Array;
		public var level:Number=0;
		public var name:String="";
		
		var statics:Object;
		var conts:Object;
		var prgs:Array;
		
		public var cloud:Cloud;
		public var context:Object;
		var params:Object;
		
		function ContObject(data:Object,p=null){
			if(p==null) p={};params=p;
			if(p.cloud!=null) cloud=p.cloud;
			if(p.context!=null) context=p.context; else context={};
			
			statics={};
			conts={};
			prgs=[];
			for(var i in data){
				var prop=data[i];
				
				//Object or Array
				if((prop is Object)&& (!(prop is String)) && ( !(prop is Number)) && (!(prop is Boolean)) ){
					//Array
					if(prop is Array){
						
						//Static Array - first parameter empty []
						var staticArray =false;
						if(prop[0] is Array) if(prop[0].length==0) staticArray=true;
						if(staticArray){
							statics[i]=prop[1];
						}else{
							var prgName;
							var prgParams=[];
							if (prop[0] is Array){
								prgName=prop[1];
								prgParams=prop;
							}else{
								prgName=prop[0];
								prgParams.push([i]);
								for(var ii=0;ii<prop.length;ii++) prgParams.push(prop[ii]);
							}
							//Array Container Program
							if(prgName=="Array"){
								conts[i]=new ContArray(prop[1],params);
							}else{
								prgName="Prg"+prgName;
								var prgClass:Class = getDefinitionByName("vjyourself4.dson."+prgName) as Class;
								var prg;
								switch(prgName){
									case "PrgStepper":prg = new prgClass(prgParams,params);break;
									case "PrgCloud":prg = new prgClass(prgParams);prg.cloud=cloud;prg.context=context;prg.init();break;
									default:prg = new prgClass(prgParams);
								}
								prgs.push(prg);
							}
						}
					//Object
					}else{
						var oc= new ContObject(prop,params);
						conts[i]=oc;
					}
				//Static
				}else{
					statics[i]=prop;
				}
			}
		}
		
		public function getNext(o:Object=null):Object{
			//trace("> get next");
			var obj={};
			//Static
			for(var i in statics) obj[i]=statics[i];
			//Object Containers
			for(var i in conts) obj[i]=conts[i].getNext();
			//Programs
			for(var i=0;i<prgs.length;i++) prgs[i].getNext(obj);
			return obj;
		}
		
	}
}