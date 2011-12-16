package com.axiomalaska.map.types.google.overlay
{
	
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class RenderQueueItem
	{
		public var tile:BitmapData
		public var tilePoint:Point;
		public var tileZoom:Number;
		public var startLatSector:Number;
		public var endLatSector:Number;
		public var currentLatSector:Number;
		public var currentLngSector:Number;
		public var startLngSector:Number;
		public var endLngSector:Number;
		public var lastPoint:int;
		public var data:Object;
		
		public var currentDepth:int = 0;
		public var depths:Array;
		
	}
	
}