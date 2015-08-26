package vjyourself4.three{
	import flash.display.Sprite;
	import flash.events.Event;
	import vjyourself2.wave.WaveFollow;
	import flash.utils.getDefinitionByName;
	import flash.geom.Vector3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	public class ContShift{
		
		public static var classMeta={
			
			cn:"vjyourself4.comp.CompCraft",
			name:"CanvasMirror",categories:"Composition",
			desc:"",
			//////////////////////////////////////////////
			params:{
				cn:{t:"Array"},
				dimX:{def:960},
				dimY:{def:540}
			},
			system:{enterframe:{},input:{},musicMeta:{}},
			needs:{},
			//////////////////////////////////////////////
			vis:[{n:"vis",origo:"topleft",cn:"flash.display.Sprite"}],
			viscont:[],
			data:{},
			functions:{},
			events:{}	
		}
		
		public var vis:ObjectContainer3D;
		public var musicMeta:Object;
		public var input:Object;
		
		public var elems:Array;
		public var elemsR0=600;
		public var elemsInd0=0;
		
		public var rMin=0;
		public var rGap=0;
		public var rMax=0;
		
		var WFRX = new WaveFollow({treshold:0});
		var WFRY = new WaveFollow({treshold:0});
		var WFLX = new WaveFollow({treshold:0});
		var WFLY = new WaveFollow({treshold:0});
		var WFPeak = new WaveFollow({treshold:0});
		var mspeed=0;
		
		public function ContShift(){}
		
		public function init(){
			vis = new ObjectContainer3D();
			elemsR0=rMin;
			for(var i=0;i<elems.length;i++) vis.addChild(elems[i].vis);
		
		}
		
		public function onEF(e=null){
			switch(input.def){
				case "gamepad":
				var s0=input.gamepadManager.getState(0);
				WFRX.setVal(s0.RightStick.x+0.5);WFRX.onEF();
				WFRY.setVal(s0.RightStick.y-0.5);WFRY.onEF();
				WFLX.setVal(s0.LeftStick.x);WFLX.onEF();
				WFLY.setVal(s0.LeftStick.y-0.1);WFLY.onEF();
				break;
				case "mkb":
				if(input.mouse.butt==1){
					mspeed+=0.001;
					if(mspeed>0.2) mspeed=0.2;
				}else{
					mspeed-=0.001;
					if(mspeed<-0.02) mspeed=-0.02;
				}
				WFLY.setVal(-mspeed);WFLY.onEF();
				WFRX.setVal(input.mouse.rX/4);WFRX.onEF();
				WFRY.setVal(input.mouse.rY/4);WFRY.onEF();
				break;
			
			}
			
			var ww=musicMeta.waveDataDamped;
			WFPeak.setVal(musicMeta.peak);WFPeak.onEF();
			var peak=WFPeak.val;
			
			for(var i=0;i<elems.length;i++){
				elems[i].vis.rotationY+=WFRY.val*(1/(i+1)*((i%2)*2-1));
				elems[i].vis.rotationX+=WFRX.val*(1/(i+1)*((i%2)*2-1));
			}
			elemsR0+=WFLY.val*10;
			if(elemsR0<rMin){
				elemsInd0++;
				elemsR0+=rGap;
			}
			if(elemsR0>rMin+rGap){
				elemsInd0=(elemsInd0-1+elems.length)%elems.length;
				elemsR0-=rGap;
			}
			for(var i=0;i<elems.length;i++){
				var el=elems[(elemsInd0+i)%elems.length];
				el.r=elemsR0+i*rGap;
				el.objScale=WFPeak.val;
				el.update();
			}
			/*
			switch(input.def){
				case "gamepad":
				var s0=input.gamepadManager.getState(0);
				var stickX=0;
				var stickY=0;
				switch(inputPos){
					case "right":
					stickX=s0.RightStick.x;
					stickY=s0.RightStick.y;
					break;
					case "left":
					stickX=s0.LeftStick.x;
					stickY=s0.LeftStick.y;
					break;
				}*/
		}
	}
}