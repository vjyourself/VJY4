package vjyourself4{
	import flash.events.Event;
	public dynamic class DynamicEvent extends Event{
		public var data:Object;
		public function DynamicEvent($type:String, d:Object=null,$bubbles:Boolean = false, $cancelable:Boolean = false)
        {
            super($type, $bubbles, $cancelable);
            if(d!=null) data=d;
        }
	
	}
}