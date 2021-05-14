package martian.shoo.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.filters.*;
	import flash.geom.Rectangle;
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
	
	public class BMDEngine
	{
		static private const PRECISION:Number = 0.001;
		
		static public var playing:Boolean = false;
		static public function get PLAYING():Boolean { return playing; }
		
		static public var paused:Boolean = false;
		static public function get PAUSED():Boolean { return paused; }
		
		static public var stopped:Boolean = true;
		static public function get STOPPED():Boolean { return stopped; }
		
		static private var frame:int = 0;
		static public function get time():Number { return Math.round(frame  * 10000 / scene.stage.frameRate) / 10000; }
		
		static private var stage:Stage;
		static private var proxy:Sprite = new Sprite();
		static private var scene:Bitmap;
		static private var rendering:BitmapData;
		static private var rubber:Shape;
		
		static public function get environment():Bitmap { return scene; }
		
		static private var maxspeed:int = 25;
		static public function get MAXSPEED():Number { return maxspeed; }
		static public function set MAXSPEED(value:Number):void { maxspeed = value; }

		static private var friction:Number = 1;
		static public function get FRICTION():Number { return (1 / friction); }
		static public function set FRICTION(value:Number):void { friction = value; }
		
		static private var gravity:Vectors = new Vectors(0, -3);
		static public function get GRAVITY():Vectors { return gravity; }
		static public function set GRAVITY(value:Vectors):void { gravity = value; }
		
		static private var solving:Boolean = false;
		static private var preRender:Function;
		static public function set pre(func:Function):void { preRender = func; }
		
		static private  var postRender:Function;
		static public function set post(func:Function):void { postRender = func; }
		
		static private var length:int = 0;
		static private var objects:Vector.<Array> = new Vector.<Array>;
		static public function get particles():Vector.<Array>  { return objects; }
		
		static private var modifiers:Vector.<Array> = new Vector.<Array>;
		
		static private var bitmapMode:Boolean = false;
		static public function get renderingMode():String { if (bitmapMode) { return "bitmap"; } else { return "sprite"; } }
		static public function set renderingMode(value:String):void
		{
			if (value == "bitmap") { bitmapMode = true; }
			else if (value == "sprite") { bitmapMode = false; }
			else { throw new Error("renderingMode value must be 'bitmap' or 'sprite'"); }
		}
		
		static private var physics:Vector.<Array> = new Vector.<Array>;
		
		static private var BF:BlurFilter = new BlurFilter(6, 6, 3);
		
		static private var trailcolor:int = 0;
		static public function get trailColor():int { return trailcolor; }
		static public function set trailColor(value:int):void
		{
			trailcolor = value;
			
			if (rubber == null) { rubber = new Shape; }
			rubber.graphics.clear();
			rubber.graphics.beginFill(trailcolor, 0.5);
			rubber.graphics.drawRect(0, 0, scene.width, scene.height);
			rubber.graphics.endFill();
		}
		
		static private var rub:Boolean = false;
		static public function get trail():Boolean { return rub; }
		static public function set trail(value:Boolean):void
		{
			rub = value;
			
			if (value)
			{
				rubber = new Shape;
				trailColor = 0;
			}
			else
			{
				rubber = null;
			}
		}
		
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
		
		
		
		
		
		
		
		public function BMDEngine() {}
		
		static public function register(space:Sprite, friction:Number = 1.05, autostart:Boolean = false):void
		{
			if (!scene)
			{
				rendering = new BitmapData(space.stage.stageWidth, space.stage.stageHeight, true, 0);
				scene = new Bitmap(rendering, "always", true);
				
				space.addChild(scene);
				stage = space.stage;
				
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
				stage = null;
			}
			else { throw new Error("Engine is not registered"); }
		}
		
		
		
		
		
		
		static public function addParticle(x:int = 0, y:int = 0, force:Vectors = null, mass:int = 5, color:uint = 0x20ffffff):void
		{
			var alive:int = force != null ? 1 : 0;
			var forceX:Number = force != null ? force.x : 0;
			var forceY:Number = force != null ? force.y : 0;
			
			//[posX, posY]
			objects.push([x, y, color]);
			//[mass, accelX, accelY, speedX, speedY, alive]
			physics.push([mass, 0, 0, forceX, forceY, alive]);
		}
		
		static public function addParticleField(minX:int, minY:int, maxX:int, maxY:int, number:int, mass:int, color:uint):void
		{
			for (var i:int = 0; i < number; i++)
			{
				addParticle((Math.random() * (maxX - minX)) + minX, (Math.random() * (maxY - minY)) + minY, null, mass, color);
			}
		}
		
		static public function addForce(index:int, force:Vectors):void
		{
			physics[index][3] += force.x;
			physics[index][4] += force.y;
			physics[index][5] = 1;
		}
		
		static public function play():void
		{
			stage.frameRate = 30;
			
			if (scene && !solving)
			{
				trace("Engine running");
				stage.addEventListener(Event.ENTER_FRAME, solve);
				
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
				stage.removeEventListener(Event.ENTER_FRAME, solve);
				
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
				stage.removeEventListener(Event.ENTER_FRAME, solve);
				
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
			
			if (!trail) { rendering.fillRect(rendering.rect, 0); }
			if (!bitmapMode) { proxy.graphics.clear(); }
			
			frame++;
			
			for (var i:int = 0; i < objects.length; i++)
			{
				/*displaying*/
				
				if (physics[i][5] == 1)
				{
					/*calculation*/
					if (preRender != null) { preRender(); }
					
					physics[i][1] = physics[i][3];
					physics[i][2] = physics[i][4];
					
					physics[i][1] -= GRAVITY.x;
					physics[i][2] -= GRAVITY.y;
					
					physics[i][1] /= physics[i][0];
					physics[i][2] /= physics[i][0];
					
					physics[i][3] += physics[i][1] ;
					physics[i][4] += physics[i][2] - GRAVITY.y;
					
					physics[i][3] *= FRICTION;
					physics[i][4] *= FRICTION;
					
						if ((physics[i][3] < 0.001) && (physics[i][3] > -0.001)) { physics[i][3] = 0; }
						if ((physics[i][4] < 0.001) && (physics[i][4] > -0.001)) { physics[i][4] = 0; }
						if ((physics[i][3] == 0) && (physics[i][4] == 0)) { physics[i][5] = 0; }
						
					physics[i][3] = physics[i][3] > MAXSPEED ? MAXSPEED : physics[i][3];
					physics[i][3] = physics[i][3] < -MAXSPEED ? -MAXSPEED : physics[i][3];
					
					physics[i][4] = physics[i][4] > MAXSPEED ? MAXSPEED : physics[i][4];
					physics[i][4] = physics[i][4] < -MAXSPEED ? -MAXSPEED : physics[i][4];
						
					if ((objects[i][0] + physics[i][3] < 0) || (objects[i][0] + physics[i][3] > stage.stageWidth )) { physics[i][3] = (- (physics[i][3] + GRAVITY.x) * FRICTION); }
					if ((objects[i][1] + physics[i][4] < 0) || (objects[i][1] + physics[i][4] > stage.stageHeight)) { physics[i][4] = (- (physics[i][4] + GRAVITY.y) * FRICTION); }
					
					objects[i][0] += physics[i][3];
					objects[i][1] += physics[i][4];
					
					if (modifiers != null)
					{
						
						
					}
					
					if (postRender != null) { postRender(); }
					
					if (!bitmapMode)
					{
						proxy.graphics.beginFill(objects[i][2], 1);
						proxy.graphics.drawCircle(objects[i][0], objects[i][1], 0.5);
						proxy.graphics.endFill();
					} else { rendering.setPixel32(objects[i][0], objects[i][1], objects[i][2]);	}
				}
			}
			if (trail) { rendering.draw(rubber); }
			if (!bitmapMode) { rendering.draw(proxy); }
			
			//rendering.applyFilter(rendering, rendering.rect, new Point(), BF);
		}
	}
}