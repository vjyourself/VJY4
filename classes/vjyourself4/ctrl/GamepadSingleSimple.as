package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.patt.WaveFollow;
	
	public class GamepadSingleSimple{
		public var _debug:Object;
		public var _meta:Object={name:"CtrlGamepad"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		public var gamepadManager;
		
		public var stateTInd:int = 0;
		public var stateTNum:int = 2;
		public var stateAInd:int = 0;
		public var stateANum:int = 4;

		public var anal:Array;
		public var analFunc:Array;
		public var analNum:int=4;

		public var trigNum:int=8;
		var trigButtons=["X","Y","A","B","Up","Right","Down","Left"];
		
		var i:int;
		var ii:int;

		
		public var events:EventDispatcher = new EventDispatcher();

		public function GamepadSingleSimple(){}
		
		public function init(){
			if(ns._glob.input.gamepad_enabled){
				gamepadManager=ns._glob.input.gamepadManager;
				anal=[];
				analFunc=[];
				var a:Array;
				var aF:Array;
				for(i=0;i<stateANum;i++){
					a=new Array();
					aF=new Array();
					for(ii=0;ii<analNum;ii++){
						a.push(0);
						aF.push(new WaveFollow({div:2.5,treshold:0.001}));
					}
					anal.push(a);
					analFunc.push(aF);
				}
			
			
			//gamepadManager.events.addEventListener("Gamepad0_Back",nextStateT,0,0,1);
			//gamepadManager.events.addEventListener("Gamepad0_X",buttA,0,0,1);
			//gamepadManager.events.addEventListener("Gamepad0_B",buttB,0,0,1);
			//gamepadManager.events.addEventListener("Gamepad0_A",nextStateA,0,0,1);
			//gamepadManager.events.addEventListener("Gamepad0_Y",buttY,0,0,1);
			//gamepadManager.events.addEventListener("Gamepad0_Start",analReset,0,0,1);
			gamepadManager.events.addEventListener("GamepadButton",gamepadButton,0,0,1);
			}
		}
		function nextStateA(e){stateAInd=(stateAInd+1)%stateANum;}
		function nextStateT(e){stateTInd=(stateTInd+1)%stateTNum;}
		/*
		function buttA(e){ stateAInd=0;}
		function buttB(e){ stateAInd=1;}
		function buttX(e){ stateAInd=2;}
		function buttY(e){ stateAInd=3;}
		*/
		function analReset(e){
			for(i=0;i<stateANum;i++){
				var aF=analFunc[i];
				var a=anal[i];
			aF[0].val=0;a[0]=aF[0].val;
			aF[1].val=0;a[1]=aF[1].val;
			aF[2].val=0;a[2]=aF[2].val;
			aF[3].val=0;a[3]=aF[3].val;

			aF[4].val=0;a[4]=aF[4].val;
			aF[5].val=0;a[5]=aF[5].val;
			aF[6].val=0;a[6]=aF[6].val;
			aF[7].val=0;a[7]=aF[7].val;
			}
		}
		public function gamepadButton(e:DynamicEvent){
			var butt=e.data.button;
			var ind=e.data.ind;
			trace(butt);
			//trace(map[butt]);
			var i=-1;
			for(var ii=0;ii<trigButtons.length;ii++) if(trigButtons[ii]==butt) i=ii;
			if(i>=0) events.dispatchEvent(new DynamicEvent("Trig",{ind:i+stateTInd*trigNum}));
		}
		/*
		function execComm(comm){
			trace(comm[0],comm[1]);
			var tar=Eval.evalString(ns,comm[0]);
			trace(tar);
			tar[comm[1]].apply(tar,comm[2]);
		}*/

		public function onEF(e){
			process(gamepadManager.getState(0));
		}

		function process(s){
			//trace("PROC",ind,s);
			var aF=analFunc[0];
			var a=anal[0];

			aF[0].setVal(s.LeftTrigger);aF[0].onEF();a[0]=aF[0].val;
			aF[1].setVal(s.RightTrigger);aF[1].onEF();a[1]=aF[1].val;
			aF[2].setVal(s.LB);aF[2].onEF();a[2]=aF[2].val;
			aF[3].setVal(s.RB);aF[3].onEF();a[3]=aF[3].val;

			//aF[4].setVal(s.A);aF[4].onEF();a[4]=aF[4].val;
			//aF[5].setVal(s.Y);aF[5].onEF();a[5]=aF[5].val;
			//aF[6].setVal(s.X);aF[6].onEF();a[6]=aF[6].val;
			//aF[7].setVal(s.B);aF[7].onEF();a[7]=aF[7].val;
		}

		public function dispose(){
			gamepadManager.events.removeEventListener("Gamepad0_Back",nextStateT);
			//gamepadManager.events.addEventListener("Gamepad0_X",buttA,0,0,1);
			//gamepadManager.events.addEventListener("Gamepad0_B",buttB,0,0,1);
			gamepadManager.events.removeEventListener("Gamepad0_A",nextStateA);
			//gamepadManager.events.addEventListener("Gamepad0_Y",buttY,0,0,1);
			//gamepadManager.events.addEventListener("Gamepad1_Back",toggleSwap,0,0,1);
			gamepadManager.events.removeEventListener("GamepadButton",gamepadButton);
				
			gamepadManager=null;
		}
		
	}
}