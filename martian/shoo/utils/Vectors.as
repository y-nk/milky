package martian.shoo.utils 
{
	import flash.geom.Point;
	
	public class Vectors
	{
		static public const NULL:Vectors = new Vectors();
		
		private var $x:Number = 0, $y:Number = 0;
		
		public function get x():Number { return $x; }
		public function set x(value:Number):void { $x = value; }
		
		public function get y():Number { return $y; }
		public function set y(value:Number):void { $y = value; }
		
		public function get length():Number { return Point.distance(new Point(), new Point(x, y)); }
		public function get angle():Number { return Math.atan2(y, x) * 180 / Math.PI; }
		
		public function Vectors(x:Number = 0, y:Number = 0) 
		{
			$x = x;
			$y = y;
		}
		
		public function plus(v:Vectors):Vectors {
			return new Vectors(x + v.x, y + v.y); 
		}
	
		
		public function plusEquals(v:Vectors):Vectors {
			x += v.x;
			y += v.y;
			return this;
		}
		
		
		public function minus(v:Vectors):Vectors {
			return new Vectors(x - v.x, y - v.y);    
		}
	
	
		public function minusEquals(v:Vectors):Vectors {
			x -= v.x;
			y -= v.y;
			return this;
		}
	
	
		public function mult(s:Number):Vectors {
			return new Vectors(x * s, y * s);
		}
	
	
		public function multEquals(s:Number):Vectors {
			x *= s;
			y *= s;
			return this;
		}
		
		public function div(s:Number):Vectors {
			return new Vectors(x / s, y / s);
		}
	
	
		public function divEquals(s:Number):Vectors {
			x /= s;
			y /= s;
			return this;
		}
		
		public function times(v:Vectors):Vectors {
			return new Vectors(x * v.x, y * v.y);
		}
		
		public function invert():Vectors
		{
			return new Vectors( -x, -y);
		}
		
		static public function fromVelocity(length:Number, angle:Number):Vectors
		{
			return new Vectors(Math.cos(angle) * length, Math.sin(angle) * length);
		}
		
		public function toVelocity(length:Number, angle:Number):void
		{
			this.x = Math.cos(angle) * length;
			this.y = Math.sin(angle) * length;
		}
		
		public function toString():String
		{
			return "[ " + x.toFixed(3) + " ; " + y.toFixed(3) + " ]";
		}
	}
}