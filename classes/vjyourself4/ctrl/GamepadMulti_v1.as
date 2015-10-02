package vjyourself4.ctrl{
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
		
		public var anal:Array;
		public var analFunc:Array;
		public var analNum0:int=2;
		public var analNum1:int=8;
		
		var i:int;
		var ii:int;

		public var multi:Boolean = false;
		public var swapState:int = 0;
		public var events:EventDispatcher = new EventDispatcher();

		public var trigInd=[0,0];

		public function GamepadMulti(){}
		
		public function init(){
			gamepadManager=ns._glob.input.gamepadManager;
			anal=[];
			analFunc=[];
			var a:Array;
			var aF:Array;
			for(i=0;i<analNum0;i++){
				a=new Array();
				aF=new Array();
				for(ii=0;ii<analNum1;ii++){
					a.push(0);
					aF.push(new WaveFollow({div:2.5,treshold:0.001}));
				}
				anal.push(a);
				analFunc.push(aF);
			}
		
			
				gamepadManager.events.addEventListener("Gamepad0_Back",nextTrig0,0,0,1);
				gamepadManager.events.addEventListener("Gamepad1_Back",nextTrig1,0,0,1);
				gamepadManager.events.addEventListener("Gamepad0_A",toggleSwap,0,0,1);
				gamepadManager.events.addEventListener("Gamepad1_A",toggleSwap,0,0,1);
				gamepadManager.events.addEventListener("GamepadButton",gamepadButton,0,0,1);
			
		}
		function toggleSwap(e){swapState=(swapState+1)%2;}

		function nextTrig0(e){trigInd[0]=(trigInd[0]+1)%2;}
		function nextTrig1(e){trigInd[1]=(trigInd[1]+1)%2;}
		
		var trigButtons=["Up","Right","Down","Left"];
		public function gamepadButton(e:DynamicEvent){
			var butt=e.data.button;
			var ind=e.data.ind;
			trace(butt);
			//trace(map[butt]);
			var i=-1;
			for(var ii=0;ii<trigButtons.length;ii++) if(trigButtons[ii]==butt) i=ii;
			if(i>=0) events.dispatchEvent(new DynamicEvent("Trig",{ind:i+((trigInd[ind])%2)*trigButtons.length}));
		}
		/*
		function execComm(comm){
			trace(comm[0],comm[1]);
			var tar=Eval.evalString(ns,comm[0]);
			trace(tar);
			tar[comm[1]].apply(tar,comm[2]);
		}*/

		public function onEF(e){
			//trace(gamepadManager.num);
			multi = gamepadManager.num>1;
			if(gamepadManager.num==1){
				process(swapState,gamepadManager.getState(0));
				//process((swapState+1)%2,stateEmpty);
			}
			if(gamepadManager.num>1){
				process(swapState,gamepadManager.getState(0));
				process((swapState+1)%2,gamepadManager.getState(1));
			}

		}

		function process(ind,s){
			//trace("PROC",ind,s);
			var aF=analFunc[ind];
			var a=anal[ind];

			aF[0].setVal(s.LeftTrigger);aF[0].onEF();a[0]=aF[0].val;
			aF[1].setVal(s.RightTrigger);aF[1].onEF();a[1]=aF[1].val;
			aF[2].setVal(s.LB);aF[2].onEF();a[2]=aF[2].val;
			aF[3].setVal(s.RB);aF[3].onEF();a[3]=aF[3].val;

			aF[4].setVal(s.Y);aF[4].onEF();a[4]=aF[4].val;
			aF[5].setVal(s.X);aF[5].onEF();a[5]=aF[5].val;
			aF[6].setVal(s.B);aF[6].onEF();a[6]=aF[6].val;
			aF[7].setVal(s.A);aF[7].onEF();a[7]=aF[7].val;
		}

		public function dispose(){
			
				gamepadManager.events.removeEventListener("Gamepad0_Back",toggleSwap);
				gamepadManager.events.removeEventListener("Gamepad1_Back",toggleSwap);
			
			gamepadManager=null;
		}
		
	}
}