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
	import com.liberty.core.DataLayer;
	import com.liberty.files.shapefile.Bounds;
	import com.liberty.files.shapefile.IShapeFileContent;
	import com.liberty.files.shapefile.ShapeFileRecord;
	
	import flash.display.BitmapData;
	
	import mx.core.UIComponent;
	
	/**
	 * The MapBitmap class draws point ShapeFileContent.
	 * 
	 */	
	public class MapBitmap extends UIComponent
	{
		/**
		 * The BitmapData used to render the map's bitmap.
		 */	
		public var bitmapData:BitmapData;
		
		/**
		 * The bounds of the layer content.
		 */
		public var bounds:Bounds = new Bounds();
		
		/**
		 * A placeholder for arbitrary data. 
		 */		
		public var data:Object;
		
		/**
		 * The DataLayer containing the MapBitmap shapefile records.
		 */
		public var dataLayer:DataLayer;
		
		/**
		 * @private
		 * The x offset, in pixels, to draw the MapItem 
		 */	
		public var offsetX:Number = 0;
		
		/**
		 * @private
		 * The y offset, in pixels, to draw the MapItem 
		 */		
		public var offsetY:Number = 0;
		
		/**
		 * @private 
		 */		
		protected var tempX:Number = 9999;
		
		/**
		 * @private 
		 */		
		protected var tempY:Number = 9999;
		
		/**
		 * The zoom scale of the MapItem. 
		 */		
		public var zoom:Number = 1;
		
		/**
		 * Constructor 
		 * @param dataLayer The DataLayer to draw.
		 * @param bounds The bounds of the MapBitmap.
		 * @param offsetX The x offset, in pixels, to draw the MapItem.
		 * @param offsetY The y offset, in pixels, to draw the MapItem
		 * @param zoom The zoom scale of the MapItem.
		 * 
		 */	
		public function MapBitmap(dataLayer:DataLayer, bounds:Bounds=null, offsetX:Number = 0, offsetY:Number = 0, zoom:Number=1)
		{
			super();
			
			this.bounds = bounds;
			this.dataLayer = dataLayer;
			this.offsetX = offsetX;
			this.offsetY = offsetY;
			this.zoom = zoom;
		}
		
		/**
		 * @private
		 * Calculates the size of the MapItem. 
		 * 
		 */		
		public function calculateSize():void	
		{	
			measuredWidth = (bounds.maxX * zoom) - (bounds.minX * zoom)
			measuredHeight = (bounds.maxY * zoom) - (bounds.minY * zoom);
			
			setActualSize(measuredWidth, measuredHeight);
		}
		
		/**
		 * @private 
		 * 
		 */		
		protected override function measure():void
		{
			var index:int = 0, pointsLength:int = 0;
			var maxYZoom:Number = 0, xModification:Number = 0, yModification:Number = 0;
			var points:Vector.<Number>;
			var pointX:Number = 0, pointY:Number = 0;
			
			super.measure();

			calculateSize();
			
			tempX = (bounds.minX * zoom);
			tempY = (bounds.minY * zoom);
			
			xModification = (bounds.minX * zoom) + tempX;
			yModification = offsetY + tempY;
			
			maxYZoom = bounds.maxY * zoom;
			
			bitmapData = new BitmapData(measuredWidth, measuredHeight, true);
			
			for each (var shapeFileRecord:ShapeFileRecord in dataLayer.shapeFile.records)
			{
				points = IShapeFileContent(shapeFileRecord.content).getPoints();
				
				pointsLength = points.length;
				
				for (index = 0; index < pointsLength; index+=2)
				{
					pointX = (points[index] * zoom) - (bounds.minX * zoom);
					pointY = 90 - ((points[index+1] * zoom) - (bounds.maxY * zoom)) - offsetY;
					
					bitmapData.setPixel(int(pointX), int(pointY), 0x000000);
				}
			}
		}
		
		/**
		 * @private
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.clear();
			
			if (bitmapData)
			{
				graphics.beginBitmapFill(bitmapData);
				graphics.drawRect(0, 0, measuredWidth, measuredHeight);
				graphics.endFill();
			}
			
			x = y = 0;
		}
	}
}