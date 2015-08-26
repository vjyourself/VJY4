package vjyourself4.games{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CompBlend{
		public var ns:Object;
		public var params:Object;
		
		var elems:Array;
		var elemsInd=0;

		var R3D;
				
		public function CompBlend(){}
		
		public function init(){
			if(params.elems==null) elems=["NORMAL"];
			else elems=params.elems;
			
			elemsInd=0;
			R3D=ns.cloud.R3D;
		}
	
		
		public function setBlend(m){
			R3D.applyBlendMode(m);
			for(var i in elems) if(elems[i]==m) elemsInd=i;
			//autocc=0;
		};
		public function next(e=null){
			elemsInd=(elemsInd+1)%elems.length;
			setBlend(elems[elemsInd]);
		};
		public function prev(e=null){
			elemsInd=(elemsInd-1+elems.length)%elems.length;
			setBlend(elems[elemsInd]);
		}

	}
}