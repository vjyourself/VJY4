package vjyourself4.games{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import vjyourself4.DynamicEvent;
	
	
	public class OverlayArtist{
		public var ns:Object;
		public var params:Object;
		
		var guiCN:String;
		//var aniWidth:Number;
		//var aniHeight:Number;

		var artistCyc:String="";
		var artistMeta:Object;
		var spacePrg:String="";
		public var vis:Sprite;
		//var ani:MovieClip;

		//auto cc
		//var cc:Number=0;
		//var delay:Number=0;
		//var auto:Boolean=false;
		//var scale:String="fit";
		
		public function OverlayArtist(){
		}
		
		public function init(){
			guiCN=params.guiCN;
			/*aniWidth=params.aniWidth;
			aniHeight=params.aniHeight;
			if(params.scale!=null) scale=params.scale;
			if(params.auto!=null){
				auto=true;
				delay=params.auto.delay;
				if(params.auto.cc!=null) cc=params.auto.cc;
			}*/
			//vis = new Sprite();
			var c:Class = getDefinitionByName(guiCN) as Class;
			vis = new c();
			//ani.stop();
			//vis.addChild(ani);
			
		}
		
		public function onEF(e:DynamicEvent){
			if(artistCyc!=ns.scene.state.context.texture.A){
				artistCyc=ns.scene.state.context.texture.A;
				artistMeta=ns.cloud.C3D.NS[artistCyc][0].meta;
				vis["tfName"].text=artistMeta.name;
				var loc="";
				if(artistMeta.city!="")loc=artistMeta.city+", "+artistMeta.country;
				else loc=artistMeta.country;
				vis["tfCity"].text=loc;
			}
			/*
			if(spacePrg!=ns.scene.state.space){
				spacePrg=ns.scene.state.space;
				//artistMeta=ns.cloud.C3D.NS[artistCyc][0].meta;
				vis["tfSpace"].text=spacePrg;
				//vis["tfCity"].text=artistMeta.city+", "+artistMeta.country;
			}*/
		/*	if(auto){
				cc+=e.delta/1000;
				if(cc>=delay){
					cc=0;
					play();
				}
			}*/
		}
		
		public function onResize(e){
			/*var sX=ns.screen.wDimX/aniWidth;
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
			}
			*/
			var s=ns.screen.wDimY/540;
			//if(s>1.5) s*=0.8;
			vis.x=0;
			vis.y=ns.screen.wDimY;
			vis.scaleX=s;
			vis.scaleY=s;
		}
	}
}