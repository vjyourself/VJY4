package vjyourself4.patt{
	public class RandomWeights{
		public var weights:Array;
		public var sum:Number=0;
		
		public function RandomWeights(){
			
		}
		
		public function setWeights(a){
			weights=a;
			sum=0;
			for(var i=0;i<weights.length;i++) sum+=weights[i];
			//trace("sum:"+sum);
		}
		public function setWeightsO(o){
			var w=[];
			for(var i=0;i<o.length;i++) w.push(o[i].weight);
			setWeights(w);
		}
		
		public function getNext(){
			var m = Math.random()*sum;
			var ind=-1;
			var lim=0;
			do{
				ind++;
				lim+=weights[ind];
			}while((m>lim)&&(ind<weights.length-1));
			return ind;
		}
		
	}
}