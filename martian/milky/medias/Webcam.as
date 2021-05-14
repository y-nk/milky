package martian.milky.medias
{
	import flash.display.Sprite;
	
    import flash.media.Camera;
    import flash.media.Video;
   
    import flash.events.ActivityEvent;
    import flash.events.MouseEvent;
   
    import flash.system.Security;
    import flash.system.SecurityPanel;
	
	import flash.geom.Point;
	
	import martian.milky.core.Utils;
	
	import martian.milky.curves.Rectangles;
	import martian.milky.events.LoadEvent;
	import martian.milky.styles.*;
	import martian.milky.interfaces.*;
	
	public class Webcam extends Media implements MilkyObject, MilkyShadow
	{
		static public const FRAME:String = "frame";
		static public const POLAROID:String = "polaroid";
		
        private var camera:Camera;
        private var video:Video;
		
		private function get frame():String { return $parameters.frame; }
		private function get mirror():Boolean { return $parameters.mirror; }
       
        public function Webcam(parameters:Object = null):void
        {
			super(parameters);
        }
       
		override public function initialize(parameters:Object):void
		{
            Security.showSettings(SecurityPanel.CAMERA);
				super.initialize(parameters);
		}
		
		override public function store(parameters:Object):void
		{
			parameters.url = "";
			if ((parameters.frame != undefined) && (Utils.isA(parameters.frame, String))) { $parameters.frame = parameters.frame; }
			if ((parameters.mirror != undefined) && (Utils.isA(parameters.mirror, Boolean))) { $parameters.mirror = parameters.mirror; }
			else if ($parameters.mirror == null) { $parameters.mirror = true; }
			
			super.store(parameters);
		}
		
		override public function draw(e:MouseEvent = null):void
		{
			if (ds != null) { filters = ds.render; }
			
            camera = Camera.getCamera();
                camera.setMode(camera.width, camera.height, 60);
                camera.setMotionLevel(50, 500);
                camera.addEventListener(ActivityEvent.ACTIVITY, detect);
			
            video = new Video(camera.width, camera.height);
                video.smoothing = true;
                video.attachCamera(camera);
				
			if (frame != null)
			{
				var border:Rectangles;
				var style:ShapeStyle = new ShapeStyle( { fillColor:0xFFFFFF, fillAlpha:1, lineThick:0 } );
				
				switch(frame)
				{
					case "frame":
						border = new Rectangles( { width: camera.width + 10, height: camera.height + 10, ss: style, editable: false } );
							addChild(border);
							
							video.x = 5;
							video.y = 5; 
							
						break;
						
					case "polaroid":
						border = new Rectangles( { width: camera.width + 20, height: camera.height + 60, ss: style, editable: false } );
							addChild(border);
							
							video.x = 10;
							video.y = 10;
							
						break;
						
					case null:
						break;
				}
			}
			
			if (mirror)
			{
				video.x += video.width;
				video.scaleX = -1;
			}
            
			addChild(video);
			
			$size = new Point(video.width, video.height);
		}
		
        private function detect(e:ActivityEvent):void
        {
			e.stopImmediatePropagation();
			dispatchEvent(e);
        }
	}
	
}