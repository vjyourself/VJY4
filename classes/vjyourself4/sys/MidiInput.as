package vjyourself4.sys
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	import com.newgonzo.midi.utils.MovieClipSync;
	import com.newgonzo.midi.MIDIClock;
	import com.newgonzo.midi.io.MIDISocketConnection;
	import com.newgonzo.midi.events.MessageEvent;
	import com.newgonzo.midi.messages.Message;
	import com.newgonzo.midi.messages.MessageStatus;
	import com.newgonzo.midi.messages.SystemMessageType;

	import vjyourself4.DynamicEvent;
	
	public class MidiInput
	{
		private var connection:MIDISocketConnection;
		public var events:EventDispatcher = new EventDispatcher();
		public var params:Object;

		public function MidiInput()
		{
			
		}
		public function init(){
			connection = new MIDISocketConnection();
			//clock = new MIDIClock(connection);
			//sync = new MovieClipSync(clock, this);
			
			// connect
			connection.addEventListener(MessageEvent.MESSAGE,onMsg,0,0,1);
			connection.connect("127.0.0.1", 10000);
			trace("connecting...");
		}
		function onMsg(e:MessageEvent){
			trace(e);
			var msg=e.message;
			switch(msg.status){
				case MessageStatus.SYSTEM: 
					//trace("CLOCK");
					switch(msg.type){
						case SystemMessageType.TIMING_CLOCK:events.dispatchEvent(new DynamicEvent("CLOCK",{}));break;
					}
					
				break;
				case MessageStatus.NOTE_ON: 
					//trace("NOTE_ON"+"channel=" + msg.channel + " note=" + msg.note + " octave=" + msg.octave + " velocity=" + msg.velocity);
					events.dispatchEvent(new DynamicEvent("NOTE",{val:1,channel:msg.channel,note:msg.note,octave:msg.octave,velocity:msg.velocity}));
				break;
				case MessageStatus.NOTE_OFF: 
					events.dispatchEvent(new DynamicEvent("NOTE",{val:0,channel:msg.channel,note:msg.note,octave:msg.octave,velocity:msg.velocity}));
				
					//trace("NOTE_OFF"+"channel=" + msg.channel + " note=" + msg.note + " octave=" + msg.octave + " velocity=" + msg.velocity);break;
				break;
				case MessageStatus.CONTROL_CHANGE:
						events.dispatchEvent(new DynamicEvent("CONTROL",{val:msg.data2,channel:msg.channel,ind:msg.data1}));
				break;
			}
			trace(MessageStatus.toString(e.message.status));
		}
	}
}