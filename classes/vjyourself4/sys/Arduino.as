package vjyourself4.sys{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Stage;
	import vjyourself4.DynamicEvent;
	import vjyourself4.sys.MetaStream;
	import vjyourself4.patt.RandomWeights;
	import flash.display.MovieClip;
	import flash.net.Socket;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	public class Arduino{
		public var mstream:MetaStream;
		public var _meta:Object={name:"Arduino"};
		public var msLevel:Number=3;
		public var input:Object;
		public var ip="192.168.2.66";
		public var port=80;
		
		public var autoCC:Number=0;
		public var autoDelay:Number=0;
		public var autoInd:Number=0;
		public var autoState:String;
		public var autoDelayON:Number=0;
		public var autoDelayOFF:Number=0;
		public var autoPRG:Array;
		public var randomWeights:RandomWeights;
		
		//serial port 5334
		
		var ArduinoConnected=false;
		var sockArdu:Socket = new Socket();
		var reconnectArdu:Number=0;
		var val=0;
		public var map=["A","B","X","Y","LB","RB","LT","RT"];
		
		var cc=0;
		
		function Arduino(){}
		public function log(level,msg){mstream.log(this,level,msg);}
		
		public function init(p:Object){
			if(p.ip!=null) ip=p.ip;
			if(p.port!=null) port=p.port;
			if(p.map!=null) map=p.map;
			if(p.auto!=null){
				autoDelayON=p.auto.delayON*60;
				autoDelayOFF=p.auto.delayOFF*60;
				autoPRG=p.auto.prg;
				randomWeights = new RandomWeights();
				randomWeights.setWeightsO(p.auto.prg);
				
				autoState="OFF";
				autoDelay=autoDelayOFF;
			}
			sockArdu.addEventListener(Event.CONNECT,onConnectArdu,0,0,1);
			sockArdu.addEventListener(Event.CLOSE,onCloseArdu,0,0,1);
			connectArdu();
			
		}
		
		function connectArdu(){log(1,"Arduino Connecting . ... "+ip+":"+port);reconnectArdu=0;sockArdu.connect(ip,port);}
		function onCloseArdu(e){log(1,"Arduino CLOSED");ArduinoConnected=false;reconnectArdu=0;}
		function onConnectArdu(e){log(1,"Arduino CONNECTED");ArduinoConnected=true;}

		
		public function onEF(e=null){
		if(ArduinoConnected){
			cc++;
			if(cc>=6){
				cc=0;
				val=0;
				if(input.def=="gamepad"){
					var s0=input.gamepadManager.getState(0);
					s0.LT=((s0.LeftTrigger>0.3)?1:0);
					s0.RT=((s0.RightTrigger>0.3)?1:0);
					val+=s0[map[0]];
					val+=s0[map[1]]*2;
					val+=s0[map[2]]*4;
					val+=s0[map[3]]*8;
					val+=s0[map[4]]*16;
					val+=s0[map[5]]*32;
					val+=s0[map[6]]*64;
					val+=s0[map[7]]*128;
					
					sockArdu.writeByte(val);
					sockArdu.flush();
				}
				if(input.def=="auto"){
					autoCC+=6;
					if(autoCC>=autoDelay){
						autoCC=0;
						if(autoState=="OFF"){
							autoInd=autoPRG[randomWeights.getNext()].ind;
							autoDelay=autoDelayON;
							autoState="ON";
							var vv=1;
							for(var i=0;i<8;i++){
								if(i==autoInd) val=vv;
								vv*=2;
							}
						}else{
							autoState="OFF";
							autoDelay=autoDelayOFF;
						}
						sockArdu.writeByte(val);
						sockArdu.flush();
					}
				}
				
			}
		}else{
			reconnectArdu++;
			if(reconnectArdu>9*30){
				connectArdu();
			}
		}
		}
	}
}