package com.poc.gateway.model
{
	import flash.events.Event;
	
	public class ModelEvent extends Event
	{
		public static const VALID_SWIPE:String = "VALID_SWIPE";
		public static var CURRENT_INSPECTION_CHANGED:String = "CURRENT_INSPECTION_CHANGED";
		public static var EVENT_STARTED:String = "ESTAR";
		public static var EVENT_STOPPED:String = "ESTPD";
		
		public function ModelEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event{
			return new ModelEvent(type );
		}
	}
}