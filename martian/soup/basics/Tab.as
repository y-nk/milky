package martian.soup.basics
{
	import martian.milky.curves.*;
	import martian.milky.labels.*;
	import martian.milky.styles.*;
	
	import flash.display.Sprite;
	
	public class Tab extends Sprite
	{
		private var $margin:int = 10;
		
		public function Tab() {}
		
		public function addComponent(component:Sprite):void
		{
			if (numChildren == 0)
			{
				addChild(component);
				component.y = $margin;
			}
			else
			{
				var last:* = getChildAt(numChildren - 1);
				addChild(component);
				component.y = int(last.y + last.height + $margin); 
			}
			
			component.x = $margin;
		}
	}	
}