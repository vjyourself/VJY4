package vjyourself4.games{
	import flash.utils.getDefinitionByName;

	public class VisLogo{
		public var ns:Object;
		public var params:Object;
		public function VisLogo(){
			
		}
		public function init(){
			var c:Class = getDefinitionByName(params.logoCN) as Class;
			var logo = new c();
			ns.screen.gui.addChild(logo,params);
		}
	}
}