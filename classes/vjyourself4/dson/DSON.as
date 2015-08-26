package vjyourself4.dson{
	import flash.utils.getDefinitionByName;
	import vjyourself4.cloud.Cloud;
	
	public class DSON{
		var cont:Object;
		var params:Object;
		public var cloud:Cloud;
		public var context:Object;
		
		function DSON(data:Object,p=null){
			if(p==null)p={};
			if(p.cloud!=null) cloud=p.cloud;
			if(p.context!=null) context=p.context; else context={};
			params=p;
			
			PrgStepper;
			PrgStepperM;
			PrgRandom2D;
			PrgRandomSides;
			PrgCircle2D;
			PrgColorScale;
			PrgCloud;
			PrgFunc;
			PrgRandom;
			if((! (data is Object)) || (data is Number) || (data is String) || (data is Boolean) ){
				cont = new ContStatic(data);
			}else{
				if(data is Array){
					cont = new ContArray(data,params);
				}else{
					cont = new ContObject(data,params);
				}
			}
			
		}
		public function getNext():Object{
			return cont.getNext();
		}
	}
}