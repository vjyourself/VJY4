package vjyourself4.patt{
	public class DataStepper{
		public var elems:Array;
		public var ind:int;
		public var val:Object;
		public function DataStepper(){

		}
		public function setInd(i){
			ind=(i+elems.length)%elems.length;
			val=elems[ind];
		}
		public function next(){setInd(ind+1);}
		public function prev(){setInd(ind-1);}
	}
}