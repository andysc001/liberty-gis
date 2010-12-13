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
	import com.liberty.files.shapefile.IShapeFileContent;
	import com.liberty.files.shapefile.ShapeFileRecord;
	import com.liberty.files.shapefile.content.ShapeFileContentTypes;
	import com.liberty.files.shapefile.content.ShapeFilePolygon;
	import com.liberty.files.shapefile.content.ShapeFilePolyline;
	
	import mx.core.UIComponent;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  The fill color of the MapItem.
	 *
	 *  @default "0xCCCCCC"
	 */
	[Style(name="fillColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Line color of a MapItem.
	 *
	 *  @default "0x000000"
	 */
	[Style(name="lineColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Line thickness of a MapItem.
	 *
	 *  @default 1
	 */
	[Style(name="lineThickness", type="Number", inherit="yes")]
	
	
	/**
	 * The MapItem class draws geographical ShapeFileContent.
	 * 
	 */	
	public class MapItem extends UIComponent
	{
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * The bounds of the layer content.
		 */
		public var bounds:Bounds = new Bounds();
		
		/**
		 * A placeholder for arbitrary data. 
		 */		
		public var data:Object;
		
		/**
		 * An associated dbfRecord. 
		 */	
		public var dbfRecord:Object;
		
		/**
		 * @private 
		 */		
		protected var drawCommands:Vector.<int> = new Vector.<int>;
		
		/**
		 * @private 
		 */		
		protected var drawPoints:Vector.<Number>;
		
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
		 * The ShapeFileRecord used to draw the MapItem.
		 * 
		 */		
		public var shapeFileRecord:ShapeFileRecord;
		
		/**
		 * @private 
		 */		
		protected var tempX:Number = 9999;
		
		/**
		 * @private 
		 */		
		protected var tempY:Number = 9999;
		
		/**
		 * @private
		 * The zoom scale of the MapItem. 
		 */		
		public var zoom:Number = 1;
		
		//--------------------------------------
		//  Constructor
		//--------------------------------------
		
		/**
		 * Constructor 
		 * @param shapeFileRecord The ShapeFileRecord to draw.
		 * @param bounds The bounds of the MapItem.
		 * @param offsetX The x offset, in pixels, to draw the MapItem.
		 * @param offsetY The y offset, in pixels, to draw the MapItem
		 * @param zoom The zoom scale of the MapItem.
		 * 
		 */		
		public function MapItem(shapeFileRecord:ShapeFileRecord=null, bounds:Bounds=null, offsetX:Number = 0, offsetY:Number = 0, zoom:Number=1)
		{
			super();
			
			this.bounds = bounds;
			this.offsetX = offsetX;
			this.offsetY = offsetY;
			this.shapeFileRecord = shapeFileRecord;
			this.zoom = zoom;
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * @private
		 * Calculates the size of the MapItem. 
		 * 
		 */		
		public function calculateSize():void	
		{	
			measuredWidth = (bounds.maxX * zoom) - (bounds.minX * zoom) - tempX;
			measuredHeight = 90 - ((bounds.maxY * zoom) - (bounds.minY * zoom)) - offsetY - tempY;
			
			setActualSize(measuredWidth, measuredHeight);	
		}
		
		/**
		 * @private 
		 * 
		 */		
		protected override function childrenCreated():void
		{
			super.childrenCreated();
			
			if (getStyle("fillColor") == undefined)
				setStyle("fillColor", 0xCCCCCC);
			
			if (getStyle("lineColor") == undefined)
				setStyle("lineColor", 0x000000);
			
			if (getStyle("lineThickness") == undefined)
				setStyle("lineThickness", 0.5);
		}
		
		/**
		 * @private
		 * Populates the draw commands vector.  This is typically only done once.
		 */
		private function populateDrawCommands():void
		{
			var end:int = 0, index:int = 0, partIndex:int = 0, partsLength:int = 0, pointsLength:int = 0, start:int = 0;
			
			var parts:Vector.<int>;
			var points:Vector.<Number>;
			
			if (shapeFileRecord)
			{		
				parts = IShapeFileContent(shapeFileRecord.content).getParts();
				partsLength = parts.length;
				
				points = IShapeFileContent(shapeFileRecord.content).getPoints();
				pointsLength = points.length;
				
				drawCommands.splice(0, drawCommands.length);
				
				drawPoints = points.concat();
				
				for (partIndex = 0; partIndex < partsLength; partIndex++)
				{	
					start = partIndex == 0 ? parts[partIndex] : parts[partIndex] * 2;
					end = partIndex + 1 == parts.length ? points.length: parts[partIndex+1] * 2;
					
					drawCommands.push(1);
					
					for (index = start+2; index < end; index+=2)
					{
						drawCommands.push(2);
					}
				}
			}
		}
		
		/**
		 * @private 
		 * Returns whether a ShapeFileRecord type can be displayed in a MapItem component.
		 */	
		public static function isMapItemType(recordType:int):Boolean
		{
			var returnValue:Boolean = true;
			
			switch (recordType)
			{
				case ShapeFileContentTypes.MULTIPOINT:
					returnValue = false;
					break;
				case ShapeFileContentTypes.MULTIPOINT_M:
					returnValue = false;
					break;
				case ShapeFileContentTypes.MULTIPOINT_Z:
					returnValue = false;
					break;
				case ShapeFileContentTypes.POINT:
					returnValue = false;
					break;
				case ShapeFileContentTypes.POINT_M:
					returnValue = false;
					break;
				case ShapeFileContentTypes.POINT_Z:
					returnValue = false;
					break;
				default:
					break;
			}
			
			return returnValue;
		}
		
		/**
		 * @private 
		 * 
		 */		
		protected override function measure():void
		{
			super.measure();

			var end:int = 0, index:int = 0, partIndex:int = 0, partsLength:int = 0, pointsLength:int = 0, start:int = 0;
			
			var parts:Vector.<int>;
			var points:Vector.<Number>;
			
			var maxYZoom:Number = 0, xModification:Number = 0, yModification:Number = 0;
			
			if (shapeFileRecord)
			{	
				tempX = (bounds.minX * zoom);
				tempY = (bounds.minY * zoom);
				
				xModification = (bounds.minX * zoom) + tempX;
				yModification = offsetY + tempY;
				
				maxYZoom = bounds.maxY * zoom;
				
				if (!drawCommands.length)
				{
					populateDrawCommands();
				}
	
				parts = IShapeFileContent(shapeFileRecord.content).getParts();
				partsLength = parts.length;
				
				points = IShapeFileContent(shapeFileRecord.content).getPoints();
				pointsLength = points.length;
				
				drawPoints = points.concat();
				
				for (partIndex = 0; partIndex < partsLength; partIndex++)
				{	
					start = partIndex == 0 ? parts[partIndex] : parts[partIndex] * 2;
					end = partIndex + 1 == parts.length ? points.length: parts[partIndex+1] * 2;
					
					drawPoints[start] = (drawPoints[start] * zoom) - xModification;
					drawPoints[start+1] = 90 - ((drawPoints[start+1] * zoom) - maxYZoom) - yModification;
					
					for (index = start+2; index < end; index+=2)
					{
						drawPoints[index] = (drawPoints[index] * zoom) - xModification;
						drawPoints[index+1] = 90 - ((drawPoints[index+1] * zoom) - maxYZoom) - yModification;
					}
				}
				
				calculateSize();
			}
		}
	}
}