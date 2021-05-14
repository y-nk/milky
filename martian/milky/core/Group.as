/*
# @author Julien Barbay aka ynk
# 
# Copyright (c) 2008 Julien Barbay aka ynk
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
*/

package martian.milky.core 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import martian.milky.core.Playdoh;
	
	public class Group extends Playdoh
	{
		private var _bounds:Rectangle = new Rectangle;
		public function get bounds():Rectangle { return _bounds; }
		
		private var container:Sprite = new Sprite();
		public function get wrapper():Sprite { return container; }
		
		public function Group(objects:Array) 
		{
			_bounds.left = objects[0].x;
			_bounds.top = objects[0].y;
			_bounds.width = 0;
			_bounds.height = 0;
			
			for (var i:int = 0; i < objects.length; i++)
			{
				if ((objects[i].x - objects[i].object.width / 2) < _bounds.left) { _bounds.left = objects[i].x - objects[i].object.width / 2; }
				if ((objects[i].y - objects[i].object.height / 2) < _bounds.top) { _bounds.top = objects[i].y - objects[i].object.height / 2; }
				
				if ((objects[i].x + objects[i].object.width / 2) > _bounds.right) { _bounds.right = objects[i].x + objects[i].object.width / 2; }
				if ((objects[i].y + objects[i].object.height / 2) > _bounds.bottom) { _bounds.bottom = objects[i].y + objects[i].object.height / 2; }
				
				objects[i].desactivate();
				container.addChild(objects[i]);
			}
			
			for (var j:int = 0; j < objects.length; j++)
			{
				objects[j].x -= _bounds.x + _bounds.width / 2;
				objects[j].y -= _bounds.y + _bounds.height / 2;
			}
			
			super(container, true, true, true, false);
			
			x = _bounds.x + _bounds.width / 2;
			y = _bounds.y + _bounds.height / 2;
		}
	}
	
}