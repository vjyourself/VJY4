package vjyourself4{
	public class IdSet{
		public var list:Array;
		public var ids:Object;
		var lastId:Number=0;
		public function IdSet(){
			list=[];
			ids=[];
		}
		public function addItem(item){
			list.push(item);
			lastId++;
			ids["id"+lastId]=item;
			return "id"+lastId;
		}
		public function getItem(id){
			return ids[id];
		}
		public function removeItem(id){
			var it=ids[id];
			delete(ids[id]);
			var ind=list.indexOf(it);
			list.splice(ind,1);
			return it;
		}
		public function removeItemInd(ind){
			var it=list[ind];
			var id;for(var i in ids) if(it==ids[i]) id=i; 
			delete(ids[id]);
			list.splice(ind,1);
			return it;
		}
		public function removeItemRef(ref){
			var it=ref;
			var id;for(var i in ids) if(it==ids[i]) id=i; 
			delete(ids[id]);
			var ind=list.indexOf(it);
			list.splice(ind,1);
			return it;
		}
		public function empty(){
			while(list.length>0) list.pop();
			for(var i in ids) delete(ids[i]);
			lastId=0;
		}
		public function destroy(){
			while(list.length>0) list.pop();
			for(var i in ids) delete(ids[i]);
			list=null;
			ids=null;
		}
	}
}