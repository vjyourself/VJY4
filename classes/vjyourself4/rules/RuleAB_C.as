package vjyourself4.rules{
	public class RuleAB_C{
		public var patt:Object;
		var listA:Object;
		var listB:Object;
		var listAB:Array;
		var def;
		public function RuleAB_C(patt){
			if(patt.listA!=null) listA=patt.listA; else listA={};
			if(patt.listB!=null) listB=patt.listB; else listB={};
			if(patt.listAB!=null) listAB=patt.listAB; else listAB=[];
			def=patt.def;			
		}

		public function getVal(a,b){
			var c=def;
			//if(listA[a]!=null) c=listA[a];
			if(listB[b]!=null) c=listB[b];
			//for(var i=0;i<listAB.length;i++) if((listAB[i].a==a)&&(listAB[i].b==b)) c=listAB.c;
			return c;
		}
	}
}