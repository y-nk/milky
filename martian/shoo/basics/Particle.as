package martian.shoo.basics 
{
	import martian.shoo.utils.Vector;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Particle extends Sprite
	{
		private var $size:Number, $mass:Number, $coordinates:Point, $speed:Vector = new Vector(), $accel:Vector = new Vector(), $forces:Vector = new Vector(), $alive:Boolean;
		
		
		override public function set x(value:Number):void { super.x = $coordinates.x = value; }
		override public function set y(value:Number):void { super.y = $coordinates.y = value; }
		
		public function get size():Number { return $size; }
		public function set size(value:Number):void { if (value <= 0) { $size = 1; } else { $size = value; } }
		
		public function get mass():Number { if ($mass == 0) { return 0; } else { return $mass; } }
		public function set mass(value:Number):void { if (value != 0) { $mass = value; } else { $mass = 1; } }
		
		public function get coordinates():Point { return $coordinates; }
		public function set coordinates(value:Point):void { $coordinates = value;  x = value.x; y = value.y; }
		
		public function get speed():Vector { return $speed; }
		public function set speed(value:Vector):void { $speed = value; }
		
		public function get accel():Vector { return $accel; }
		public function set accel(value:Vector):void { $accel = value; }
		
		public function get forces():Vector { return $forces; }
		
		public function get alive():Boolean { return $alive; }
		public function set alive(bool:Boolean):void { $alive = bool }
		
		public function Particle(coordinates:Point = null, size:Number = 1, alive:Boolean = true) 
		{
			if (coordinates == null) { this.coordinates = new Point(); }
			else { this.coordinates = coordinates; }
			
			this.size = size;
			this.mass = $size * 2;
			
			if (alive) { draw(); }
		}
		
		public function draw():void
		{
			graphics.clear();
			graphics.beginFill(0xffffff, 0.25);
			graphics.drawCircle(0, 0, $size);
			graphics.endFill();
		}
		
		public function addForce(force:Vector):void { $forces.plusEquals(force); }
		public function clearForces():void { $forces = new Vector(); }
	}
}