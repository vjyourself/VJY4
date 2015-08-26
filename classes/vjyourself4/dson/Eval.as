package vjyourself4.dson{
	public class Eval{
		function Eval(){
		}
		//only for backward compatibility -- name change String -> Path
		public static function evalString(ns,str):Object{return Eval.evalPath(ns,str);}
		public static function evalString2(ns,str):Object{return Eval.evalPath2(ns,str);}
		
		public static function evalPath(ns,str):Object{
			var objs=str.split(".");
			var ret=ns[objs[0]];
			for(var i=1;i<objs.length;i++) ret=ret[objs[i]];
			return ret;
		}
		public static function evalPath2(ns,str):Object{
			var objs=str.split(".");
			var ret={obj:ns[objs[0]],prop:objs[objs.length-1]};
			for(var i=1;i<objs.length-1;i++) ret=ret.obj[objs[i]];
			return ret;
		}
		
	}
}