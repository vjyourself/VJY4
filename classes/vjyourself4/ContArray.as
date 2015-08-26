package vjyourself4{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ContArray{
		
		public var elems:Array;
		public var elemsNum=0;
		//public var elemsLastIdNum=-1;
		//public var elemsLastId="";
		
		public function ContArray(){
			elems=[];
		//	post = new PostClient();
		//	post.target=this;
		//	post.init();
		}
		public function addElem(p:Object):String{
			elemsNum++;
			elems.push(p);
			//post.send("ADD_ELEM");
			return ""+(elems.length-1);
		}
		public function getElem(p:Object):Object{
			var id=p.id;
			return elems[id];
		}
		public function removeElem(p:Object){
			//elemsNum--;
			//var id=p.id;
			//delete elems[id];
			//post.send("REMOVE_ELEM");
			elems.pop();
		}
		
		public function destroy(){
			for(var i in elems) delete elems[i];
			elems=null;
		}
	}
}