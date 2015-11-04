package vjyourself4.io
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import com.newgonzo.midi.utils.MovieClipSync;
	import com.newgonzo.midi.MIDIClock;
	import com.newgonzo.midi.io.MIDISocketConnection;
	import com.newgonzo.midi.events.MessageEvent;
	import com.newgonzo.midi.messages.Message;
	import com.newgonzo.midi.messages.MessageStatus;
	import com.newgonzo.midi.messages.SystemMessageType;

	import vjyourself4.DynamicEvent;
	import vjyourself4.VJYBase;

	public class MidiManager extends VJYBase
	{
		public var io:IOManager;
		public var params:Object;

		private var connection:MIDISocketConnection;
		public var events:EventDispatcher = new EventDispatcher();
		
		var url:String="127.0.0.1";
		var port:Number=10000;
		public var cc:Array=[];
		public var active:Boolean = false;
		public var connected:Boolean = false;

		public function MidiManager()
		{
			for(var i=0;i<128;i++) cc[i]=0;
		}
		public function init(){
			
			for(var i in params) if(this.hasOwnProperty(i)) this[i]=params[i];
			connection = new MIDISocketConnection();
			//clock = new MIDIClock(connection);
			//sync = new MovieClipSync(clock, this);
			
			// connect
			connection.addEventListener(MessageEvent.MESSAGE,onMsg,0,0,1);
			connection.addEventListener(Event.CONNECT, socketConnected, false, 0, true);
			connection.connect(url, port);
			trace("connecting...");
		}
		var dataSent:Boolean=false;
		public function socketConnected(e){
			connected=true;
		}
		public function setLight(ind,v){
			if(connected){
				dataSent=true;
				connection.socket.writeByte(144);
				connection.socket.writeByte(ind);
				connection.socket.writeByte(v);
			}
		}
		public function onEF(e){
			if(connected){
				if(dataSent){
					dataSent=false;
					connection.socket.flush();
				}
			}
		}
		function onMsg(e:MessageEvent){
			active=true;
		//	trace(e);
			var msg=e.message;
			switch(msg.status){
				case MessageStatus.SYSTEM: 
					//trace("CLOCK");
					switch(msg.type){
						case SystemMessageType.TIMING_CLOCK:events.dispatchEvent(new DynamicEvent("CLOCK",{}));break;
					}
					
				break;
				case MessageStatus.NOTE_ON: 
					//setLight(msg.pitch,1);
					//trace("NOTE_ON "+"channel=" + msg.channel + " pitch=" + msg.pitch);
					
					//trace("NOTE_ON"+"channel=" + msg.channel + " note=" + msg.note + " octave=" + msg.octave + " velocity=" + msg.velocity);
					events.dispatchEvent(new DynamicEvent("NOTE",{val:1,pitch:msg.pitch,channel:msg.channel,note:msg.note,octave:msg.octave,velocity:msg.velocity}));
				break;
				case MessageStatus.NOTE_OFF:
					//setLight(msg.pitch,0); 
					events.dispatchEvent(new DynamicEvent("NOTE",{val:0,pitch:msg.pitch,channel:msg.channel,note:msg.note,octave:msg.octave,velocity:msg.velocity}));
				
					//trace("NOTE_OFF"+"channel=" + msg.channel + " note=" + msg.note + " octave=" + msg.octave + " velocity=" + msg.velocity);break;
				break;
				case MessageStatus.CONTROL_CHANGE:
				cc[msg.data1]=msg.data2/127;
				//trace("CC "+"ch:"+msg.channel+" ind:"+msg.data1+"val:"+msg.data2);
						events.dispatchEvent(new DynamicEvent("CONTROL",{val:msg.data2,channel:msg.channel,ind:msg.data1}));
				break;
			}
		//	trace(MessageStatus.toString(e.message.status));
		}
	}
}