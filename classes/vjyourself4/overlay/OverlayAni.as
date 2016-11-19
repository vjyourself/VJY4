package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import vjyourself4.DynamicEvent;
	
	
	public class OverlayAni{
		public var _debug:Object;
		public var _meta:Object={name:""};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false ,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}
		
		public var ns:Object;
		public var params:Object;
		
		var aniCN:String;
		var aniCNs:Array;
		var aniGroups:Array;
		var aniGroupsInd:Number=0;
		var aniWidth:Number;
		var aniHeight:Number;

		public var vis:Sprite;
		var ani:MovieClip;

		var anis:Array=[];
		//auto cc
		var cc:Number=0;
		var delay:Number=0;
		var auto:Boolean=false;
		var scale:String="fit";
		//var perm:Boolean=false;
		
		public function OverlayAni(){
		}
		
		public function init(){

			if(params.aniCNs!=null) aniCNs=params.aniCNs;
			if(params.aniGroups!=null) aniGroups=params.aniGroups;
			else{
				aniGroups=[[]];
				for(var i=0;i<aniCNs.length;i++)aniGroups[0].push(i);
			}
			if(params.aniCN !=null) aniCNs.push(params.aniCN);
			aniWidth=params.aniWidth;
			aniHeight=params.aniHeight;
			if(params.scale!=null) scale=params.scale;
			if(params.auto!=null){
				auto=true;
				delay=params.auto.delay;
				if(params.auto.cc!=null) cc=params.auto.cc;
			}
			vis = new Sprite();
			for(var i=0;i<aniCNs.length;i++){
				var c:Class = getDefinitionByName(aniCNs[i]) as Class;
				var e={};
				e.ani = new c();
				e.ani.stop();
				vis.addChild(e.ani);
				anis.push(e);
			}
			anisInd=0;
		}
		var anisInd=0;
		public function nextGroup(){
			aniGroupsInd = (aniGroupsInd+1)%aniGroups.length;
		}
		public function play(){
			if(ani!=null) ani.gotoAndStop(ani.totalFrames);
			ani=anis[aniGroups[aniGroupsInd][anisInd]].ani;
			ani.gotoAndPlay(2);
			cc=0;

			anisInd=(anisInd+1)%aniGroups[aniGroupsInd].length;
		}
		
		public function onEF(e:DynamicEvent){
			if(auto){
				cc+=e.delta/1000;
				if(cc>=delay){
					cc=0;
					play();
				}
			}
		}
		
		public function onResize(e){
			var sX=ns.screen.wDimX/aniWidth;
			var sY=ns.screen.wDimY/aniHeight;
			if(scale=="fit"){
				var s=(sX<sY)?sX:sY;
				sX=s;
				sY=s;
			}
			
			for(var i in anis){
				anis[i].ani.scaleX=sX;
				anis[i].ani.scaleY=sY;
				anis[i].ani.x=(ns.screen.wDimX-aniWidth*sX)/2;
				anis[i].ani.y=(ns.screen.wDimY-aniHeight*sY)/2;
			}
			
		}

		public function dispose(){

		}
	}
}