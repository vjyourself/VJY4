package vjyourself4.dson{

	public class TransVar{
		public var NS:Object;
		public var def:Object;
		public var changes:Object;
		public var effect:Object;

		var active:Boolean=false;

		public function TransVar(){

		}
		public function init(){
			if(NS==null) NS={};
			def={};
			for(var i in NS) def[i]=NS[i];
			changes={};
			effect={};
			active=true;
		}
		public function setVal(n,v){
			if(active){
				if(changes[n]==null) {changes[n]=v-def[n];effect[n]=1;}
				else {changes[n]+=v-def[n];effect[n]++;}
			}
		}
		public function update(){
			if(active){
			for(var i in changes) NS[i]=def[i]+changes[i];//effect[i];
			changes={};
			effect={};
		}
		}

	}
}