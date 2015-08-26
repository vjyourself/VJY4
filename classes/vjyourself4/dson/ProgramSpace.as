package vjyourself4.prgs{
	import flash.utils.getDefinitionByName;
	public class ProgramSpace{
		public var subPrgs:Array;
		function ProgramSpace(p:Array){
			PrgStepper;
			PrgRandom2D;
			PrgCircle2D;
			subPrgs = new Array();
			for(var i=0;i<p.length;i++){
				var pp=p[i];
				if(pp is Array){
					if(pp[1] is Array) pp.splice(1,0,"Stepper");
					var prgName=pp[1];
					var prgClass:Class = getDefinitionByName("vjyourself4.prgs.Prg"+prgName) as Class;
					var prg = new prgClass(pp);
					subPrgs.push(prg);
				}else{
					var prg = new PrgStatic(pp);
					subPrgs.push(prg);
				}
			}
			
		}
		public function getNext():Object{
			var obj={};
			for(var i=0;i<subPrgs.length;i++) subPrgs[i].getNext(obj);
			return obj;
		}
	}
}