/*

LibertyGIS - LibertyGIS is an open source flex mapping framework for displaying ShapeFiles.

http://code.google.com/p/liberty-gis/

Copyright (c) 2010 - 2012 Bryan Dresselhaus, All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/
package com.liberty.controls
{
	import com.liberty.files.shapefile.Bounds;
	import com.liberty.files.shapefile.ShapeFileRecord;
	
	/**
	 * The MapItemPolyline class draws geographical Polyline data.
	 * 
	 */	
	public class MapItemPolyline extends MapItem
	{
	
		//--------------------------------------
		//  Constructor
		//--------------------------------------
		
		/**
		 * Constructor 
		 * @inherit
		 * 
		 */
		public function MapItemPolyline(shapeFileRecord:ShapeFileRecord=null, bounds:Bounds=null, offsetX:Number = 0, offsetY:Number = 0, zoom:Number=1)
		{
			super(shapeFileRecord, bounds, offsetX, offsetY, zoom);
		}

		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Draws the polyline. 
		 * 
		 */
		private function drawPolyline():void
		{
			if (shapeFileRecord)
			{
				graphics.clear();
				
				graphics.lineStyle(0.01, getStyle("lineColor"));
				graphics.drawPath(drawCommands, drawPoints);
					
				x = tempX;
				y = tempY;
			}
		}
		
		
		/**
		 * @private 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{	
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			drawPolyline();
		}
	}
}