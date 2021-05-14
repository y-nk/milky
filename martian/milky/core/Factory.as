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
	import martian.milky.curves.*;
	import martian.milky.labels.*;
	import martian.milky.medias.*;
	import martian.milky.styles.*;
	import martian.milky.special.*;
	import martian.milky.interfaces.*;
	
	import flash.system.ApplicationDomain;
	
	public class Factory 
	{
		public function Factory() { throw new Error("Factory should not be instanciated"); }
		
		static public function getObject(type:String, parameters:Object):MilkyObject
		{
			var pack:String = new String();
			
			switch (type)
			{
				case 'curvegon': case 'ellipse': case 'line': case 'rectangles': case 'regularpolygon':	case 'roundrectangles':	case 'starpolygon':	case 'triangle':
					pack = 'curves';
					break;
					
				case 'image': case 'movie': case 'music': case 'flash':
					pack = 'medias';
					break;
					
				case 'label': case 'link': case 'mover':
					pack = 'labels';
					break;
			}
			
			type = type.substring(0, 1).toUpperCase() + type.substring(1, type.length);
			
			if (ApplicationDomain.currentDomain.hasDefinition('martian.milky.' + pack + '.' + type)) 
			{ 	
				var classType:Class = ApplicationDomain.currentDomain.getDefinition('martian.milky.' +  pack + '.' + type) as Class;
				var object:* = new classType() as Object;
					object.initialize(parameters);
					return object;
			}
			else { throw new Error("Object 'martian.milky." + pack + "." + type + "' not found"); }
		}
		
		static public function getEllipse(width:Number, height:Number, shapestyle:ShapeStyle = null, shadowstyle:ShadowStyle = null, editable:Boolean = false):Ellipse { return new Ellipse( { width:width, height:height, ss:shapestyle, ds:shadowstyle, editable:editable } ); }
		
		static public function getLine(length:Number, angle:Number, shapestyle:ShapeStyle = null, shadowstyle:ShadowStyle = null, editable:Boolean = false):Line { return new Line( { length:length, angle:angle, ss:shapestyle, ds:shadowstyle, editable:editable } ); }
		
		static public function getRectangle(width:Number, height:Number, shapestyle:ShapeStyle = null, shadowstyle:ShadowStyle = null, editable:Boolean = false):Rectangles { return new Rectangles( { width:width, height:height, ss:shapestyle, ds:shadowstyle, editable:editable } ); }
		
		static public function getRegularpolygon(edges:int, radius:Number, shapestyle:ShapeStyle = null, shadowstyle:ShadowStyle = null, editable:Boolean = false):Regularpolygon { return new Regularpolygon( { edges:edges, radius:radius, ss:shapestyle, ds:shadowstyle, editable:editable } ); }
		
		static public function getRoundrectangle(width:Number, height:Number, radius:Number = 20, shapestyle:ShapeStyle = null, shadowstyle:ShadowStyle = null, editable:Boolean = false):Roundrectangles { return new Roundrectangles( { width:width, height:height, radius:radius, ss:shapestyle, ds:shadowstyle, editable:editable } ); }
		
		static public function getStarpolygon(spikes:int, radius1:Number, radius2:Number, shapestyle:ShapeStyle = null, shadowstyle:ShadowStyle = null, editable:Boolean = false):Starpolygon { return new Starpolygon( { spikes:spikes, radius1:radius1, radius2:radius2, ss:shapestyle, ds:shadowstyle, editable:editable } ); }
		
		static public function getTriangle(width:Number, height:Number, shapestyle:ShapeStyle = null, shadowstyle:ShadowStyle = null, editable:Boolean = false):Triangle { return new Triangle( { width:width, height:height, ss:shapestyle, ds:shadowstyle, editable:editable } ); }
		
		
		
		static public function getLabel(str:String, textstyle:TextStyle = null, shapestyle:ShapeStyle = null, shadowstyle:ShadowStyle = null):Label { return new Label( { str:str, ts:textstyle, ss:shapestyle, ds:shadowstyle } ); }
		
		static public function getLink(str:String, url:String, textstyle:TextStyle = null, shapestyle:ShapeStyle = null, shadowstyle:ShadowStyle = null):Link { return new Link( { str:str, url:url, ts:textstyle, ss:shapestyle, ds:shadowstyle } ); }
		
		static public function getMover(str:String, move:Object, textstyle:TextStyle = null, shapestyle:ShapeStyle = null, shadowstyle:ShadowStyle = null):Label { return new Mover( { str:str, move:move, ts:textstyle, ss:shapestyle, ds:shadowstyle } ); }		
		
		
		
		static public function getFlash(url:String, shadowstyle:ShadowStyle = null):Flash { return new Flash( { url:url, ds:shadowstyle } ); }
		
		static public function getImage(url:String, frame:String = null, shadowstyle:ShadowStyle = null):Image { return new Image( { url:url, frame:frame, ds:shadowstyle } ); }
		
		static public function getMovie(url:String, controls:Boolean = true, autoplay:Boolean = false, shadowstyle:ShadowStyle = null):Movie { return new Movie( { url:url, controls:controls, autoplay:autoplay, ds:shadowstyle } ); }
		
		static public function getMusic(url:String, controls:Boolean = true, autoplay:Boolean = false, shadowstyle:ShadowStyle = null):Music { return new Music( { url:url, controls:controls, autoplay:autoplay, ds:shadowstyle } ); }
		
		
		
		static public function getWebcam(frame:String = null, shadowstyle:ShadowStyle = null):Webcam { return new Webcam( { frame:frame, ds:shadowstyle } ); }
		
		
		
		static public function getShapeStyle(fillColor:int, fillAlpha:Number, lineThick:Number, lineColor:int, lineAlpha:Number):ShapeStyle { return new ShapeStyle( { fillColor:fillColor, fillAlpha:fillAlpha, lineThick:lineThick, lineColor:lineColor, lineAlpha:lineAlpha } ); }	
		
		static public function getTextStyle(fontFamily:String, fontSize:int, fontColor:int, fontAlign:String, fontSpacing:Number):TextStyle { return new TextStyle( { fontFamily:fontFamily, fontSize:fontSize, fontColor:fontColor, fontAlign:fontAlign, fontSpacing:fontSpacing } ); }	
		
		static public function getShadowStyle(distance:int, angle:Number, color:int, alpha:Number, blur:int):ShadowStyle { return new ShadowStyle( { distance:distance, angle:angle, color:color, alpha:alpha, blur:blur } ); }			
	}
}