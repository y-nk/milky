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
	import martian.milky.core.ExtendedScene;
	import martian.milky.core.Utils;	
	import martian.milky.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Point;
	
	import gs.*;
	import gs.easing.*;
	
	public class SuperScene extends Sprite
	{
		private var $world:Sprite = new Sprite;
		
		private var $dragScene:ExtendedScene = new ExtendedScene(true, false, false);
		private var $rotateScaleScene:ExtendedScene = new ExtendedScene(false, true, true);
		
		public function get draggable():Boolean { return $dragScene.draggable; }
		public function set draggable(value:Boolean):void
		{
			$dragScene.draggable = value;
		}
		
		public function get rotatable():Boolean { return $rotateScaleScene.rotatable; }
		public function set rotatable(value:Boolean):void
		{
			$rotateScaleScene.rotatable = value;
		}
		
		public function get scalable():Boolean { return $rotateScaleScene.scalable; }
		public function set scalable(value:Boolean):void
		{
			$rotateScaleScene.scalable = value;
		}
		
		public function SuperScene() 
		{
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			addChild($rotateScaleScene);
				$rotateScaleScene.x = stage.stageWidth / 2;
				$rotateScaleScene.y = stage.stageHeight / 2;
				$rotateScaleScene.addChild($dragScene);
					$dragScene.addChild($world);
					
			activate();
			
			stage.addEventListener(Event.RESIZE, adjust);
		}
		
		private function adjust(e:Event):void { $rotateScaleScene.x = stage.stageWidth / 2;
												$rotateScaleScene.y = stage.stageHeight / 2; }
		
		public function move(e:TweenEvent):void
		{
			var parameters:Object = e.move, time:Number, tween1:Object = {}, tween2:Object = {};
			
			if ((parameters.d != undefined) && (Utils.isA(parameters.d, Number))) { time = parameters.d; } else { time = 1; }
			
			if ((parameters.x != undefined) && (Utils.isA(parameters.x, Number))) { tween1.x = parameters.x; }
			if ((parameters.y != undefined) && (Utils.isA(parameters.y, Number))) { tween1.y = parameters.y; }
			if ((parameters.r != undefined) && (Utils.isA(parameters.r, Number))) { tween2.rotation = parameters.r; }
			if ((parameters.s != undefined) && (Utils.isA(parameters.s, Number))) { tween2.scaleX = tween2.scaleY = parameters.s; }
			
			tween1.ease = tween2.ease = Quad.easeInOut;
			
			if ((parameters.x != undefined) || (parameters.y != undefined))	{ TweenMax.to($dragScene, time, tween1); }
			if ((parameters.r != undefined) || (parameters.s != undefined)) { TweenMax.to($rotateScaleScene, time, tween2); }
		}
		
		override public function get x():Number { return $dragScene.x; }
		override public function set x(num:Number):void { $dragScene.x = num; }
		
		override public function get y():Number { return $dragScene.y; }
		override public function set y(num:Number):void { $dragScene.y = num; }
		
		override public function get rotation():Number { return $rotateScaleScene.rotation; }
		override public function set rotation(num:Number):void { $rotateScaleScene.rotation = num; }
		
		override public function get scaleX():Number { return $rotateScaleScene.scaleX; }
		override public function set scaleX(num:Number):void { $rotateScaleScene.scaleX = num; }
		
		override public function get scaleY():Number { return $rotateScaleScene.scaleY; }
		override public function set scaleY(num:Number):void { $rotateScaleScene.scaleY = num; }
		
		override public function get graphics():Graphics { return $world.graphics; }
		
		public function get mouse():Point
		{
			var rotationRad:Number = $rotateScaleScene.rotation * Math.PI / 180;
			var realX:Number = $rotateScaleScene.x + ($world.mouseX + $dragScene.x) * $rotateScaleScene.scaleX * Math.cos(rotationRad) - ($world.mouseY + $dragScene.y) * $rotateScaleScene.scaleX * Math.sin(rotationRad);
			var realY:Number = $rotateScaleScene.y + ($world.mouseX + $dragScene.x) * $rotateScaleScene.scaleX * Math.sin(rotationRad) + ($world.mouseY + $dragScene.y) * $rotateScaleScene.scaleX * Math.cos(rotationRad);
		
			return new Point(realX, realY);
		}
		
		override public function globalToLocal(point:Point):Point 
		{
			point.x -= $rotateScaleScene.x;
			point.y -= $rotateScaleScene.y;
			
			point.x /= $rotateScaleScene.scaleX;
			point.y /= $rotateScaleScene.scaleY;
			
			var rotationRad:Number = - $rotateScaleScene.rotation * Math.PI / 180;
			var realX:Number = ((point.x * Math.cos(rotationRad) - point.y * Math.sin(rotationRad)) - $dragScene.x);
			var realY:Number = ((point.x * Math.sin(rotationRad) + point.y * Math.cos(rotationRad)) - $dragScene.y);
		
			return new Point(realX, realY);
		}
		
		public function get numObjects():int { return $world.numChildren; }
		
		public function addObject(object:DisplayObject, animated:Boolean = true):void
		{
			if (!(object is ExtendedScene))
			{
				$world.addChild(object); 
				$world.setChildIndex(object, $world.numChildren - 1);
				
				var xy:Point = globalToLocal(new Point(stage.stageWidth / 2, stage.stageHeight / 2));
				
				if (animated) { TweenMax.from(object, 2, { x:xy.x, y:xy.y, rotation: -360 + (object.rotation * 2), scaleX:0, scaleY:0, alpha:0, ease:Circ.easeOut } ); }
			}
			else { if (!contains($rotateScaleScene)) { addChild(object); } }
		}
		
		public function addObjectAt(child:DisplayObject, index:int):DisplayObject { return $world.addChildAt(child, index); }
		
		public function removeObject(child:DisplayObject):DisplayObject { return $world.removeChild(child); }
		
		public function getObjectAt(index:int):DisplayObject { return $world.getChildAt(index); }
		public function getObjectByName(name:String):DisplayObject { return $world.getChildByName(name); }
		public function getObjectIndex(child:DisplayObject):int { return $world.getChildIndex(child); }
		
		public function setObjectIndex(child:DisplayObject, index:int):void { $world.setChildIndex(child, index); }
		public function swapObjects(child1:DisplayObject, child2:DisplayObject):void { $world.swapChildren(child1, child2); }
		public function swapObjectsAt(index1:int, index2:int):void { $world.swapChildrenAt(index1, index2); }
		
		public function containsObject(child:DisplayObject):Boolean { return $world.contains(child); }
		
		public function activate():void
		{
			$dragScene.activate();
			$rotateScaleScene.activate();
			
			addEventListener(TweenEvent.MOVE, move);
		}
		
		public function desactivate():void
		{
			$dragScene.desactivate();
			$rotateScaleScene.desactivate();
			
			removeEventListener(TweenEvent.MOVE, move);
		}
	}
}