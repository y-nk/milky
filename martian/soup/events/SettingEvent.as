package martian.soup.events 
{
	import flash.events.Event;

	public class SettingEvent extends Event
	{
		static public const BUTTON:String = "button";
		static public const METER:String = "meter";
		static public const SPECTRUM:String = "spectrum";
		static public const RADIO:String = "radio";
		static public const COMBO:String = "combo";
		static public const CHECK:String = "check";
		static public const COLOR:String = "color";
		static public const SPACIO:String = "spacio";
		static public const SHAPE:String = "shape";
		static public const TEXT:String = "text";
		static public const SHADOW:String = "shadow";
		
		public function SettingEvent(type:String) 
		{
			super(type, true);
		}
	}
}