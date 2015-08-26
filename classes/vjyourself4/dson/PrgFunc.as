package vjyourself4.dson{
	
	public class PrgFunc{
		var names:Array;
		
		public var v0:Number=0;
		public var v1:Number=1;
		public var step:Number=0.1;
		public var func:String="lin";
		
		public var perc:Number=0;
		public var val:Number=0;
		
		var myFunc:Function;
		function PrgFunc(p:Array){
			names=p[0];
			var pp=p[2];
			for(var i in pp) this[i]=pp[i];
			myFunc=this["func_"+func];
		}
		public function getNext(obj:Object){
			val=v0+(v1-v0)*myFunc();
			obj[names[0]]=val;
			perc+=step; if(perc>1) perc-=1;
		}
		
		function func_absint(){return Math.sin(perc*Math.PI);}
		function func_sin(){return 0.5-Math.cos(perc*Math.PI*2)*0.5;}
		function func_tri(){return (perc<0.5)?perc*2:1-(perc-0.5)*2;}
		function func_lin(){return perc;}
	}
}