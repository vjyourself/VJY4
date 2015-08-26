package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import vjyourself4.DynamicEvent;
	
	
	public class OverlayAniChannels{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		
		var aniCN:String;
		var aniWidth:Number;
		var aniHeight:Number;

		public var vis:Sprite;
		var ani:MovieClip;
		var channels:Array;

		//auto cc
		var cc:Number=0;
		var delay:Number=0;
		var auto:Boolean=false;
		var scale:String="fit";
		//var perm:Boolean=false;

		public var inputNum:int=0;
		
		var i:int=0;

		public function OverlayAniChannels(){
		}
		
		public function init(){
			/*
			aniCN=params.aniCN;
			aniWidth=params.aniWidth;
			aniHeight=params.aniHeight;
			if(params.scale!=null) scale=params.scale;
			if(params.auto!=null){
				auto=true;
				delay=params.auto.delay;
				if(params.auto.cc!=null) cc=params.auto.cc;
			}
			var c:Class = getDefinitionByName(aniCN) as Class;
			ani = new c();
			ani.stop();
			vis.addChild(ani);
			*/
			vis = new Sprite();
			channels=[];
			var c:Class;
			var ch:Object;
			var ani;
			var e:Object;
			for(i=0;i<params.channels.length;i++){
				ch=params.channels[i];
				c = getDefinitionByName(ch.cn) as Class;
				ani = new c();
				ani.stop();
				vis.addChild(ani);
				e={vis:ani,type:ch.type,scale:ch.scale};
				if(ch.width!=null) e.width=ch.width;
				if(ch.height!=null) e.height=ch.height;
				channels.push(e);
			}
			inputNum=channels.length;
			
		}
		
		public function setInput(chInd,val){
			var ch=channels[chInd];
			switch(ch.type){
				case "timeline":ch.vis.gotoAndStop(Math.floor((ch.vis.totalFrames-1)*val)+1);break;
				case "onoff":ch.vis.gotoAndStop(val>0.1?2:1);break;
				case "custom":ch.vis.setInput(0,val);break;
			}
			
		}
		/*
		public function play(){
			ani.gotoAndPlay(2);
			cc=0;
		}*/

		/*
		public function onEF(e:DynamicEvent){
			if(auto){
				cc+=e.delta/1000;
				if(cc>=delay){
					cc=0;
					play();
				}
			}
		}*/
		
		public function onResize(e){
			var ch:Object;
			var sX:Number;
			var sY:Number;
			var sDimX=ns._glob.screen.wDimX;
			var sDimY=ns._glob.screen.wDimY;
			for(i=0;i<channels.length;i++){
				ch=channels[i];
				switch(ch.scale){
					case "set":
						ch.vis.resize(sDimX,sDimY);
					break;
					case "stretch":
						sX=sDimX/ch.width;
						sY=sDimY/ch.height;
						ch.vis.scaleX=sX;
						ch.vis.scaleY=sY;
					break;
					case "fit":
					default:
						sX=sDimX/ch.width;
						sY=sDimY/ch.height;
						var s=(sX<sY)?sX:sY;
						ch.vis.scaleX=s;
						ch.vis.scaleY=s;
					break;
				}
			}
		}

		public function dispose(){

		}
	}
}