package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.patt.WaveFollow;
	
	public class GamepadSingle{
		public var _debug:Object;
		public var _meta:Object={name:"CtrlGamepad"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		
		public var players:Array=[];
		public var player:GamepadPlayer;
		public var anal:Array;
		
		public var events:EventDispatcher = new EventDispatcher();

		public function GamepadSingle(){}
		
		public function init(){
			var gamepadManager=ns._glob.input.gamepadManager;
			
			player = new GamepadPlayer();
			players.push(player);
			player.ns=ns;
			player.gamepadInd=0;
			player.params=params.players[0];
			player.events.addEventListener("Trig",onTrig);
			player.init();

			anal = player.anal;
			
		}
		function onTrig(e:DynamicEvent){
			events.dispatchEvent(new DynamicEvent("Trig",{ind:e.data.ind}));
		}
		public function onEF(e){
			player.onEF(e);
		}
		public function dispose(){
		}
		
	}
}