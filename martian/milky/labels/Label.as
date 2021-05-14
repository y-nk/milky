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

package martian.milky.labels
{
	import martian.milky.curves.Rectangles;
	import martian.milky.styles.*;
	import martian.milky.events.*;
	import martian.milky.core.Utils;
	import martian.milky.interfaces.*;

	import flash.display.Sprite;
	import flash.text.*;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class Label extends Sprite implements MilkyObject, MilkyShape, MilkyText, MilkyShadow
	{
		protected var $layer:Rectangles, $shape:Rectangles, $str:String;
		
		protected var $textField:TextField = new TextField();
			public function get str():String { return $textField.text; }
			public function set str(str:String):void { refresh( { str:str } ); }
		
		protected var $parameters:Object = new Object;
			public function get parameters():Object { return $parameters; }
			
			public function get ss():ShapeStyle { return $parameters.ss; }
			public function set ss(ss:ShapeStyle):void { refresh( { ss:ss } ); }
			
			public function get ts():TextStyle { return $parameters.ts; }
			public function set ts(ts:TextStyle):void { refresh( { ts:ts } ); }
			
			public function get ds():ShadowStyle { return $parameters.ds; }
			public function set ds(ds:ShadowStyle):void { refresh( { ds:ds } ); }
		
		public function Label(parameters:Object = null)
		{
			if (parameters != null) { initialize(parameters); }
		}
		
		public function initialize(parameters:Object):void
		{
			store(parameters);
			draw();
		}
		
		public function store(parameters:Object):void
		{
			if (parameters.str != undefined) { if (Utils.isA(parameters.str, String)) { $parameters.str = parameters.str; } }
			else if ($parameters.str == null) { throw new Error("str parameter is missing"); }
			
			if (parameters.ts != undefined) { if (Utils.isA(parameters.ts, TextStyle)) { $parameters.ts = parameters.ts; } }
			else if ($parameters.ts == null) { $parameters.ts = TextStyle.getDefaultStyle(); }
			
			if ((parameters.ss != undefined) && (Utils.isA(parameters.ss, ShapeStyle))) { $parameters.ss = parameters.ss; }
			if ((parameters.ds != undefined) && (Utils.isA(parameters.ds, ShadowStyle))) { $parameters.ds = parameters.ds; }
		}
		
		public function draw(e:MouseEvent = null):void
		{
			if ($parameters.ds != null) { filters = ds.render; }
			
			var textFormat:TextFormat = new TextFormat;
				textFormat.font = ts.fontFamily;
				textFormat.size = ts.fontSize;
				textFormat.color = ts.fontColor;
				textFormat.align = ts.fontAlign;
				textFormat.letterSpacing = ts.fontSpacing;
				
				$textField.defaultTextFormat = textFormat;
				$textField.setTextFormat(textFormat);
				
				$textField.selectable = false;
				$textField.multiline = false;
				$textField.wordWrap = false;
				$textField.embedFonts = true;
				$textField.text = parseLabel();
				$textField.autoSize = TextFieldAutoSize.LEFT;
				$textField.antiAliasType = AntiAliasType.NORMAL;
			
			if ($shape != null) { $shape.refresh( { width: int($textField.textWidth) + 6, height: int($textField.textHeight) + 4, ss:ss } ); }
			if ($shape == null) { addChild($shape = new Rectangles( { width: int($textField.textWidth) + 6, height: int($textField.textHeight) + 4, ss:ss, editable: false } ) ); }
			
			setChildIndex($shape, 0);
			
			if ($textField.parent == null) { addChild($textField); }
				setChildIndex($textField, numChildren - 1);
			
			if ($layer == null)
			{
				addChild($layer = new Rectangles( { width:int($textField.textWidth) + 6, height:int($textField.textHeight) + 4, ss:new ShapeStyle({ fillColor:0x00ffff, fillAlpha:1, lineThick:0, lineAlpha:0 }), editable:false } ) );
					$layer.alpha = 0;
			}
			else { $layer.refresh( { width: int($textField.textWidth) + 6, height: int($textField.textHeight) + 4 } ); }
			
			setChildIndex($layer, numChildren - 1);
			
			dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
		}
		
		public function clone():MilkyObject { return new Label( $parameters ); }
		
		public function appendHtmlText(arg:*):void
		{
			var charCode:int, keyCode:int;
			
			if (arg is KeyboardEvent)
			{
				arg.stopImmediatePropagation();
					charCode = arg.charCode;
					keyCode = arg.keyCode;
				
				switch(charCode)
				{
					case 8:
						if ($textField.text != "") { $textField.text = $textField.text.substr(0, $textField.text.length - 1); }
						$parameters.str = $parameters.str.substr(0, $parameters.str.length - 1);
						break;
						
					case 13:
						$textField.appendText("\n");
						$parameters.str += "[br]";
						break;
						
					case 58:
						if (keyCode == 190)
						{
							$textField.appendText(".");
							$parameters.str += ".";
						}
						else if ((keyCode == 191) && (arg.shiftKey))
						{
							$textField.appendText("/");
							$parameters.str += "/";
						}
						else
						{
							$textField.appendText(String.fromCharCode(charCode));
							$parameters.str += String.fromCharCode(charCode);
						}
						break;
						
					case 60:
						if (keyCode == 188)
						{
							$textField.appendText("?");
							$parameters.str += "?";
						}
						break;
						
					default:
						$textField.appendText(String.fromCharCode(charCode));
						$parameters.str += String.fromCharCode(charCode);
						break;
				}
			}
			else
			{
				$textField.appendText(arg);
				$parameters.str += arg;
			}
			
			if ($shape != null) { $shape.refresh( { width: $textField.textWidth + 6, height: $textField.textHeight + 4 } ); }
			if ($layer != null) { $layer.refresh( { width: $textField.textWidth + 6, height: $textField.textHeight + 4 } ); }
			
			dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
		}
		
		public function refresh(parameters:Object):void
		{
			store(parameters);
			draw();
		}
		
		private function parseLabel():String
		{
			return $parameters.str.replace(/\[br\]/g, "\r\n");
		}
	}
}
