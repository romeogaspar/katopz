package com.cutecoma.events
{
	import flash.events.Event;

	public class FormEvent extends Event
	{
		// _____________________ While Edit _____________________

		// data is incomplete
		public static const INCOMPLETE:String = "cc-form-incomplete";

		// data out is invalid
		public static const INVALID:String = "cc-form-invalid";

		// data out is valid
		public static const VALID:String = "cc-form-valid";
		
		// submit
		public static const SUBMIT:String = "cc-form-submit";
		
		// data in
		public static const GET_SERVER_DATA:String = "cc-form-data";

		// _____________________ Form Data _____________________

		public var data:*;

		public function FormEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}

		override public function clone():Event
		{
			return new FormEvent(type, data, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("FormEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}