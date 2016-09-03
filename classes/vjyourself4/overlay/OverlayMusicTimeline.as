package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import vjyourself4.DynamicEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class OverlayMusicTimeline{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		var beat;
		var timeline;
		var musicMeta;

		public var params:Object;
		var tfStruct:TextField;
		var tfSection:TextField;
		var tfTime:TextField;
		
		

		public var vis:Sprite;

		var signTrig:MovieClip;
		

		var channels:Array=[{ch:3,steps:16}];
		var visGap:Number=50;

		var TestSign:Class;
		var HelpBox:Class;
		
		public function OverlayMusicTimeline(){
		}
		
		public function init(){
			
			HelpBox = getDefinitionByName("OverlayMuscMetaTimelineCtrl") as Class;
			TestSign = getDefinitionByName("OverlayMusicTestSign") as Class;
			timeline=ns.sys.music.meta.timeline;
			beat=ns.sys.music.meta.beat;
			musicMeta=ns.sys.music.meta;

			
			
			vis = new Sprite();
			vis.x=visGap;
			vis.y=0;

			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			tf.bold = true;
			tf.font = "Arial"
			tf.color = 0xffffff;
	
			tfTime = new TextField();
			tfTime.width=100;
			tfTime.y=30;
			tfTime.x=-18;
			tfTime.defaultTextFormat = tf;
			vis.addChild(tfTime);

			var tf2:TextFormat = new TextFormat();
			tf2.size = 28;
			tf2.bold = true;
			tf2.font = "Arial"
			tf2.color = 0xffffff;

			tfStruct = new TextField();
			tfStruct.width=100;
			tfStruct.y=75;
			tfStruct.x=-18;
			tfStruct.defaultTextFormat = tf2;
			vis.addChild(tfStruct);

			tfSection = new TextField();
			tfSection.width=300;
			tfSection.y=75;
			tfSection.x=80;
			tfSection.defaultTextFormat = tf2;
			vis.addChild(tfSection);

	
			for(var i=0;i<channels.length;i++){
				var e=channels[i];
				e.val=0;
				e.signs=[];
				for(var ii=0;ii<e.steps;ii++){
					var s=new TestSign();
					s.y=i*visGap+visGap*3;s.x=ii*visGap;
					s.width=visGap/4*3;
					s.height=visGap/4*3;
					vis.addChild(s);
					s.tfInd.text=""+(ii+1);
					if(ii==0) s.gotoAndStop(2); else s.stop();
					e.signs.push(s);
				}
			}
			signTrig = new TestSign();
			signTrig.gotoAndStop(2);
			signTrig.scaleX=2;
			signTrig.scaleY=2;
			signTrig.x=100;
			signTrig.y=500;
			//vis.addChild(signTrig);
			var helpBox = new HelpBox();
			vis.addChild(helpBox);
			helpBox.x=0;
			helpBox.y=visGap*4;
		}
		
		public function onEF(e:DynamicEvent){
			tfStruct.text=(timeline.structInd+1)+" . "+(timeline.beatInd+1);
			tfSection.text=timeline.struct[timeline.structInd].n;
			var m:Number = Math.floor(musicMeta.pos/1000/60);
			var s:Number = Math.floor((musicMeta.pos/1000-m*60)*10)/10;
			tfTime.text=m+" : "+s+( (s==Math.floor(s))?".0":"" );

			//STRUCT
				var chh=channels[0];
				if(chh.val!=timeline.beatInd){
					chh.signs[chh.val].gotoAndStop(1);
					chh.val=timeline.beatInd;
					chh.signs[chh.val].gotoAndStop(2);	
				}
			

			/*
			//General Channels
			for(var i=0;i<channels.length;i++){
				var chh=channels[i];
				if(chh.val!=beat.counter[chh.ch]){
					chh.signs[chh.val].gotoAndStop(1);
					chh.val=beat.counter[chh.ch];
					chh.signs[chh.val].gotoAndStop(2);	
				}
			}*/

			/*
			// Analoug
			var ss=beat.chA[0].val*2;
			signTrig.scaleX=ss;
			signTrig.scaleY=ss;
			*/
		}
		
		public function onResize(e){
			/*
			var sX=ns.screen.wDimX/aniWidth;
			var sY=ns.screen.wDimY/aniHeight;
			switch(scale){
				case "stretch":
				ani.scaleX=sX;
				ani.scaleY=sY;
				break;
				case "fit":
				default:
				var s=(sX<sY)?sX:sY;
				ani.scaleX=s;
				ani.scaleY=s;
				break;
			}*/
			
		}

		public function dispose(){

		}
	}
}