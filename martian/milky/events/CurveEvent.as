/*
# @author Julien Barbay aka ynk
# @version 0.1
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

package martian.milky.events
{
	import flash.events.Event;
	
	import martian.milky.curves.CurvePoint;

	public class CurveEvent extends Event
	{
		static public const REMOVE_POINT:String = "remove point";
		
		private var $reference:CurvePoint;
		public function get reference():CurvePoint { return $reference; }
		
		public function CurveEvent(type:String, reference:CurvePoint)
		{
			$reference = reference;
			super(type, true);
		}
	}
}
