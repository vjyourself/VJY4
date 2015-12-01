package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import vjyourself4.DynamicEvent;
	import vjyourself4.dson.TransJson;
	
	
	public class OverlayAniTrans{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var wDimX:Number=960;
		public var wDimY:Number=540;
		public var ns:Object;
		public var params:Object;
		//var rhythm;
		//var tackCounter:Number;
		
		public var deltaControl:Boolean=true;

		var aniCN:String;
		var aniWidth:Number;
		var aniHeight:Number;
		var aniFrame:Number;
		var aniTime:Number;

		public var vis:Sprite;
		var ani:MovieClip;
		var channels:Array;

		//auto cc
		var cc:Number=0;
		var delay:Number=0;
	
		public var def:Object={
			length:10,
			trans:["none"],
			transInd:0
		}
		var ind:Number=-1;
		//var perm:Boolean=false;

		public var inputNum:int=0;

		var aniOn:Boolean=false;
		
		var i:int=0;

		public function OverlayAniTrans(){
		}
		
		public function init(){
		//	rhythm = ns._sys.music.meta.rhythm;
		//	tackCounter=rhythm.counter[1];
			
			if(params.def!=null) for(var i in params.def) def[i]=params.def[i];
			vis = new Sprite();
			channels = TransJson.clone(params.channels)
			inputNum=channels.length;
			
		}
		
		public function setInput(ch,val){}

		public function stopAni(){
			if(aniOn){
				aniOn=false;
				ani.stop();
				vis.removeChild(ani);
			}
		}
		public function trig(p=null){
			stopAni();
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
				var ch=channels[ind];
				var c:Class = getDefinitionByName(ch.cn) as Class;
				
				var trans:String="none";
				if(ch.trans!=null) trans=ch.trans;
				else{
					trans=def.trans[def.transInd];
					def.transInd=(def.transInd+1)%def.trans.length;
				}
				if(trans=="none"){
					ani = new c();
					ani.x=wDimX/2;
					ani.y=wDimY/2;
					vis.addChild(ani);
				}else{
					var ccc=new c();
					var cTrans:Class = getDefinitionByName("Trans"+trans) as Class;
					ani = new cTrans();
					ani.scaleX=wDimX/960;
					ani.scaleY=wDimY/540;
					ani.e.addChild(ccc);
					vis.addChild(ani);
					if(deltaControl){
						ani.stop();
						aniFrame=1;
						aniTime=0;
					}
				}
				aniOn=true;
			}
		}

		public function stop(){
		
		}
		
		public function onEF(e:DynamicEvent){
			trace("DELTA "+e.data.mul);
			if(deltaControl){
				if(aniOn){
					aniTime+=e.data.delta;
					aniFrame=Math.floor(aniTime/(1000/60))+1;
					if(aniFrame>=ani.totalFrames){
						aniFrame=ani.totalFrames;
						aniOn=false;
						ani.stop();
						vis.removeChild(ani);
					}else{
						ani.gotoAndStop(aniFrame);
					}

				}
			}
		}
		
		public function onResize(e){
			
			wDimX=ns._glob.screen.wDimX;
			wDimY=ns._glob.screen.wDimY;
			/*
			for(i=0;i<channels.length;i++){
				ch=channels[i];
				switch(ch.scale){
					case "set":
						ch.vis.resize(wDimX,wDimY);
					break;
					case "stretch":
						sX=wDimX/ch.width;
						sY=wDimY/ch.height;
						ch.vis.scaleX=sX;
						ch.vis.scaleY=sY;
					break;
					case "fit":
					default:
						sX=wDimX/ch.width;
						sY=wDimY/ch.height;
						var s=(sX<sY)?sX:sY;
						ch.vis.scaleX=s;
						ch.vis.scaleY=s;
					break;
				}
			}*/
		}

		public function dispose(){

		}
	}
}