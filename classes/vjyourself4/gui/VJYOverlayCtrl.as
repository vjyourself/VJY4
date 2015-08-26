package vjyourself4.gui{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import vjyourself4.sys.WinConsoleLong;
	import flash.display.SimpleButton;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;
	import vjyourself4.ctrl.BindAnal;

	public class VJYOverlayCtrl  extends Sprite{
		public var wDimX:Number;
		public var wDimY:Number;
		public var wLimTop:Number=0;
		public var wLimBottom:Number=0;
		
		public var ns:Object;
		public var A0:Number=0;
		public var A1:Number=0;
		public var A2:Number=0;
		public var A3:Number=0;
		public var anal:BindAnal;
		
		var sliderA0:HoriSlider;
		var sliderA1:HoriSlider;
		var sliderA2:HoriSlider;
		var sliderA3:HoriSlider;
		var buttA:Sprite;
		var buttA2:Sprite;
		var buttA3:Sprite;
		var buttA4:Sprite;
		var buttB:Sprite;
		var buttB2:Sprite;
		var buttC:Sprite;

		public function VJYOverlayCtrl(){
			
		}
		public function init(){
			//guiMsg = new GUIMsg();
			//addChild(guiMsg);
			sliderA0 = new HoriSlider();
			sliderA0.relative=true;
			sliderA0.x=162+10;
			sliderA0.y=30;
			sliderA0.scaleY=-1;
			sliderA0.autoval=true;
			sliderA0.tfVal_bool=false;
			sliderA0.init();
			sliderA0.setVal(0);
			addChild(sliderA0);

			sliderA1 = new HoriSlider();
			sliderA1.relative=true;
			sliderA1.x=162+320+60-10;
			sliderA1.y=30;
			sliderA1.scaleY=-1;
			sliderA1.autoval=true;
			sliderA1.tfVal_bool=false;
			sliderA1.init();
			sliderA1.setVal(0);
			addChild(sliderA1);

			sliderA2 = new HoriSlider();
			sliderA2.relative=true;
			sliderA2.x=162-100;
			sliderA2.y=wDimY-30;
			sliderA2.autoval=true;
			sliderA2.tfVal_bool=false;
			sliderA2.init();
			sliderA2.setVal(0);
			addChild(sliderA2);

			sliderA3 = new HoriSlider();
			sliderA3.relative=true;
			sliderA3.x=162+320+60+100;
			sliderA3.y=wDimY-30;
			sliderA3.autoval=true;
			sliderA3.tfVal_bool=false;
			sliderA3.init();
			sliderA3.setVal(0);
			addChild(sliderA3);

			buttA = new ButtTriOpt();
			buttA.rotation=0;
			buttA.x=0;
			buttA.y=200;
			buttA.addEventListener(MouseEvent.CLICK,buttAOnClick,0,0,1);
			addChild(buttA);

			buttA2 = new ButtTriOpt();
			buttA2.rotation=0;
			buttA2.x=0;
			buttA2.y=260;
			buttA2.scaleX=0.66;
			buttA2.scaleY=0.66;
			buttA2.addEventListener(MouseEvent.CLICK,buttA2OnClick,0,0,1);
			//buttA2["opt"].visible=false;
			addChild(buttA2);

			buttA3 = new ButtTriOpt();
			buttA3.rotation=0;
			buttA3.x=0;
			buttA3.y=360;
			buttA3.addEventListener(MouseEvent.CLICK,buttA3OnClick,0,0,1);
			addChild(buttA3);

			buttA4 = new ButtTriOpt();
			buttA4.rotation=0;
			buttA4.x=0;
			buttA4.y=420;
			buttA4.scaleX=0.66;
			buttA4.scaleY=0.66;
			buttA4.addEventListener(MouseEvent.CLICK,buttA4OnClick,0,0,1);
			//buttA4["opt"].visible=false;
			addChild(buttA4);

			buttB = new ButtTriOpt();
			buttB.scaleX=-1;
			buttB.x=wDimX;
			buttB.y=200;
			buttB.addEventListener(MouseEvent.CLICK,buttBOnClick,0,0,1);
			addChild(buttB);

			buttB2 = new ButtTriOpt();
			buttB2.scaleX=-1;
			buttB2.x=wDimX;
			buttB2.y=360;
			buttB2.addEventListener(MouseEvent.CLICK,buttB2OnClick,0,0,1);
			addChild(buttB2);

			buttC = new ButtTriOpt();
			buttC.rotation=-90;
			buttC.x=wDimX/2;
			buttC.y=wDimY;
			buttC.addEventListener(MouseEvent.CLICK,buttCOnClick,0,0,1);
			addChild(buttC);
			onResize();
		}
		public function onResize(){

			var sliderWidth=wDimX/1024*320;
			var sliderHeight=wDimY/768*50;

			wLimTop=sliderHeight;
			wLimBottom=sliderHeight;
			
			sliderA0.x=172;
			sliderA0.y=sliderHeight;
			sliderA0.dimX=sliderWidth;
			sliderA0.dimY=sliderHeight;
			sliderA0.updateSize();
			
			sliderA1.x=wDimX-172-sliderWidth;
			sliderA1.y=sliderHeight;
			sliderA1.dimX=sliderWidth;
			sliderA1.dimY=sliderHeight;
			sliderA1.updateSize();
			
			sliderA2.x=62;
			sliderA2.y=wDimY-sliderHeight;
			sliderA2.dimX=sliderWidth;
			sliderA2.dimY=sliderHeight;
			sliderA2.updateSize();
			
			sliderA3.x=wDimX-62-sliderWidth;
			sliderA3.y=wDimY-sliderHeight;
			sliderA3.dimX=sliderWidth;
			sliderA3.dimY=sliderHeight;
			sliderA3.updateSize();
			
			var sButt=wDimY/768;

			buttA.x=0;
			buttA.y=200*sButt;
			buttA.scaleX=sButt;
			buttA.scaleY=sButt;


			buttA2.x=0;
			buttA2.y=260*sButt;
			buttA2.scaleX=sButt*0.66;
			buttA2.scaleY=sButt*0.66;

			buttA3.x=0;
			buttA3.y=360*sButt;
			buttA3.scaleX=sButt;
			buttA3.scaleY=sButt;
			
			buttA4.x=0;
			buttA4.y=420*sButt;
			buttA4.scaleX=sButt*0.66;
			buttA4.scaleY=sButt*0.66;

			buttB.x=wDimX;
			buttB.y=200*sButt;
			buttB.scaleX=-sButt;
			buttB.scaleY=sButt;

			buttB2.x=wDimX;
			buttB2.y=360*sButt;
			buttB2.scaleX=-sButt;
			buttB2.scaleY=sButt;
			
			buttC.x=wDimX/2;
			buttC.y=wDimY;
			buttC.scaleX=sButt;
			buttC.scaleY=sButt;

		}
		public function buttAOnClick(e){
			ns.sceneVary.next(0);
			//game.ns.scene.next("context.color.A");
			//buttA["opt"].gotoAndStop(game.ns.scene.vary.context.color.A.i+1);
		}
		public function buttA2OnClick(e){
			ns.sceneVary.next(4);
			//game.ns.GP.context.cont.colorStreamA.shift();
			//game.ns.GP.context.cont.colorStreamLights.shift();
			//buttA["opt"].gotoAndStop(game.ns.scene.vary.context.color.Lights.i+1);
		}
		public function buttA3OnClick(e){
			ns.sceneVary.next(1);
			//game.ns.scene.next("context.color.B");
			//buttA3["opt"].gotoAndStop(game.ns.scene.vary.context.color.B.i+1);
		}
		public function buttA4OnClick(e){
			ns.sceneVary.next(5);
			//game.ns.GP.context.cont.colorStreamB.shift();
			//game.ns.GP.context.cont.colorStreamLights.shift();
			//buttA["opt"].gotoAndStop(game.ns.scene.vary.context.color.Lights.i+1);
		}

		public function buttBOnClick(e){
			ns.sceneVary.next(2);
			//game.ns.scene.next("context.texture.A");
			//buttB["opt"].gotoAndStop(game.ns.scene.vary.context.texture.A.i+1);
		}
		public function buttB2OnClick(e){
			ns.sceneVary.next(3);
			//game.ns.scene.next("space",{"rebuild":true});
			//buttB2["opt"].gotoAndStop(game.ns.scene.vary.space.i+1);
		}
		public function buttCOnClick(e){
			ns.sceneVary.next(6);
			resetAnal();
			//game.ns.scene.next("space",{"rebuild":true});
			//buttB2["opt"].gotoAndStop(game.ns.scene.vary.space.i+1);
		}
		public function updateScene(){
			reset();
			//buttA["opt"].gotoAndStop(game.ns.scene.vary.context.color.A.i+1);
			//buttA3["opt"].gotoAndStop(game.ns.scene.vary.context.color.B.i+1);
			//buttB["opt"].gotoAndStop(game.ns.scene.vary.context.texture.A.i+1);

		}
		public function reset(){
			sliderA0.setVal(0);
			sliderA1.setVal(1);
			sliderA2.setVal(0);
			sliderA3.setVal(1);
		}
		public function resetAnal(){
			anal.setInput(0,sliderA0.val+sliderA0.valDelta);
			anal.setInput(1,1-(sliderA1.val+sliderA1.valDelta));
			anal.setInput(2,sliderA2.val+sliderA2.valDelta);
			anal.setInput(3,1-(sliderA3.val+sliderA3.valDelta));
		}
		public function onEF(e=null){
			/*
			A0=sliderA0.val;
			A1=1-sliderA1.val;
			A2=sliderA2.val;
			A3=1-sliderA3.val;
			*/
			sliderA0.setVal(anal.getVal(0));
			sliderA1.setVal(1-anal.getVal(1));
			sliderA2.setVal(anal.getVal(2));
			sliderA3.setVal(1-anal.getVal(3));
			if(sliderA0.mouseDown) anal.setInput(0,sliderA0.val+sliderA0.valDelta);
			if(sliderA1.mouseDown) anal.setInput(1,1-(sliderA1.val+sliderA1.valDelta));
			if(sliderA2.mouseDown) anal.setInput(2,sliderA2.val+sliderA2.valDelta);
			if(sliderA3.mouseDown) anal.setInput(3,1-(sliderA3.val+sliderA3.valDelta));
			trace(sliderA0.valDelta);
		}
		
	}
}