package vjyourself4.dson{
	import flash.utils.getDefinitionByName;
	import vjyourself4.cloud.Cloud;

	public class ContArray{
		public var subPrgs:Array;
		public var level:Number=0;
		public var name:String="";
		
		var statics:Array;
		var conts:Array;
		var prgs:Array;
		
		public var cloud:Cloud;
		public var context:Object;
		var params:Object;
		
		function ContArray(data:Object,p=null){
			if(p==null) p={};params=p;
			if(p.cloud!=null) cloud=p.cloud;
			if(p.context!=null) context=p.context; else context={};
			
			statics=[];
			conts=[];
			prgs=[];
			
			for(var i=0;i<data.length;i++){
				var row=data[i];
				
				//Object or Array
				if((row is Object) && (!(row is String)) && (!(row is Number)) && (!(row is Boolean)) ){
					//Array
					if(row is Array){
						
						//Static Array - first parameter empty []
						var staticArray =false;
						if(row[0] is Array) if(row[0].length==0) staticArray=true;
						if(staticArray){
							statics.push({ind:i,val:row[1]});
						}else{
							var prgName;
							var prgParams=[];
							if (row[0] is Array){
								prgName=row[1];
								prgParams=row;
							}else{
								prgName=row[0];
								prgParams.push(["val"]);
								for(var ii=0;ii<row.length;ii++) prgParams.push(row[ii]);
							}
							//Array Container Program
							if(prgName=="Array"){
								conts.push({ind:i,cont:new ContArray(row[1],params)});
							}else{
								prgName="Prg"+prgName;
								var prgClass:Class = getDefinitionByName("vjyourself4.dson."+prgName) as Class;
								var prg;
								switch(prgName){
									case "PrgStepper":prg = new prgClass(prgParams,params);break;
									case "PrgCloud":prg = new prgClass(prgParams);prg.cloud=cloud;prg.context=context;prg.init();break;
									default:prg = new prgClass(prgParams);
								}
								prgs.push({ind:i,prg:prg});
							}
						}
					//Object
					}else{
						var oc= new ContObject(row,params);
						conts.push({ind:i,cont:oc});
					}
				//Static
				}else{
					statics.push({ind:i,val:row});
				}
			}
		}
		
		public function getNext(o:Object=null):Object{
			//trace("> get next");
			var obj=[];
			//Static
			for(var i in statics) obj[statics[i].ind]=statics[i].val;
			//Containers
			for(var i in conts) obj[conts[i].ind]=conts[i].cont.getNext();
			//Programs
			for(var i=0;i<prgs.length;i++){
				var retobj={};prgs[i].prg.getNext(retobj);
				obj[prgs[i].ind]=retobj.val;
			}
			return obj;
		}
		
	}
}