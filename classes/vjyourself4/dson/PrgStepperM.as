package vjyourself4.dson{
	
	public class PrgStepperM{
		var stepper:Object;
		var prgName:String;
		function PrgStepperM(p:Array){
			stepper= new PrgStepper(p);
			prgName=p[0][0];
			
		}
		public function getNext(obj:Object){
			var mobj={};
			stepper.getNext(mobj);
			var retobj=mobj[prgName];
			for(var i in retobj) obj[i]=retobj[i];
		}
	}
}