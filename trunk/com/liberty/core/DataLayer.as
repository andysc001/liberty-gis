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
package com.liberty.core
{
	import com.liberty.files.dbf.DBF;
	import com.liberty.files.shapefile.ShapeFile;
	
	import mx.core.UIComponent;
	
	/**
	 * The DataLayer class represents a layer of ShapeFile content and associated DBF records to be drawn on a map.
	 * 
	 * You create a new DataLayer instance, set its associated ShapeFile and DBF properties, and add it to a map's
	 * layer vector.  Then invalidate the Map's displayList (invalidateDisplayList method) to view the new content.
	 * 
	 * DataLayers are drawn based on their position index in the layers vector.  A DataLayer at the zero index is drawn first,
	 * while a DataLayer at the first index is drawn on top.
	 * 	 
	 * @includeExample DataLayerExample.mxml
	 */
	public class DataLayer
	{
		
		/**
		 * A vector of UIComponents that were added to represent the graphic data of the DataLayer.
		 */
		public var components:Vector.<UIComponent>;
		
		/**
		 * The DBF file associated with the DataLayer.
		 */
		public var dbf:DBF;
		
		/**
		 * A Boolean value indicating whether the DataLayer has been initially drawn and displayed on the Map.
		 * If it has, the map will simply redraw the UIComponents instead of adding them.
		 */
		public var displayed:Boolean = false;
		
		/**
		 * The default fillColor of the UIComponents associated with the DataLayer.
		 */
		public var fillColor:uint = 0xCCCCCC;
		
		/**
		 * The default lineColor of the UIComponents associated with the DataLayer.
		 */
		public var lineColor:uint = 0x000000;
		
		/**
		 * The default lineThickness of the UIComponents associated with the DataLayer.
		 */ 
		public var lineThickness:Number = 1;
		
		/**
		 * Whether UIComponent associated with the DataLayer can receive mouse interaction.
		 */		
		public var mouseEnabled:Boolean = false;
		
		/**
		 * The ShapeFile associated with the DataLayer.
		 */
		public var shapeFile:ShapeFile;
		
		/**
		 * Whether the DataLayer is visible.
		 */
		private var _visible:Boolean = true;
		
		/**
		 * Constructor.
		 * @param shapeFile The ShapeFile associated with the DataLayer.
		 * @param dbf The DBF file associated with the DataLayer.
		 * @param displayed Whether the DataLayer has been displayed on the Map.
		 * @param mouseEnabled Whether UIComponent associated with the DataLayer can receive mouse interaction.
		 */
		public function DataLayer(shapeFile:ShapeFile=null, dbf:DBF=null, displayed:Boolean=false, mouseEnabled:Boolean=false)
		{
			components = new Vector.<UIComponent>;
			
			this.shapeFile = shapeFile;
			this.dbf = dbf;
			this.displayed = displayed;
			this.mouseEnabled = mouseEnabled;
		}
		
		/**
		 * @private
		 */
		public function get visible():Boolean
		{
			return _visible;
		}
		
		/**
		 * @private
		 */
		public function set visible(boolean:Boolean):void
		{
			_visible = boolean;
			
			for each (var component:UIComponent in components)
			{
				component.visible = component.includeInLayout = _visible;
			}
		}
	}
}