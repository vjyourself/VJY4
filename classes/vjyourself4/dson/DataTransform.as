package vjyourself4.dson{
	public class DataTransform{
		public function DataTransform(){
			
		}
		public static function merge(a,b){
			//trace("a:"+a);trace("b:"+b);
			for(var i in b){
				//trace(i);
				a[i]=b[i];
			}
		}
	}
}