package vjyourself4.sys{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	public dynamic class Sys_VisTerminal extends Sprite{
		public var state="";
		public var tfConsole:TextField;
		public var intro:MovieClip;
		public var terminal:Sprite;
		
		public function Sys_VisTerminal(){
			intro.visible=true;
			terminal.visible=false;
			tfConsole=terminal["tf"];
			state="intro";
		}
		
		public function onEF(e=null){
			if(state=="intro"){
				if(intro.totalFrames==intro.currentFrame){
					intro.visible=false;
					terminal.visible=true;
					
					state="preload";
				}
			}
		}
	}
}