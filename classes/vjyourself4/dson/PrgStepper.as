package vjyourself4.dson{
	
	public class PrgStepper{
		public var name:String="";
		public var items:Array;
		
		//params - states
		public var ind:Number=0;
		public var delay:Number=1;
		public var cc:Number=0;
		public var start:Number=0;
		
		//
		public var currPRG;
		
		var params:Object; // params for new DSON
		function PrgStepper(p:Array,pp=null){
			if(pp==null) pp={}; params=pp;
			name=p[0][0];
			items=p[2];
			if(p[3]!=null){
				var pp=p[3];
				for(var i in pp) this[i]=pp[i];
			}
			cc=delay;
			ind=start-1;
		}
		public function getNext(obj:Object){
			cc++
			if(cc>=delay){
				ind=(ind+1)%items.length;
				cc=0;
				currPRG=new DSON({val:items[ind]},params);
			}
			
			obj[name]=currPRG.getNext().val;
			
		}
	}
}