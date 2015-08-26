package vjyourself4.overlay{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import vjyourself4.dson.Eval;
	import vjyourself4.DynamicEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	
	public class OverlayVideo{
		public var ns:Object;
		public var params:Object;
		
		public var vis:Sprite;
		public var vid:Video;
		var nc:NetConnection;
		var nstr:NetStream;
		
		var blends:Array=[
			"normal",
			"add",
			"multiply",
			"difference",
			"screen"
		];
		var blendInd:Number=0;

		var alphas:Array=[
			1,
			0.8,
			0.6,
			0.3,
			0
		];
		var alphaInd:Number=0;
		
		public function OverlayVideo(){}
		
		public function init(){
			vid= new Video();
			nc = new NetConnection();
			nc.connect(null);
			nstr = new NetStream(nc);
			nstr.addEventListener(AsyncErrorEvent.ASYNC_ERROR, eventFunc); 
			nstr.addEventListener("onMetaData", eventFunc); 
			nstr.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			nstr.client = {};
			nstr.client.onMetaData = eventFunc;
			nstr.client.onCuePoint = eventFunc;
			nstr.play(params.src);
			vid.attachNetStream(nstr);
			vid.width=ns.screen.wDimX;
			vid.height=ns.screen.wDimY;

			//var logo= new LogoVJY();
			vis = new Sprite();
			//vis.addChild(logo);
			vis.addChild(vid);
			//vis.blendMode="add";
			//vis.alpha=0.5;
			
		}
		function onStatus(item:Object):void {
        	if (item.info.code == "NetStream.Play.Stop") nstr.seek(0);
        }
		function eventFunc(e):void 
		{ 
   			//ignore metadata error message
		}

		public function onEF(e:DynamicEvent){
			
		}
		public function nextBlend(){
			blendInd=(blendInd+1)%blends.length;
			//vid.blendMode=blends[blendInd];
		}
		public function nextAlpha(){
			alphaInd=(alphaInd+1)%alphas.length;
			vid.alpha=alphas[alphaInd];
		}
		public function onResize(e){
			vid.width=ns.screen.wDimX;
			vid.height=ns.screen.wDimY;
		}
	}
}