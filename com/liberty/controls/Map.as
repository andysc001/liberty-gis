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
	import com.liberty.events.MapEvent;
	import com.liberty.files.shapefile.Bounds;
	import com.liberty.files.shapefile.ShapeFileRecord;
	import com.liberty.files.shapefile.content.ShapeFileContentTypes;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when a DataLayer is drawn on the map
	 *
	 *  @eventType com.liberty.events.MapEvent.DATALAYERDRAWN
	 */
	[Event(name="datalayerdrawn", type="com.liberty.events.MapEvent")]
	
	/**
	 *  Dispatched when a MapItem instance is clicked.
	 *
	 *  @eventType com.liberty.events.MapEvent.MAPITEMCLICK
	 */
	[Event(name="mapitemclick", type="com.liberty.events.MapEvent")]
	
	/**
	 *  Dispatched when the user moves a pointing device away from a MapItem instance.
	 *
	 *  @eventType com.liberty.events.MapEvent.MAPITEMOUT
	 */
	[Event(name="mapitemout", type="com.liberty.events.MapEvent")]
	
	/**
	 *  Dispatched when the user moves a pointing device over a MapItem instance.
	 *
	 *  @eventType com.liberty.events.MapEvent.MAPITEMOVER
	 */
	[Event(name="mapitemover", type="com.liberty.events.MapEvent")]
	
	/**
	 * The Map class draws geographical data from ShapeFiles.  You do so by adding DataLayer instances to the
	 * layers property and then invalidating the display list.
	 * 
	 * @includeExample MapExample.mxml
	 * 
	 */	
	public class Map extends Canvas
	{
		//--------------------------------------
		//  Properties
		//--------------------------------------
		
		/**
		 * The DataLayers to be drawn on the map. 
		 */		
		public var layers:Vector.<DataLayer> = new Vector.<DataLayer>;
		
		/**
		 * @private 
		 */
		private var maxX:Number = -9999999999;
		
		/**
		 * @private 
		 */
		private var maxY:Number = -9999999999;
		
		/**
		 * @private 
		 */
		private var minX:Number = Infinity;
		
		/**
		 * @private 
		 */
		private var minY:Number = Infinity;
		
		/**
		 * @private 
		 */
		private var zoom:Number = 1;
		
		//--------------------------------------
		//  Constructor
		//--------------------------------------
		
		/**
		 * Constructor 
		 * 
		 */		
		public function Map()
		{
			super();
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Adds a DataLayer to the map 
		 * @param dataLayer The DataLayer instance to be added to the map.
		 * 
		 */	
		public function addLayer(dataLayer:DataLayer):void
		{
			layers.push(dataLayer);
		}
		
		/**
		 * @private 
		 */		
		protected override function childrenCreated():void
		{
			super.childrenCreated();
			
			if (getStyle("backgroundColor") == undefined)
				setStyle("backgroundColor", 0xCCCCCC);
			
			if (height == 0 && percentHeight == 0)
				percentHeight = 100;
			
			if (width == 0 && percentWidth == 0)
				percentWidth = 100;
		}
		
		/**
		 * @private
		 * Draws the DataLayer instance on the map, adding associated UIComponents as necessary.
		 */
		private function drawLayer(dataLayer:DataLayer):void
		{
			var bounds:Bounds = getDataLayerBounds();
			var layer:DataLayer;
			var mapBitmap:MapBitmap;
			var mapItem:MapItem;
			var maxX:Number = -9999999999, maxY:Number = -9999999999, minX:Number = Infinity, minY:Number = Infinity;
			var shapeFileRecord:ShapeFileRecord;
			
			zoom = getZoom();
			
			maxX = 180 + ((bounds.maxX * zoom) - (bounds.minX * zoom));
			maxY = 90 - ((bounds.maxY * zoom) - (bounds.minY * zoom));
			minX = 180 + ((bounds.minX * zoom) - (bounds.minX * zoom));
			minY = 90 - ((bounds.minY * zoom) - (bounds.minY * zoom));
			 
			if (dataLayer.shapeFile.type == ShapeFileContentTypes.POINT)
			{
				mapBitmap = new MapBitmap(dataLayer, bounds, minX, minY, zoom);
				
				mapBitmap.mouseEnabled = mapBitmap.useHandCursor = mapBitmap.buttonMode = dataLayer.mouseEnabled;
				
				addChild(mapBitmap);
				
				dataLayer.components.push(mapBitmap);
			}
			else
			{
				for each (shapeFileRecord in dataLayer.shapeFile.records)
				{	
					switch (shapeFileRecord.type)
					{
						case ShapeFileContentTypes.POLYGON:
							mapItem = new MapItemPolygon(shapeFileRecord, bounds, minX, maxY, zoom);
							break;
						case ShapeFileContentTypes.POLYGON_M:
							mapItem = new MapItemPolygon(shapeFileRecord, bounds, minX, maxY, zoom);
							break;
						case ShapeFileContentTypes.POLYGON_Z:
							mapItem = new MapItemPolygon(shapeFileRecord, bounds, minX, maxY, zoom);
							break;
						case ShapeFileContentTypes.POLYLINE:
							mapItem = new MapItemPolyline(shapeFileRecord, bounds, minX, maxY, zoom);
							break;
						case ShapeFileContentTypes.POLYLINE_M:
							mapItem = new MapItemPolyline(shapeFileRecord, bounds, minX, maxY, zoom);
							break;
						case ShapeFileContentTypes.POLYLINE_Z:
							mapItem = new MapItemPolyline(shapeFileRecord, bounds, minX, maxY, zoom);
							break;
						default:
							mapItem = new MapItem(shapeFileRecord, bounds, minX, maxY, zoom);
							break;
					}
					
					if (mapItem)
					{	
						mapItem.mouseEnabled = mapItem.useHandCursor = mapItem.buttonMode = dataLayer.mouseEnabled;
						
						mapItem.setStyle("fillColor", dataLayer.fillColor);
						mapItem.setStyle("lineColor", dataLayer.lineColor);
						mapItem.setStyle("lineThickness", dataLayer.lineThickness);
						
						addChild(mapItem);
						
						if (dataLayer.dbf)
						{
							try
							{
								mapItem.dbfRecord = dataLayer.dbf.records[dataLayer.components.length];
							}
							catch (error:Error)
							{
								
							}
						}
						
						dataLayer.components.push(mapItem);
					}
				}
			}
			
			var event:MapEvent = new MapEvent(MapEvent.DATALAYERDRAWN);
			
			event.dataLayer = dataLayer;
			
			dispatchEvent(event);
		}
		
		/**
		 * Returns the bounds of the data layers.
		 */
		public function getDataLayerBounds():Bounds
		{
			var bounds:Bounds = new Bounds();
			var layer:DataLayer;
			
			for each (layer in layers)
			{
				bounds.maxX = Math.max(bounds.maxX, layer.shapeFile.shapeFileBounds.maxX);
				bounds.maxY = Math.max(bounds.maxY, layer.shapeFile.shapeFileBounds.maxY);
				bounds.minX = Math.min(bounds.minX, layer.shapeFile.shapeFileBounds.minX);
				bounds.minY = Math.min(bounds.minY, layer.shapeFile.shapeFileBounds.minY); 
			}
			
			return bounds;
		}
		
		/**
		 * Returns the optimal zoom factor based on the unscaledWidth, unscaledHeight, and content sizes.
		 */
		public function getZoom():Number
		{
			var dataLayer:DataLayer;
			var maxX:Number = -9999999999, maxY:Number = -9999999999, minX:Number = Infinity, minY:Number = Infinity;
			
			for each (dataLayer in layers)
			{
				maxX = Math.max(maxX, dataLayer.shapeFile.shapeFileBounds.maxX);
				maxY = Math.max(maxY, dataLayer.shapeFile.shapeFileBounds.maxY);
				minX = Math.min(minX, dataLayer.shapeFile.shapeFileBounds.minX);
				minY = Math.min(minY, dataLayer.shapeFile.shapeFileBounds.minY);
			}
			
			return Math.min(unscaledWidth / (maxX - minX), unscaledHeight / (maxY - minY));	
		}
		
		/**
		 * @private
		 * Refreshses the DataLayer, redrawing all UIComponent instances associated with the DataLayer.
		 */		
		private function refreshLayer(dataLayer:DataLayer):void
		{
			var bounds:Bounds = getDataLayerBounds();
			var component:UIComponent;
			var layer:DataLayer;
			var maxX:Number = 0, maxY:Number = 0, minX:Number = 0, minY:Number = 0;
			
			zoom = getZoom();
			
			maxX = 180 + ((bounds.maxX * zoom) - (bounds.minX * zoom));
			maxY = 90 - ((bounds.maxY * zoom) - (bounds.minY * zoom));
			minX = 180 + ((bounds.minX * zoom) - (bounds.minX * zoom));
			minY = 90 - ((bounds.minY * zoom) - (bounds.minY * zoom));
			
			for each (component in dataLayer.components)
			{	
				if (component is MapItem)
				{	
					MapItem(component).bounds = bounds;
					MapItem(component).offsetX = minX;
					MapItem(component).offsetY = minY;
					MapItem(component).zoom = zoom;
					
					MapItem(component).invalidateSize();
					MapItem(component).invalidateDisplayList();
				}
				else if (component is MapBitmap)
				{
					MapBitmap(component).bounds = bounds;
					MapBitmap(component).offsetX = minX;
					MapBitmap(component).offsetY = minY;
					MapBitmap(component).zoom = zoom;
					
					MapBitmap(component).invalidateSize();
					MapBitmap(component).invalidateDisplayList();
				}
				

			}
		}
		
		/**
		 * Refreshes the Map, redrawing all layers.
		 */
		public function refreshMap():void
		{
			zoom = 1;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * Removes a DataLayer from the map 
		 * @param dataLayer The DataLayer instance to be removed from the map.
		 * 
		 */	
		public function removeLayer(dataLayer:DataLayer):void
		{
			for each (var component:UIComponent in dataLayer.components)
			{
				removeChild(component);
			}
			
			layers.splice(layers.indexOf(dataLayer), 1);
			
			zoom = 1;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * @private 
		 */		
		protected override function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			for each (var dataLayer:DataLayer in layers)
			{
				if (dataLayer.displayed)
				{
					refreshLayer(dataLayer);
				}
				else
				{
					drawLayer(dataLayer);
				}
				
				dataLayer.displayed = true;
			}
		}
		
		//--------------------------------------
		//  Event Handlers
		//--------------------------------------
		
		/**
		 * @private 
		 */	
		private function onMouseOver(event:MouseEvent):void
		{
			if (event.target is MapItem)
			{	
				if (MapItem(event.target).mouseEnabled)
				{
					var mapEvent:MapEvent = new MapEvent(MapEvent.MAPITEMOVER);
					
					mapEvent.mapItem = MapItem(event.target) as MapItem;
					mapEvent.index = this.getChildIndex(event.target as MapItem);
		
					dispatchEvent(mapEvent);
				}
			}
		}
		
		/**
		 * @private 
		 */	
		private function onMouseOut(event:MouseEvent):void
		{
			if (event.target is MapItem)
			{
				var mapEvent:MapEvent = new MapEvent(MapEvent.MAPITEMOUT);

				mapEvent.mapItem = MapItem(event.target) as MapItem;
				mapEvent.index = getChildIndex(event.target as MapItem);
	
				dispatchEvent(mapEvent);
			}
		}
		
		/**
		 * @private 
		 */	
		private function onMouseDown(event:MouseEvent):void
		{
			if (event.target is MapItem)
			{
				var mapEvent:MapEvent = new MapEvent(MapEvent.MAPITEMCLICK);
				
				mapEvent.mapItem = MapItem(event.target) as MapItem;
				mapEvent.index = getChildIndex(event.target as MapItem);
	
				dispatchEvent(mapEvent);
			}
		}
		
		/**
		 * @private 
		 */	
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED, onRemovedFromStage);
			
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
	}
}