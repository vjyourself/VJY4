package vjyourself4.dson{
	import vjyourself4.cloud.Cloud;
	import vjyourself4.cycle.Cycle;
	
	public class PrgCloud{
		public var name:String="";
		public var tar:String="";
		public var params:Object;
		public var query:Object;
		
		public var cloud:Cloud;
		public var context:Object;
		
		var cycle:Cycle;
		
		function PrgCloud(p:Array){
			name=p[0][0];
			tar=p[2]
			query=p[3];
			params=p[4];
		}
		public function init(){
			if(tar=="C3D" && (query.q=="A" || query.q=="B")){
				tar="context";
				query={type:"texture",stream:query.q};
			}
			if(tar=="C3D" && (query.q=="multiA" || query.q=="multiB")){
				tar="context";
				query={type:"texture",stream:((query.q=="multiA")?"A":"B")};
			}
			if((tar=="CCol")&&(query.q=="A" || query.q == "B")){
				tar="context";
				query={type:"color",stream:query.q};
			}
			switch(tar){
				case "C3D":
					//if((context[query.q]!=null)&&(context[query.q]!="")) cycle=cloud[tar].createCycle(context[query.q],params);
					cycle=cloud[tar].createCycle(query.q,params);
				break;
				case "context":
					
				break;
				default:
					cycle=cloud[tar].createCycle(query.q,params);
				break;
			}
		}
		public function getNext(obj:Object){
			//trace("name:"+name+" cycle:"+cycle);
			if(tar=="context") obj[name]=context.getNext(query);
			else obj[name]=cycle.getNext();
		}
	}
}