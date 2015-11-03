package vjyourself4.io.gamepad
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import vjyourself4.DynamicEvent;
	
	public class GamepadState
	{
		public var events:EventDispatcher = new EventDispatcher;
		public var state={};
		public var ind:int=0;
		public var changed:Boolean=false;
		public var fireGlobal:Boolean=false;
		
		public function GamepadState():void
		{
			reset();
		}
		
		private var buttons=["A","B","X","Y","LB","RB","Start","Back","Up","Down","Left","Right"];
		public function setState(n){
			
			//check for events
			changed=false;
			for(var i=0;i<buttons.length;i++)if(!state[buttons[i]]&&n[buttons[i]]) { 
				events.dispatchEvent(new Event("Gamepad"+ind+"_"+buttons[i]));
				if(fireGlobal) events.dispatchEvent(new DynamicEvent("GamepadButton",{ind:ind,button:buttons[i]}));
				events.dispatchEvent(new DynamicEvent("GamepadButton"+ind,{ind:ind,button:buttons[i]}));
				changed=true;
			}
			changed=changed||(state.LeftTrigger!=n.LeftTrigger);
			changed=changed||(state.RightTrigger!=n.RightTrigger);
			changed=changed||(state.LeftStick.x!=n.LeftStick.x);
			changed=changed||(state.LeftStick.y!=n.LeftStick.y);
			changed=changed||(state.RightStick.x!=n.RightStick.x);
			changed=changed||(state.RightStick.y!=n.RightStick.y);
			if(changed) events.dispatchEvent(new Event("CHANGE"));
				
			//copy values
			for(var i in n) state[i]=n[i];
		}  
		private function reset(s=null):void 
		{
			if(s==null) s=state;
			s.LeftStick = { x:0, y:0 },
			
			s.RightStick = { x:0, y:0 };
			s.LeftTrigger = 0;
			s.RightTrigger = 0;
			s.A = false;
			s.B = false;
			s.X = false;
			s.Y = false;
			s.LB = false;
			s.RB = false;
			s.Start = false;
			s.Back = false;
			s.Up = false;
			s.Down = false;
			s.Left = false;
			s.Right = false;
		}
		
		public static function merge(a:Object,b:Object):Object{
			var c={};
			c.LeftTrigger=Math.min(a.LeftTrigger+b.LeftTrigger,1);
			c.RightTrigger=Math.min(a.RightTrigger+b.RightTrigger,1);
			
			c.LeftStick={x:Math.min(a.LeftStick.x+b.LeftStick.x,1),y:Math.min(a.LeftStick.y+b.LeftStick.y,1)};
			c.RightStick={x:Math.min(a.RightStick.x+b.RightStick.x,1),y:Math.min(a.RightStick.y+b.RightStick.y,1)};
			c.A=a.A || b.A;
			c.B=a.B || b.B;
			c.X=a.X || b.X;
			c.Y=a.Y || b.Y;
			c.LB=a.LB || b.LB;
			c.RB=a.RB || b.RB;
			c.Start=a.Start || b.Start;
			c.Back=a.Back || b.Back;
			c.Up=a.Up || b.Up;
			c.Down=a.Down || b.Down;
			c.Left=a.Left || b.Left;
			c.Right=a.Right || b.Right;
			
			return c;
		}
		
		
	}
	
}