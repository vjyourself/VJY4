package vjyourself4.three.logic{
	import flash.utils.getDefinitionByName;
	public class Logic{
		public var input:Object;
		public var musicmeta:Object;
		public var obj:Object;
		public var code:Object;
		
		var prgs:Array;
		public function Logic(){
			LogicStartHigh;
			LogicCirco;
			LogicShake;
		}
		public function init(){
			prgs=[];
			for(var i=0;i<code.active.length;i++){
				var c:Class = getDefinitionByName("vjyourself4.three.logic.Logic"+code.active[i].cn) as Class;
				var prg = new c(this,code.active[i].p);
				prg.init();
				prgs.push(prg);
			}
			};
		public function onEF(e=null){
			for(var i=0;i<prgs.length;i++) prgs[i].onEF();
			//trace("Logic On EF",prgs.length);
		}
		public function dispose(){
			
		}
	}
}