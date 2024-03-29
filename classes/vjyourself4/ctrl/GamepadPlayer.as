﻿package vjyourself4.ctrl{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import vjyourself4.patt.WaveFollow;
	
	public class GamepadPlayer{
		public var _debug:Object;
		public var _meta:Object={name:"CtrlGamepadPlayer"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,true,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		public var gamepadManager;
		public var gamepadInd:Number=0;
		
		//ANAL PARAMS
		public var analNum:int=8;
		public var analPage_num:int=2;
		public var analPage_mode:String="step";
		public var analPage_butt:String="LB";
		//ANAL WORK
		public var anal:Array;
		public var analFunc:Array;
		public var analPage_ind:int=0;
		public var analPage_pp:int=0; // per page

		//TRIG PARAMS
		public var trigNum=8;
		public var trigPage_num=2;
		public var trigPage_mode="combo";
		public var trigPage_butt="LB";
		public var trigButtons=["Up","Right","Down","Left"];
		//TRIG WORK
		public var trigPage_ind:int=0;
		public var trigPage_pp:int=0; // per page


		var i:int;
		var ii:int;

		
		public var events:EventDispatcher = new EventDispatcher();

		public function GamepadPlayer(){}
		
		public function init(){
			gamepadManager=ns._sys.io.gamepad.manager;
			for(var i in params) this[i]=params[i];

			trigPage_pp=trigNum/trigPage_num;
			analPage_pp=analNum/analPage_num;
			
			anal=[];
			analFunc=[];
		
			
			for(i=0;i<analNum;i++){
					anal.push(0);
					analFunc.push(new WaveFollow({div:2.5,treshold:0.001}));
			}	
		
			if(analPage_num>1) gamepadManager.events.addEventListener("Gamepad"+gamepadInd+"_"+analPage_butt,onPageAnal,0,0,1);
			if(trigPage_num>1) gamepadManager.events.addEventListener("Gamepad"+gamepadInd+"_"+trigPage_butt,onPageTrig,0,0,1);
			//gamepadManager.events.addEventListener("Gamepad0_Y",buttY,0,0,1);
			//gamepadManager.events.addEventListener("Gamepad0_Start",analReset,0,0,1);
			gamepadManager.events.addEventListener("GamepadButton"+gamepadInd,gamepadButton,0,0,1);
			
		}

		function onPageAnal(e=null){
			if(analPage_mode=="step") analPage_ind=(analPage_ind+1)%analPage_num;
		}
		function getPageAnal():int{
			var p=analPage_ind;
			if(analPage_mode=="combo") {
				var s=gamepadManager.getState(gamepadInd);
				p=(p+s[analPage_butt]?1:0)%analPage_num;
			}
			return p;
		}
		
		function onPageTrig(e=null){
			if(trigPage_mode=="step") trigPage_ind=(trigPage_ind+1)%trigPage_num;
		}

		function getPageTrig():int{
			var p=trigPage_ind;
			if(trigPage_mode=="combo") {
				var s=gamepadManager.getState(gamepadInd);
				p=(p+s[trigPage_butt]?1:0)%trigPage_num;
			}
			return p;
		}
		/*
		function buttA(e){ stateAInd=0;}
		function buttB(e){ stateAInd=1;}
		function buttX(e){ stateAInd=2;}
		function buttY(e){ stateAInd=3;}
		*/
		function analReset(e=null){
			/*
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
			}*/
		}
		public function gamepadButton(e:DynamicEvent){
			var butt=e.data.button;
			var ind=e.data.ind;
			//trace(butt);
			//trace(map[butt]);
			var i=-1;
			//trace(trigButtons);
			for(var ii=0;ii<trigButtons.length;ii++) if(trigButtons[ii]==butt) i=ii;
			//trace("buttI",i);
			if((i>=0)&&(i<trigPage_pp)) events.dispatchEvent(new DynamicEvent("Trig",{ind:i+getPageTrig()*trigPage_pp}));
		}
		/*
		function execComm(comm){
			trace(comm[0],comm[1]);
			var tar=Eval.evalString(ns,comm[0]);
			trace(tar);
			tar[comm[1]].apply(tar,comm[2]);
		}*/

		public function onEF(e){
			process(getPageAnal(),gamepadManager.getState(gamepadInd));
		}

		function process(ind,s){
			//trace("PROC",ind,s);
			var aF=analFunc;
			var a=anal;
			var shift=ind*analPage_pp;

			if(analPage_pp>=1) {aF[0+shift].setVal(s.LeftTrigger);aF[0+shift].onEF();a[0+shift]=aF[0+shift].val;}
			if(analPage_pp>=2){aF[1+shift].setVal(s.RightTrigger);aF[1+shift].onEF();a[1+shift]=aF[1+shift].val;}
			if(analPage_pp>=3) {aF[2+shift].setVal(s.LB);aF[2+shift].onEF();a[2+shift]=aF[2+shift].val;}
			if(analPage_pp>=4) {aF[3+shift].setVal(s.RB);aF[3+shift].onEF();a[3+shift]=aF[3+shift].val;}

			/*
			//aF[4].setVal(s.A);aF[4].onEF();a[4]=aF[4].val;
			aF[5].setVal(s.Y);aF[5].onEF();a[5]=aF[5].val;
			aF[6].setVal(s.X);aF[6].onEF();a[6]=aF[6].val;
			aF[7].setVal(s.B);aF[7].onEF();a[7]=aF[7].val;
			*/
		}

		public function dispose(){
			if(analPage_num>1) gamepadManager.events.removeEventListener("Gamepad"+gamepadInd+"_"+analPage_butt,onPageAnal);
			if(trigPage_num>1) gamepadManager.events.removeEventListener("Gamepad"+gamepadInd+"_"+trigPage_butt,onPageTrig);
		
			gamepadManager.events.removeEventListener("GamepadButton"+gamepadInd,gamepadButton);
				
			gamepadManager=null;
		}
		
	}
}