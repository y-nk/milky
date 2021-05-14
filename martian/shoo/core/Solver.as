package martian.shoo.core
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import martian.shoo.basics.*;
	
	internal class Solver
	{	
		private var stage:Stage;
		
		public function Solver() { }
		
		static public function register(space:Stage):void { stage = space.stage; }
		static public function release():void { stage = null; }
		
		static public function forces(particle:Particle):void
		{
			/*for each(var blob:Blob in objects)
			{
				for each(var constraint:Constraint in blob.constraints)
				{
					var render:Boolean = false;
					
					if (constraint.origin.forces.norm > PRECISION)
					{
						render = true;
						
						constraint.origin.accel = constraint.origin.forces;
						constraint.origin.accel = constraint.origin.accel.divEquals(constraint.origin.mass);
						
						constraint.origin.speed.plusEquals(constraint.origin.accel);
						constraint.origin.speed.multEquals(FRICTION);
						
						//constraint.origin.x += constraint.origin.speed.x;
						//constraint.origin.y += constraint.origin.speed.y;
					}
					else { constraint.origin.clearForces(); }
					
					
					if (constraint.destination.forces.norm > PRECISION)
					{
						render = true;
						
						constraint.destination.accel = constraint.destination.forces;
						constraint.destination.accel = constraint.destination.accel.divEquals(constraint.destination.mass);
						
						constraint.destination.speed.plusEquals(constraint.destination.accel);
						constraint.destination.speed.multEquals(FRICTION);
						
						//constraint.destination.x += constraint.destination.speed.x;
						//constraint.destination.y += constraint.destination.speed.y;
					}
					else { constraint.destination.clearForces(); }
					
					if (render)
					{
						constraint.draw();
						
						var T:Number = constraint.origin.speed.x - constraint.destination.speed.x;
						var R:Number = constraint.origin.speed.y * constraint.origin.x + constraint.destination.speed.y * constraint.destination.x;
						
						var TR:Vector = Vector.fromVelocity(T, R + constraint.rotation);
						
						var rotationRad:Number = constraint.rotation * Math.PI / 180;
							var px:Number = TR.x * Math.cos(rotationRad) - TR.y * Math.sin(rotationRad);
							var py:Number = TR.x  * Math.sin(rotationRad) + TR.y  * Math.cos(rotationRad);
						
						constraint.x += px / 1000;
						constraint.y += py / 1000;
						
						constraint.rotation += R / 1000;
						
						var o:Point = blob.localToGlobal(new Point(constraint.x, constraint.y));
						
						scene.graphics.beginFill(0xff0000, 0.5);
						scene.graphics.drawCircle(o.x, o.y, 1);
						scene.graphics.endFill();
					}
				}
			}*/

		}
		
		
		
		
		/*
		static public function collide(objA:Sprite, objB:Sprite, tolerance:int = 255):Rectangle
		{
			var boundsA:Object = objA.getBounds(stage);
			var boundsB:Object = objB.getBounds(stage);
			
			if (((boundsA.xMax < boundsB.xMin) || (boundsB.xMax < boundsA.xMin)) || ((boundsA.yMax < boundsB.yMin) || (boundsB.yMax < boundsA.yMin)) ) { return null; }
			
			var bounds:Object = {};
				bounds.xMin = Math.max(boundsA.xMin, boundsB.xMin);
				bounds.xMax = Math.min(boundsA.xMax, boundsB.xMax);
				bounds.yMin = Math.max(boundsA.yMin, boundsB.yMin);
				bounds.yMax = Math.min(boundsA.yMax, boundsB.yMax);
				
			var mtx:Matrix = objA.transform.concatenatedMatrix;
				mtx.tx -= bounds.xMin;
				mtx.ty -= bounds.yMin;
				
			var bmd:BitmapData = new BitmapData(bounds.xMax - bounds.xMin, bounds.yMax - bounds.yMin, false);
				bmd.draw(objA, mtx, new ColorTransform(1, 1, 1, 1, 255, -255, -255, tolerance));
				
			mtx = objB.transform.concatenatedMatrix;
				mtx.tx -= bounds.xMin;
				mtx.ty -= bounds.yMin;
				
			bmd.draw(objB, mtx, new ColorTransform(1, 1, 1, 1, 255, 255, 255, tolerance), BlendMode.DIFFERENCE);
			
			var intersection:Rectangle = bmd.getColorBoundsRect(0xFFFFFFFF,0xFF00FFFF);
			if (intersection.width == 0) { return null; }
			
			intersection.x += bounds.xMin;
			intersection.y += bounds.yMin;
			
			return intersection;
		}*/
	}
	
}