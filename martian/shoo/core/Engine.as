package martian.shoo.core
{
	import martian.milky.labels.*;
	import martian.milky.styles.*;
	
	import martian.soup.utils.ExtendedFonts;
	
	import martian.shoo.basics.*;
	import martian.shoo.core.*;
	import martian.shoo.utils.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.geom.Point;
	
	public class Engine
	{
		 const PRECISION:Number = Math.pow(10, -50);
		
		static public var playing:Boolean = false;
		static public function get PLAYING():Boolean { return playing; }
		
		static public var paused:Boolean = false;
		static public function get PAUSED():Boolean { return paused; }
		
		static public var stopped:Boolean = true;
		static public function get STOPPED():Boolean { return stopped; }
		
		 var frame:int = 0;
		static public function get time():Number { return Math.round(frame  * 10000 / scene.stage.frameRate) / 10000; }
		
		 var scene:Sprite;
		static public function get environment():Sprite { return scene; }
		
		 var friction:Number = 1;
		static public function get FRICTION():Number { return (1 / friction); }
		static public function set FRICTION(value:Number):void { friction = value; }
		
		 var gravity:Vector = new Vector(0, -3);
		static public function get GRAVITY():Vector { return gravity; }
		static public function set GRAVITY(value:Vector):void { gravity = value; }
		
		 var solving:Boolean = false;
		 var preRender:Function;
		static public function set pre(func:Function):void { preRender = func; }
		
		 var postRender:Function;
		static public function set post(func:Function):void { postRender = func; }
		
		 var length:int = 0;
		 var counter:Label = new Label( { str:"0", ts:new TextStyle( { fontFamily:"h85" } ), ss:new ShapeStyle(), ds:new ShadowStyle() } );
		 var objects:Dictionary = new Dictionary();
		static public function get particles():Dictionary { return objects; }
		
		
		static public function get frameRate():int
		{
			if (scene) { return scene.stage.frameRate; }
			else { throw new Error("Engine is not registered"); }
		}
		
		static public function set frameRate(value:int):void
		{
			if (scene) { scene.stage.frameRate = value; }
			else { throw new Error("Engine is not registered"); }
		}
		

		static public function get status():String
		{
			if (solving) { return "playing"; }
			else
			{
				if (frame != 0) { return "paused"; }
				else { return "stopped"; }
			}
		}
		
		
		
		
		
		
		
		public function Engine() {}
		
		static public function register(space:Sprite, friction:Number = 1.05, autostart:Boolean = false):void
		{
			if (!scene)
			{
				scene = space;
				
				FRICTION = friction;
				
				if (autostart) { play(); }
			}
			else { throw new Error("Engine is already registered"); }
		}
		
		static public function release():void
		{
			if (scene)
			{
				if (solving) { stop(); }
				scene = null;
			}
			else { throw new Error("Engine is not registered"); }
		}
		
		
		
		
		
		
		static public function addParticle(object:Particle):void
		{
			length++;
			
			counter.refresh( { str:length.toString() } );
			
			scene.addChild(object);
			allow(object);
		}
		
		static public function allow(object:Particle):void
		{
			if (scene && (!(object in objects))) { objects[object] = object; }
			else { throw new Error("The object '" + object.name + "' is already allowed to move"); }
		}
		
		static public function deny(object:Particle):void
		{
			if (scene && (object in objects)) { delete objects[object]; }
			else { throw new Error("The object '" + object.name + "' is not allowed to move"); }
		}
		
		
		
		
		
		
		static public function play():void
		{
			scene.stage.frameRate = 60;
			
			if (scene && !solving)
			{
				trace("Engine running");
				scene.stage.addEventListener(Event.ENTER_FRAME, solve);
				
				playing = true; paused = false; stopped = false;
				solving = true;
			}
			else { throw new Error("Engine is already running or not registered"); }
		}
		
		static public function pause():void
		{
			if (scene && solving)
			{
				trace("Engine paused");
				scene.stage.removeEventListener(Event.ENTER_FRAME, solve);
				
				playing = false; paused = true; stopped = false;
				solving = false;
			}
			else { throw new Error("Engine is not running or not registered"); }
		}
		
		static public function stop():void
		{
			if (scene)
			{
				trace("Engine stopped");
				scene.stage.removeEventListener(Event.ENTER_FRAME, solve);
				
				frame = 0;
				
				playing = false; paused = false; stopped = true;
				solving = false;
			}
			else { throw new Error("Engine is not running or not registered"); }
		}
		
		 function solve(e:Event):void
		{
			e.stopImmediatePropagation();
			scene.dispatchEvent(new FrameEvent(FrameEvent.ENTER));
			
			frame++;
			
			if (preRender != null) { preRender(); }
			
			for each(var particle:Particle in objects)
			{
				particle.accel = particle.forces;
				particle.accel = particle.accel.divEquals(particle.mass);
				
				particle.speed.plusEquals(particle.accel);
				particle.speed.multEquals(FRICTION);
				
					if ((particle.speed.x < 0.001) && (particle.speed.x > -0.001)) { particle.speed.x = 0; }
					if ((particle.speed.y < 0.001) && (particle.speed.y > -0.001)) { particle.speed.y = 0; }
				
				particle.x += particle.speed.x;
				particle.y += particle.speed.y;
			}
			
			if (postRender != null) { postRender(); }
		}
		
		static public function debug():void
		{
			Fonts.register(ExtendedFonts.h85);
			scene.addChild(counter);
		}
	}
}