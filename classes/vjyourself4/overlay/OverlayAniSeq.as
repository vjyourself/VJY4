package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import vjyourself4.DynamicEvent;
	
	
	public class OverlayAniSeq{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		var rhythm;
		var tackCounter:Number;
		
		var aniCN:String;
		var aniWidth:Number;
		var aniHeight:Number;

		public var vis:Sprite;
		var ani:MovieClip;
		var channels:Array;

		//auto cc
		var cc:Number=0;
		var delay:Number=0;
		public var state:String="";
		public var defLength:Number=10;
		
		var ind:Number=-1;
		//var perm:Boolean=false;

		public var inputNum:int=0;
		
		var i:int=0;

		public function OverlayAniSeq(){
		}
		
		public function init(){
			rhythm = ns._sys.music.meta.rhythm;
			tackCounter=rhythm.counter[1];
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
			if(params.defLength!=null) defLength=params.defLength;
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
				ani.visible=false;
				vis.addChild(ani);
				e={vis:ani,type:ch.type,scale:ch.scale,cn:ch.cn};
				if(ch.width!=null) e.width=ch.width;
				if(ch.height!=null) e.height=ch.height;
				if(ch.length!=null) e.length=ch.length; else e.length=defLength;
				channels.push(e);
			}
			inputNum=channels.length;
			
		}
		
		public function setInput(ch,val){}

		public function trig(p=null){
			if(ind>=0) channels[ind].vis.visible=false;
			if(p==null){
				ind=(ind+1)%channels.length;
			}else{
				if(p is String){
					for(var ii=0;ii<channels.length;ii++) if(channels[ii].cn==p) ind=ii;
				}
				if(p is Number){
					ind=p%channels.length;
				}
			}
			if((ind>=0)&&(ind<channels.length)){
				channels[ind].vis.visible=true;
				switch(channels[ind].type){
				case "stepper":channels[ind].vis.gotoAndStop(1);break;
				case "timeline":channels[ind].vis.gotoAndPlay(1);break;
				}
				state="on";
				cc=0;
				delay=channels[ind].length;
			}
		}

		public function stop(){
			if(state=="on") cc=delay;
		}
		
		public function onEF(e:DynamicEvent){
			if(state=="on"){
				cc+=e.delta/1000;
				if(channels[ind].type=="stepper") if(tackCounter!=rhythm.counter[1]){ channels[ind].vis.gotoAndStop(rhythm.counter[1]+1);tackCounter=rhythm.counter[1];}
				if(cc>=delay){
					cc=0;
					channels[ind].vis.visible=false;
					state="off";
				}
			}
		}
		
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