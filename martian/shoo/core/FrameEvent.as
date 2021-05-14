package martian.shoo.core
{	
	import flash.events.Event;
	
	public class FrameEvent extends Event
	{
		static public const ENTER:String = "enter";
		
		public function FrameEvent(type:String)
		{
				super(type);
		}
	}
}