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
	import flash.utils.Timer;
	import martian.milky.events.MediaEvent;
	import martian.milky.events.ResizeEvent;
	import martian.milky.interfaces.*;
	import martian.milky.labels.Label;	
	import martian.milky.curves.Rectangles;
	import martian.milky.medias.MovieClient;
	import martian.milky.styles.*;
	import martian.milky.core.Utils;
	
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.*;
	import flash.geom.Point;
	
	public class Movie extends Media implements MilkyObject, MilkyInteractive, MilkyShadow
	{
		static public const PLAYING:String = "playing";
		static public const PAUSED:String = "paused";
		static public const STOPPED:String = "stopped";
		
		private function get controls():Boolean { return $parameters.controls; }
		private function get autoplay():Boolean { return $parameters.autoplay; }
		
		private function set $status(value:String):void { $parameters.status = value; }
		public function get status():String { return $parameters.status; }
		
		private function get proxy():String { return $parameters.proxy; }
		
		private var $cnx:NetConnection = new NetConnection();
		private var $stream:NetStream;
		private var $audio:SoundTransform = new SoundTransform();
		private var $proxy:String;
		
		private var $play:Label = new Label( { str: 'WATCH', ts:TextStyle.getDefaultStyle(), ss:ShapeStyle.getDefaultStyle() } );
		private var $pause:Label = new Label( { str: 'WAIT', ts:TextStyle.getDefaultStyle(), ss:ShapeStyle.getDefaultStyle() } );
		
		public function get bytesLoaded():uint { return $stream.bytesLoaded; }
		public function get bytesTotal():uint { return $stream.bytesTotal; }
		
		/**
		 * @param	parameters This object holds all the parameters of a .flv file. It can be omitted for later use of the object
		 * 
		 * needed :
		 * - url:String 				=> url of the .flv file
		 * 
		 * additionnal : 
		 * - ds:ShadowStyle 			=> Stylized dropshadow of the current .flv file
		 */	
		
		public function Movie(parameters:Object = null)
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
			if (parameters.proxy != undefined) { if (Utils.isA(parameters.proxy, String)) { $parameters.proxy = parameters.proxy; } }
			
			if (parameters.controls != undefined) { if (Utils.isA(parameters.controls, Boolean)) { $parameters.controls = parameters.controls; } }
			else if ($parameters.controls == null) { $parameters.controls = true; }
			
			if (parameters.autoplay != undefined) { if (Utils.isA(parameters.autoplay, Boolean)) { $parameters.autoplay = parameters.autoplay; } }
			else if ($parameters.autoplay == null) { $parameters.autoplay = false; }
			
			super.store(parameters);
		}
		
		override public function draw(e:MouseEvent = null):void
		{
			if (ds != null) { filters = ds.render; };
			
			if (!$cnx.connected)
			{	
				$cnx.addEventListener(NetStatusEvent.NET_STATUS, connectStream);
				$cnx.connect($parameters.proxy);
			}
		}
		
		private function connectStream(e:NetStatusEvent):void
		{
			switch(e.info.code)
			{
				case "NetConnection.Connect.Success":
					$stream = new NetStream($cnx);
						$stream.addEventListener(NetStatusEvent.NET_STATUS, connectStream);
						
						$stream.client = new MovieClient();
						$stream.soundTransform = $audio;
						$stream.bufferTime = 2;
					
					var video:Video = new Video();
						video.smoothing = true;
						video.attachNetStream($stream);
						addChild(video);
					
					var angle:Number = 4 * Math.random();
					
					$play.x = - 5;
					$play.y = video.height - $play.height / 2 - 5;
					$play.rotation = - angle;
					
					$pause.x = - 5;
					$pause.y = video.height - $pause.height / 2 - 5;
					$pause.rotation = - angle;
					
					$stream.play(url);
					
					$size = new Point(video.width, video.height);
					
					if (controls) { if (!autoplay) { addChild($play); } else { addChild($pause); } }
					break;
				
				case "NetStream.Play.Start":
					
					$status = PLAYING;
					if (autoplay) { play(); }
					else { stop(); }
					
					dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
					break;
				
				case "NetStream.Play.Stop":
					$status = STOPPED;
					stop();
					break;
			}
		}
		
		/**
		 * @param e This event can be omitted for manual calls.
		 * This function launches the movie.
		 */
		public function play(e:MouseEvent = null):void
		{
			if (controls && contains($play)){ removeChild($play); addChild($pause); }
			if (status != PLAYING) { $stream.togglePause(); $status = PLAYING; }
			
			dispatchEvent(new MediaEvent(MediaEvent.PLAYING));
		}
	
		/**
		 * @param e This event can be omitted for manual calls.
		 * This function pauses the movie.
		 */
		public function pause(e:MouseEvent = null):void
		{
			if (controls && contains($pause)) { removeChild($pause); addChild($play); }
			
			$stream.pause();
			$status = PAUSED;
			
			dispatchEvent(new MediaEvent(MediaEvent.PAUSED));
		}
		
		public function stop(e:MouseEvent = null):void
		{
			if (controls && contains($pause)) { removeChild($pause); addChild($play); }
			
			$status = STOPPED;
			rewind();
			
			dispatchEvent(new MediaEvent(MediaEvent.STOPPED));
		}
		
		public function rewind(e:MouseEvent = null):void
		{
			//be kind :)
			$stream.seek(0);
			$stream.pause();
		}
		
		private function volume(e:MouseEvent):void
		{
			e.stopPropagation();
			
		var step:Number = 0.1;
				if ((e.delta > 0) && ($audio.volume < 1)) { $audio.volume = Math.round($audio.volume * 10) / 10 + step; }
				if ((e.delta < 0) && ($audio.volume > 0)) { $audio.volume = Math.round($audio.volume * 10) / 10 - step; }
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