﻿package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.patt.WaveFollow;
	
	public class GamepadMulti{
		public var _debug:Object;
		public var _meta:Object={name:"CtrlGamepad"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		public var gamepadManager;
		public var players:Array=[];

		public var events:EventDispatcher = new EventDispatcher();

		public var anal:Array=[];

		public function GamepadMulti(){}
		
		public function init(){
		var gamepadManager=ns._glob.input.gamepadManager;
			gamepadManager.singleMerge=false;
			
			for(var i=0;i<2;i++){
				var player = new GamepadPlayer();
				players.push(player);
				player.ns=ns;
				player.gamepadInd=i+1;
				player.params=params.players[i%params.players.length];
				player.events.addEventListener("Trig",onTrig);
				player.init();
			}
		}
		
		function onTrig(e:DynamicEvent){
			events.dispatchEvent(new DynamicEvent("Trig",{ind:e.data.ind}));
		}

		public function onEF(e){
			for(var i=0;i<players.length;i++)players[i].onEF(e);
			for(var i=0;i<players[0].anal.length;i++){
				anal[i]=0;
				for(var ii=0;ii<players.length;ii++) anal[i]+=players[ii].anal[i];
				if(anal[i]>1)anal[i]=1;
			}
		}


		public function dispose(){
			
			
			gamepadManager=null;
		}
		
	}
}