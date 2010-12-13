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
package com.liberty.events
{
	import com.liberty.controls.MapItem;
	import com.liberty.core.DataLayer;
	
	import flash.events.Event;
	
	/**
	 * The MapEvent class represents event objects that are specific to the Map control, such as when a child MapItem instances is clicked.
	 * 
	 * @see com.liberty.controls.Map
	 * 
	 * @includeExample MapEventExample.mxml
	 */	
	public class MapEvent extends Event
	{	
		/**
		 *  The MapEvent.DATALAYERDRAWN event type constant indicates that a Data
		 *  layer has been drawn on the map.
		 *
		 *  <p>The properties of the event object for this event type have the
		 *  following values.
		 *  Not all properties are meaningful for all kinds of events.
		 *  See the detailed property descriptions for more information.</p>
		 * 
		 *  <table class="innertable">
		 *     	<tr><th>Property</th><th>Value</th></tr>
		 *     	<tr>
		 * 			<td><code>bubbles</code></td>
		 * 			<td>false</td>
		 * 		</tr>
		 *     	<tr>
		 * 			<td><code>cancelable</code></td>
		 * 			<td>false</td>
		 * 		</tr>
		 *     	<tr>
		 * 			<td><code>currentTarget</code></td>
		 * 			<td>The Object that defines the
		 *       	event listener that handles the event. For example, if you use
		 *      	<code>myButton.addEventListener()</code> to register an event listener,
		 *       	myButton is the value of the <code>currentTarget</code>. </td>
		 * 		</tr>
		 *     	<tr>
		 * 			<td><code>dataLayer</code></td>
		 *     		<td>The DataLayer instance triggering the event
		 *       		Use the <code>currentTarget</code> property to always access the
		 *       		Object listening for the event.
		 * 			</td>
		 * 		</tr>
		 *     	<tr>
		 * 			<td><code>type</code></td>
		 * 			<td>TreeEvent.ITEM_CLOSE</td>
		 * 		</tr>
		 *  </table>
		 *  @eventType mapitemclick
		 */
		public static const DATALAYERDRAWN:String = "datalayerdrawn";
		
		/**
		 *  The MapEvent.MAPITEMCLICK event type constant indicates that a Map
		 *  has had a child MapItem clicked.
		 *
		 *  <p>The properties of the event object for this event type have the
	     *  following values.
	     *  Not all properties are meaningful for all kinds of events.
	     *  See the detailed property descriptions for more information.</p>
	     * 
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
	     *       event listener that handles the event. For example, if you use
	     *       <code>myButton.addEventListener()</code> to register an event listener,
	     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>index</code></td>
	     *         <td>The child index of the MapItem</td></tr>
		 *     <tr><td><code>mapItem</code></td>
	     *         <td>The MapItem instance trigger the event</td></tr>
	     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
	     *       it is not always the Object listening for the event.
	     *       Use the <code>currentTarget</code> property to always access the
	     *       Object listening for the event.</td></tr>
	     *     <tr><td><code>type</code></td><td>TreeEvent.ITEM_CLOSE</td></tr>
	     *  </table>
		 *  @eventType mapitemclick
		 */	
		public static const MAPITEMCLICK:String = "mapitemclick";
		
		/**
		 *  The MapEvent.MAPITEMOUT event type constant indicates that the mouse
		 *  has moved out from a MapItem.
		 *
		 *  <p>The properties of the event object for this event type have the
		 *  following values.
		 *  Not all properties are meaningful for all kinds of events.
		 *  See the detailed property descriptions for more information.</p>
		 * 
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
		 *       event listener that handles the event. For example, if you use
		 *       <code>myButton.addEventListener()</code> to register an event listener,
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>index</code></td>
		 *         <td>The child index of the MapItem</td></tr>
		 *     <tr><td><code>mapItem</code></td>
		 *         <td>The MapItem instance trigger the event</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>type</code></td><td>TreeEvent.ITEM_CLOSE</td></tr>
		 *  </table>
		 *  @eventType mapitemclick
		 */
		public static const MAPITEMOUT:String = "mapitemout";
		
		/**
		 *  The MapEvent.MAPITEMOVER event type constant indicates that the mouse
		 *  has moved over a MapItem.
		 *
		 *  <p>The properties of the event object for this event type have the
		 *  following values.
		 *  Not all properties are meaningful for all kinds of events.
		 *  See the detailed property descriptions for more information.</p>
		 * 
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
		 *       event listener that handles the event. For example, if you use
		 *       <code>myButton.addEventListener()</code> to register an event listener,
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>index</code></td>
		 *         <td>The child index of the MapItem</td></tr>
		 *     <tr><td><code>mapItem</code></td>
		 *         <td>The MapItem instance trigger the event</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
		 *       it is not always the Object listening for the event.
		 *       Use the <code>currentTarget</code> property to always access the
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>type</code></td><td>TreeEvent.ITEM_CLOSE</td></tr>
		 *  </table>
		 *  @eventType mapitemclick
		 */
		public static const MAPITEMOVER:String="mapitemover";
		
		/**
		 * The DataLayer of the MapItem. 
		 */	
		public var dataLayer:DataLayer;
		
		/**
		 * The child display index of the MapItem. 
		 */		
		public var index:int = -1;
		
		/**
		 * A reference to the MapItem instance triggering the event.
		 */		
		public var mapItem:MapItem;
		
		/**
		 * Constructor 
		 * @param type The type of event.
		 * @param bubbles Indicates whether an event is a bubbling event.
		 * @param cancelable Indicates whether the behavior associated with the event can be prevented.
		 * 
		 */
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}