package neuralbox2.wave{
	public class RandomSpread{
		public var lim0:Number=0;
		public var lim1:Number=1;
		public var maxNum:Number=2;
		public var num:Number=0;
		public var elems:Array;
		public var timeout=100;
		function RandomSpread(){
			elems=new Array();
		}
		public function getVal(dim):Number{
			trace("GET VAL");
			var val=0;var tries=0;
			do{
				val=lim0+(lim1-lim0)*Math.random();
				tries++;
			}while((!checkVal(val,dim))&&(tries<timeout));
			elems.push({val:val,dim:dim});
			if(elems.length>maxNum)elems.shift();
			num=elems.length;
			trace("VAL:"+val);
			return val;
		}
		
		public function checkVal(val,dim){
			var ok=true;
			trace("check:"+val+","+dim);
			for(var i=0;i<num;i++){
				var e=elems[i];
				if( (e.val<val) && ((e.val+e.dim/2)>(val-dim/2)) ) ok=false;
				if( (e.val>val) && ((e.val-e.dim/2)<(val+dim/2)) ) ok=false;
					
				trace(i+":"+ok+" : "+( (e.val<val) && ((e.val+e.dim/2)>(val-dim/2)) )+","+( (e.val>val) && ((e.val-e.dim/2)<(val+dim/2)) ) );
			}
			return ok;
		}
	}
}