/*
* 
*  Author: Simon Joslin
* 
*  Date: Oct 2008
*
*  If you have any questions, post them on my blog 
*  http://blog.psibaspace.net.au/?p=86
* 
* *******/



package vjyourself4.input
{
	import flash.geom.Point;
	import flash.utils.ByteArray;

	//
	// XBOX360PadState contains the current state of an xbox 360 controller.
	// 
	
	public class XBOX360PadState
	{
		protected 	var 	_playerIndex	:int;		
		public		var 	_connected		:Boolean = false;
		public 		var 	LeftStick		:Point; // range of {x:-1, 1, y:-1, 1}
		public 		var 	RightStick		:Point; // range of {x:-1, 1, y:-1, 1}
		public 		var 	LeftTrigger		:Number; // range of -1, 1
		public 		var 	RightTrigger	:Number; // range of -1, 1
		public 		var 	A				:Boolean; // 0 = Released, 1 = Pressed
		public 		var 	B				:Boolean; // 0 = Released, 1 = Pressed
		public 		var 	X				:Boolean; // 0 = Released, 1 = Pressed
		public 		var 	Y				:Boolean; // 0 = Released, 1 = Pressed
		public 		var 	LB				:Boolean; // 0 = Released, 1 = Pressed
		public 		var 	RB				:Boolean; // 0 = Released, 1 = Pressed
		public 		var 	Start			:Boolean; // 0 = Released, 1 = Pressed
		public 		var 	Back			:Boolean; // 0 = Released, 1 = Pressed
		public		var		Up				:Boolean; // 0 = Released, 1 = Pressed
		public 		var		Down			:Boolean; // 0 = Released, 1 = Pressed
		public 		var		Left			:Boolean; // 0 = Released, 1 = Pressed
		public 		var		Right			:Boolean; // 0 = Released, 1 = Pressed
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		//
		///////////////////////////////////////////////////////////
		public function XBOX360PadState(myPlayerIndex:int):void
		{
			if (myPlayerIndex < 0)
			{
				throw new Error("myPlayerIndex out of range");
			}
			
			_playerIndex = myPlayerIndex;
			reset();
		}
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		// parseBytes requires a ByteArray containing the bytes
		// in the following order:
		/// 16 bit short - 0 = disconnected, 1 = connected
		/// 16 bit short - Left trigger x value ( range between -255 and 255)
		/// 16 bit short - Left trigger y value ( range between -255 and 255)
		/// 16 bit short - Right trigger x value ( range between -255 and 255)
		/// 16 bit short - Right trigger y value ( range between -255 and 255)
		/// 16 bit short - Left trigger (range between 0 and 255)
		/// 16 bit short - Right trigger (range between 0 and 255)
		/// 16 bit short - A Button - 0 = Released, 1 = Pressed
		/// 16 bit short - B Button - 0 = Released, 1 = Pressed
		/// 16 bit short - X Button - 0 = Released, 1 = Pressed
		/// 16 bit short - Y Button - 0 = Released, 1 = Pressed
		/// 16 bit short - L Button - 0 = Released, 1 = Pressed
		/// 16 bit short - R Button - 0 = Released, 1 = Pressed
		/// 16 bit short - Start Button - 0 = Released, 1 = Pressed
		/// 16 bit short - Back Button - 0 = Released, 1 = Pressed
		/// 16 bit short - Up Button - 0 = Released, 1 = Pressed
		/// 16 bit short - Down Button - 0 = Released, 1 = Pressed
		/// 16 bit short - Left Button - 0 = Released, 1 = Pressed
		/// 16 bit short - Right Button - 0 = Released, 1 = Pressed
		//
		// 	if the controller is disconnected the state will be reset
		//
		///////////////////////////////////////////////////////////
		public function parseBytes ( pInputs:ByteArray ):void 
		{
			//0 - is connected
			var isConnected:Boolean = Boolean(pInputs.readShort());
			if (isConnected)
			{
				_connected = true;
			
				// retrieve trigger and stick inputs
				//2
				LeftStick.x = Number(pInputs.readShort()) / 255;
				//4
				LeftStick.y = Number(pInputs.readShort()) / 255;
				//6
				RightStick.x = Number(pInputs.readShort()) / 255;
				//8
				RightStick.y = Number(pInputs.readShort()) / 255;
				//10
				LeftTrigger = Number(pInputs.readShort()) / 255;
				//12
				RightTrigger = Number(pInputs.readShort()) / 255;
				
				// retrieve button inputs
				//14
				A = Boolean(pInputs.readShort());
				//16
				B = Boolean(pInputs.readShort());
				//18
				X = Boolean(pInputs.readShort());
				//20
				Y = Boolean(pInputs.readShort());
				//22
				LB = Boolean(pInputs.readShort());
				//24
				RB = Boolean(pInputs.readShort());
				//26
				Start = Boolean(pInputs.readShort());
				//28
				Back = Boolean(pInputs.readShort());
				
				//30
				Up = Boolean(pInputs.readShort());
				//32
				Down = Boolean(pInputs.readShort());
				//34
				Left = Boolean(pInputs.readShort());
				//36
				Right = Boolean(pInputs.readShort());
			}
			else
			{
				disconnect();
			}

		}
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		// if it was connected, but has now disconnected, reset the state
		///////////////////////////////////////////////////////////
		private function disconnect():void
		{
			
			if (_connected)
				reset();
			
			_connected = false;
		}
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		// resets all values
		///////////////////////////////////////////////////////////
		private function reset():void 
		{
			LeftStick = new Point(0, 0);
			RightStick = new Point(0, 0);
			LeftTrigger = 0.0;
			RightTrigger = 0.0;
			A = false;
			B = false;
			X = false;
			Y = false;
			LB = false;
			RB = false;
			Start = false;
			Back = false;
			Up = false;
			Down = false;
			Left = false;
			Right = false;
		}
		
		///////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////
		// accessors
		///////////////////////////////////////////////////////////
		public function get PlayerIndex():int {	return _playerIndex;	}
		public function get Connected():Boolean {	return _connected;	}
	}
	
}