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

package martian.milky.medias
{
	import martian.milky.curves.Rectangles;
	import martian.milky.labels.Label;
	import martian.milky.styles.*;
	import martian.milky.core.Utils;
	import martian.milky.interfaces.*;
	
	import flash.display.Sprite;
	import flash.media.*;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Music extends Media implements MilkyObject, MilkyInteractive, MilkyShadow
	{
		private function get controls():Boolean { return $parameters.controls; }
		private function get autoplay():Boolean { return $parameters.autoplay; }
		
		private var $sound:Sound;
		private var $channel:SoundChannel;
		private var $audio:SoundTransform;
		private var $position:Number;
		
		private var $play:Label = new Label( { str: 'DANCE', ts:TextStyle.getDefaultStyle(), ss:ShapeStyle.getDefaultStyle() } );
		private var $pause:Label = new Label( { str: 'BREATHE', ts:TextStyle.getDefaultStyle(), ss:ShapeStyle.getDefaultStyle() } );
		
		private var $left:Rectangles;
		private var $right:Rectangles;
		
		public function get bytesLoaded():uint { return $sound.bytesLoaded; }
		public function get bytesTotal():uint { return $sound.bytesTotal; }
		
		/**
		 * @param	parameters This object holds all the parameters of a mp3 file. It can be omitted for later use of the object.
		 * 
		 * needed :
		 * - url:String	 				=> width of the mp3 file
		 * 
		 * additionnal :
		 * - ds:ShadowStyle 			=> Stylized dropshadow of the current mp3 file
		 */
		public function Music(parameters:Object = null)
		{
			super(parameters);
		}
		
		override public function initialize(parameters:Object):void
		{
			super.initialize(parameters);
			activate();
		}
		
		override public function store(parameters:Object):void
		{
			if (parameters.controls != undefined) { if (Utils.isA(parameters.controls, Boolean)) { $parameters.controls = parameters.controls; } }
			else if ($parameters.controls == null) { $parameters.controls = true; }
			
			if (parameters.autoplay != undefined) { if (Utils.isA(parameters.autoplay, Boolean)) { $parameters.autoplay = parameters.autoplay; } }
			else if ($parameters.autoplay == null) { $parameters.autoplay = false; }
			
			super.store(parameters);
		}
		
		override public function draw(e:MouseEvent = null):void
		{
			var $ss:ShapeStyle = new ShapeStyle( { fillColor:0, fillAlpha:1, lineThick:0 } );
			if (ds != null) { filters = ds.render; };
			
			$sound = new Sound();
				$sound.load(new URLRequest(url));
				$channel = $sound.play();
				$channel.stop();
				
			$audio = new SoundTransform();
				$channel.soundTransform = $audio;
				
			$left = new Rectangles( { width: 20, height: 90, ss: $ss, drawable: false } );
				$left.rotation = 180;
				$left.x = 20;
				$left.y = 90;
				$left.scaleY = $channel.leftPeak;
				addChild($left);
			
			$right = new Rectangles( { width: 20, height: 90, ss: $ss, drawable: false } );
				$right.rotation = 180;
				$right.x = 40;
				$right.y = 90;
				$right.scaleY = $channel.rightPeak;
				addChild($right);
			
			$play.x = - 5;
			$play.y = 90 - $play.height / 2 - 5;
			$play.rotation = - 8 * Math.random();
			
			$pause.x = - 5;
			$pause.y = 90 - $pause.height / 2 - 5;
			$pause.rotation = - 8 * Math.random();
			
			if (controls) { if (!autoplay) { addChild($play); } else { addChild($pause); } }
			if (autoplay) { $channel = $sound.play($position); };
			
			$size = new Point(width, height);
		}
		
		private function enterFrame(e:Event):void
		{
			$left.scaleY = $channel.leftPeak;
			$right.scaleY = $channel.rightPeak;
			
			if (($sound.length != 0) && (int($channel.position / 1000) >= int($sound.length  / 1000))) { stop(); }
		}
		
		/**
		 * @param e This event can be omitted for manual calls.
		 * This function plays the mp3.
		 */
		public function play(e:MouseEvent = null):void
		{
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			if (controls) { removeChild($play); addChild($pause); }
			
			$channel = $sound.play($position);
		}
		
		/**
		 * @param e This event can be omitted for manual calls.
		 * This function pauses the mp3.
		 */
		public function pause(e:MouseEvent = null):void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			if (controls) { removeChild($pause); addChild($play); }
			
			$position = $channel.position;
			$channel.stop();
		}
		
		/**
		 * @param e This event can be omitted for manual calls.
		 * This function stops the mp3.
		 */
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			if (controls) { removeChild($pause); addChild($play); }
			
			$position = 0;
			$channel.stop();
		}
		
		private function volume(e:MouseEvent):void
		{
			var step:Number =  0.1;
			
			e.stopPropagation();
				
				if ((e.delta > 0) && ($audio.volume < 1)) { $audio.volume = Math.round($audio.volume * 10) / 10 + step; }
				if ((e.delta < 0) && ($audio.volume > 0)) { $audio.volume = Math.round($audio.volume * 10) / 10 - step; }
			
			$channel.soundTransform = $audio;
		}
		
		public function activate():void
		{
			$play.addEventListener(MouseEvent.MOUSE_DOWN, play);
			$pause.addEventListener(MouseEvent.MOUSE_DOWN, pause);
			addEventListener(MouseEvent.MOUSE_WHEEL, volume);
		}
		
		public function desactivate():void
		{
			$play.removeEventListener(MouseEvent.MOUSE_DOWN, play);
			$pause.removeEventListener(MouseEvent.MOUSE_DOWN, pause);
			removeEventListener(MouseEvent.MOUSE_WHEEL, volume);
		}
	}
	
}
