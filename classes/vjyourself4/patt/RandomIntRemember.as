/*
<title>Random Int Remember
<desc>returns random int different from preceiding returns

<param>memoryLength - how many preceiding to check
<param>timeout - timeout*memory.length maximum trys
<param>max - return number smaller than [max] , >=0
*/
package vjyourself2.wave{
	public class RandomIntRemember{
		var memory:Array= new Array();
		var memoryInd=-1;
		public var memoryLength=10;
		public var max=10;
		public var timeout=50;//cc < memory.length*timeout
		public function RandomIntRemember(){
		}
		public function getVal(m:Number=-1){
			if(m==-1) m=max;
			var cc=0;
			do{
			var v= Math.floor(Math.random()*m);
			cc++;
			}while( (!isitokay(v))&&(cc<memory.length*timeout));
			addElem(v);
			trace("M:"+memory);
			return v;
		}
		function addElem(v:Number){
			memoryInd=(memoryInd+1)%memoryLength;
			memory[memoryInd]=v;
		}
		function isitokay(v:Number){
			var ret=true;
			for(var i=0;i<memory.length;i++)ret=ret&&(v!=memory[i]);
			return ret;
		}
	}
}