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
		var buttA: ButtTriOpt;
		var buttA2:ButtTriOpt;
		var buttA3:ButtTriOpt;
		var buttA4:ButtTriOptR;
		var buttB:ButtTriOptR;
		var buttB2:ButtTriOptR;
		var buttC:ButtTriOpt;

		var overlayHelp:OverlayCtrlHelp;
		public function VJYOverlayCtrl(){
			
		}
		public function init(){
			overlayHelp = new OverlayCtrlHelp();
			overlayHelp.visible=false;
			overlayHelp.okay.addEventListener(MouseEvent.CLICK,toggleHelp);
			addChild(overlayHelp);

			//guiMsg = new GUIMsg();
			//addChild(guiMsg);
			sliderA0 = new HoriSlider();
			overlayHelp.sliderA1.tf.text="Modulation A1";
			sliderA0.relative=true;
			sliderA0.scaleY=-1;
			sliderA0.autoval=true;
			sliderA0.tfVal_bool=false;
			sliderA0.init();
			sliderA0.setVal(0);
			addChild(sliderA0);

			sliderA1 = new HoriSlider();
			overlayHelp.sliderA2.tf.text="Modulation A2";
			sliderA1.relative=true;
			sliderA1.scaleY=-1;
			sliderA1.autoval=true;
			sliderA1.tfVal_bool=false;
			sliderA1.init();
			sliderA1.setVal(0);
			addChild(sliderA1);

			sliderA2 = new HoriSlider();
			overlayHelp.sliderA3.tf.text="Modulation A3";
			sliderA2.relative=true;
			sliderA2.autoval=true;
			sliderA2.tfVal_bool=false;
			sliderA2.init();
			sliderA2.setVal(0);
			addChild(sliderA2);

			sliderA3 = new HoriSlider();
			overlayHelp.sliderA4.tf.text="Modulation A4";
			sliderA3.relative=true;
			sliderA3.autoval=true;
			sliderA3.tfVal_bool=false;
			sliderA3.init();
			sliderA3.setVal(0);
			addChild(sliderA3);

			buttA = new ButtTriOpt();
			buttA.tray.label.tfType.text="front color";
			overlayHelp.labelA.tf.text="Front Color";
			buttA.rotation=0;
			buttA.addEventListener(MouseEvent.CLICK,buttAOnClick,0,0,1);
			addChild(buttA);
			



			buttA2 = new ButtTriOpt();
			buttA2.rotation=0;
			overlayHelp.labelA2.tf.text="Shift Palette";
			buttA2.addEventListener(MouseEvent.CLICK,buttA2OnClick,0,0,1);
			//buttA2["opt"].visible=false;
			addChild(buttA2);

			buttA3 = new ButtTriOpt();
			buttA3.tray.label.tfType.text="front images";
			overlayHelp.labelA3.tf.text="Front Images";
			buttA3.rotation=0;
			buttA3.addEventListener(MouseEvent.CLICK,buttA3OnClick,0,0,1);
			addChild(buttA3);

			buttA4 = new ButtTriOptR();
			buttA4.rotation=0;
			overlayHelp.labelA4.tf.text="Shift Palette";
			buttA4.addEventListener(MouseEvent.CLICK,buttA4OnClick,0,0,1);
			//buttA4["opt"].visible=false;
			addChild(buttA4);

			buttB = new ButtTriOptR();
			buttB.tray.label.tfType.text="back color";
			overlayHelp.labelB.tf.text="Back Color";
			buttB.addEventListener(MouseEvent.CLICK,buttBOnClick,0,0,1);
			addChild(buttB);

			buttB2 = new ButtTriOptR();
			buttB2.tray.label.tfType.text="back image";
			overlayHelp.labelB2.tf.text="Back Image";
			buttB2.x=wDimX;
			buttB2.y=360;
			buttB2.addEventListener(MouseEvent.CLICK,buttB2OnClick,0,0,1);
			addChild(buttB2);

			buttC = new ButtTriOpt();
			buttC.tray.label.tfType.text="space vary";
			overlayHelp.labelC.tf.text="Space Vary";
			buttC.rotation=-90;
			buttC.addEventListener(MouseEvent.CLICK,buttCOnClick,0,0,1);
			addChild(buttC);

			overlayHelp.labelSS.tf.text="Screen Shot";
			overlayHelp.labelReset.tf.text="Reset";


			onResize();
		}

		public function onResize(){

			var sliderWidth=wDimX/1024*320;
			var sliderHeight=wDimY/768*50;
			var sButt=wDimY/768;

			wLimTop=sliderHeight;
			wLimBottom=sliderHeight;
			
			overlayHelp.okay.x=wDimX/2;
			overlayHelp.okay.y=wDimY/2;
			overlayHelp.okay.scaleX=sButt;
			overlayHelp.okay.scaleY=sButt;
			
			sliderA0.x=162*sButt;
			sliderA0.y=sliderHeight;
			sliderA0.dimX=sliderWidth;
			sliderA0.dimY=sliderHeight;
			sliderA0.updateSize();
			overlayHelp.sliderA1.scaleX=sButt;
			overlayHelp.sliderA1.scaleY=sButt;
			overlayHelp.sliderA1.x=sliderA0.x+sliderWidth/2;
			overlayHelp.sliderA1.y=sliderHeight*0.5;
			
			sliderA1.x=wDimX-162*sButt-sliderWidth;
			sliderA1.y=sliderHeight;
			sliderA1.dimX=sliderWidth;
			sliderA1.dimY=sliderHeight;
			sliderA1.updateSize();
			overlayHelp.sliderA2.scaleX=sButt;
			overlayHelp.sliderA2.scaleY=sButt;
			overlayHelp.sliderA2.x=sliderA1.x+sliderWidth/2;
			overlayHelp.sliderA2.y=sliderHeight*0.5;
			
			sliderA2.x=110*sButt;
			sliderA2.y=wDimY-sliderHeight;
			sliderA2.dimX=sliderWidth;
			sliderA2.dimY=sliderHeight;
			sliderA2.updateSize();
			overlayHelp.sliderA3.scaleX=sButt;
			overlayHelp.sliderA3.scaleY=sButt;
			overlayHelp.sliderA3.x=sliderA2.x+sliderWidth/2;
			overlayHelp.sliderA3.y=wDimY-sliderHeight*0.5;
			
			sliderA3.x=wDimX-110*sButt-sliderWidth;
			sliderA3.y=wDimY-sliderHeight;
			sliderA3.dimX=sliderWidth;
			sliderA3.dimY=sliderHeight;
			sliderA3.updateSize();
			overlayHelp.sliderA4.scaleX=sButt;
			overlayHelp.sliderA4.scaleY=sButt;
			overlayHelp.sliderA4.x=sliderA3.x+sliderWidth/2;
			overlayHelp.sliderA4.y=wDimY-sliderHeight*0.5;
			
			
			buttA.x=0;
			buttA.y=200*sButt;
			buttA.scaleX=sButt;
			buttA.scaleY=sButt;
			overlayHelp.labelA.x=buttA.x+62*sButt;
			overlayHelp.labelA.y=buttA.y;
			overlayHelp.labelA.scaleX=sButt;
			overlayHelp.labelA.scaleY=sButt;


			buttA2.x=0;
			buttA2.y=260*sButt;
			buttA2.scaleX=sButt*0.66;
			buttA2.scaleY=sButt*0.66;
			overlayHelp.labelA2.x=buttA2.x+62*sButt*0.66;
			overlayHelp.labelA2.y=buttA2.y;
			overlayHelp.labelA2.scaleX=sButt*0.66;
			overlayHelp.labelA2.scaleY=sButt*0.66;

			buttA3.x=0;
			buttA3.y=360*sButt;
			buttA3.scaleX=sButt;
			buttA3.scaleY=sButt;
			overlayHelp.labelA3.x=buttA3.x+62*sButt;
			overlayHelp.labelA3.y=buttA3.y;
			overlayHelp.labelA3.scaleX=sButt;
			overlayHelp.labelA3.scaleY=sButt;
			
			buttA4.x=wDimX;
			buttA4.y=260*sButt;
			buttA4.scaleX=sButt*0.66;
			buttA4.scaleY=sButt*0.66;
			overlayHelp.labelA4.x=buttA4.x-62*sButt*0.66-244*sButt*0.66;
			overlayHelp.labelA4.y=buttA4.y;
			overlayHelp.labelA4.scaleX=sButt*0.66;
			overlayHelp.labelA4.scaleY=sButt*0.66;

			buttB.x=wDimX;
			buttB.y=200*sButt;
			buttB.scaleX=sButt;
			buttB.scaleY=sButt;
			overlayHelp.labelB.x=buttB.x-62*sButt-244*sButt;
			overlayHelp.labelB.y=buttB.y;
			overlayHelp.labelB.scaleX=sButt;
			overlayHelp.labelB.scaleY=sButt;

			buttB2.x=wDimX;
			buttB2.y=360*sButt;
			buttB2.scaleX=sButt;
			buttB2.scaleY=sButt;
			overlayHelp.labelB2.x=buttB2.x-62*sButt-244*sButt;
			overlayHelp.labelB2.y=buttB2.y;
			overlayHelp.labelB2.scaleX=sButt;
			overlayHelp.labelB2.scaleY=sButt;

			
			buttC.x=wDimX/2;
			buttC.y=wDimY;
			buttC.scaleX=sButt;
			buttC.scaleY=sButt;
			overlayHelp.labelC.x=buttC.x-244*sButt/2;
			overlayHelp.labelC.y=buttC.y-62*sButt-68*sButt/2;
			overlayHelp.labelC.scaleX=sButt;
			overlayHelp.labelC.scaleY=sButt;

			overlayHelp.labelSS.scaleX=sButt;
			overlayHelp.labelSS.scaleY=sButt;
			overlayHelp.labelSS.x=15+45*sButt/2;
			overlayHelp.labelSS.y=wDimY-overlayHelp.labelSS.height/2-30-45*sButt;
			
			
			overlayHelp.labelReset.scaleX=sButt;
			overlayHelp.labelReset.scaleY=sButt;
			overlayHelp.labelReset.x=wDimX-15-45*sButt/2;
			overlayHelp.labelReset.y=wDimY-overlayHelp.labelReset.height/2-30-45*sButt;

		}

		public function toggleHelp(e=null){
			overlayHelp.visible=!overlayHelp.visible;
			trace("HELP"+overlayHelp.visible);
		}

		function openButtTray(butt,ch,ll=""){
			if(overlayHelp.visible==false){
				if(butt.tray.currentFrame==1) butt.tray.play();
				else butt.tray.gotoAndPlay(4);
				if(ll=="")ll=ns.sceneVary.getValName(ch);
				butt.tray.label.tfVal.text=ll;
			}
		}
		public function buttAOnClick(e){
			ns.sceneVary.next(0);
			openButtTray(buttA,0);
			//game.ns.scene.next("context.color.A");
			//buttA["opt"].gotoAndStop(game.ns.scene.vary.context.color.A.i+1);
		}
		public function buttA2OnClick(e){
			ns.sceneVary.next(4);
			//openButtTray(buttA2);
			//game.ns.GP.context.cont.colorStreamA.shift();
			//game.ns.GP.context.cont.colorStreamLights.shift();
			//buttA["opt"].gotoAndStop(game.ns.scene.vary.context.color.Lights.i+1);
		}
		public function buttA3OnClick(e){
			ns.sceneVary.next(2);
			openButtTray(buttA3,2);
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
			ns.sceneVary.next(1);
			openButtTray(buttB,1);
			//game.ns.scene.next("context.texture.A");
			//buttB["opt"].gotoAndStop(game.ns.scene.vary.context.texture.A.i+1);
		}
		public function buttB2OnClick(e){
			ns.sceneVary.next(3);
			openButtTray(buttB2,3,"Next Back");
			//game.ns.scene.next("space",{"rebuild":true});
			//buttB2["opt"].gotoAndStop(game.ns.scene.vary.space.i+1);
		}
		public function buttCOnClick(e){
			ns.sceneVary.next(6);
			openButtTray(buttC,6);
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
			trace("RESET");
			sliderA0.setVal(0);
			sliderA1.setVal(1);
			sliderA2.setVal(0);
			sliderA3.setVal(1);
			anal.setInput(0,sliderA0.val);
			anal.setInput(1,1-(sliderA1.val));
			anal.setInput(2,sliderA2.val);
			anal.setInput(3,1-(sliderA3.val));
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
			//trace(sliderA0.valDelta);
		}
		
	}
}