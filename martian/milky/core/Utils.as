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
	import martian.milky.curves.*;
	import martian.milky.labels.*;
	import martian.milky.medias.*;
	import martian.milky.special.*;
	import martian.milky.styles.*;
	
	import flash.utils.describeType;
	
	public class Utils 
	{
		public function Utils() { throw new Error("Utils should not be instanciated"); }
		
		static public function isA(value:*, type:Class):Boolean
		{
			if (value is type) { return true;  }
			else { throw new EvalError("Invalid type value, expected " + type); }
			
			return false;
		}
		
		static public function randomInteger(max:int):Number { return int(Math.random() * max); }
		
		static public function toBoolean(str:String):Boolean
		{
			if (str == "true") { return true; }
			else { return false; }
		}
		
		static public function exists(obj:*):Boolean
		{
			if ((obj != undefined) && (obj != null)) { return true; }
			else { return false; }
		}
		
		static public function describeClass(element:*):String
		{
			var type:String = describeType(element).@name.toXMLString();
			return type.substring(type.search("::") + 2);
		}
		
		//this forces flash to add all the classes of milky in the swf. (comment to bury un-necessary classes)
		static private function includingClasses():void	{ var curvegon:Curvegon, ellipse:Ellipse, line:Line, rectangles:Rectangles, regularpolygon:Regularpolygon, roundrectangles:Roundrectangles, starpolygon:Starpolygon, triangle:Triangle, label:Label, link:Link, mover:Mover, flash:Flash, image:Image, movie:Movie, music:Music, webcam:Webcam, ss:ShapeStyle, ts:TextStyle, ds:ShadowStyle; }

	}
}