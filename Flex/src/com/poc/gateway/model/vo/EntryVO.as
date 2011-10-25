package com.poc.gateway.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class EntryVO extends EventDispatcher
	{
		public function EntryVO(){
			
			timeIN = new TimeVO();
			timeOUT = new TimeVO();
		}
		static public const UPDATED :String = 'UPDATED';
		
		public var cardID : String;
		public var timeIN : TimeVO;
		public var timeOUT : TimeVO;
		public var success : Boolean;
		public var person : PersonVO;
		public var present:Boolean;
		
		public function updated():void{
			this.dispatchEvent(new Event(EntryVO.UPDATED));
		}
	}
	
}