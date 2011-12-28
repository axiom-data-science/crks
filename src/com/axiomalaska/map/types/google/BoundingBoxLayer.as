package com.axiomalaska.map.types.google
{
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.map.events.BoundingBoxEvent;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import com.google.maps.overlays.Polygon;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class BoundingBoxLayer extends GoogleLayer
	{
		
		public var corner1:Marker;
		public var corner2:Marker;
		public var tools:Sprite = new Sprite();
		private var tools_marker:Marker;
		public var polygon:Polygon;
		public var box:Sprite = new Sprite();
		public var modal:Sprite = new Sprite();
		public var brdr:Sprite = new Sprite();
		
		[Embed(source="/assets/utilities/draggable-corner.png")]
		public var draggableCorner:Class;
		
		
		public function BoundingBoxLayer($name:String=null)
		{
			super($name);
		}
		
		//inverse mask:
		//http://franto.com/inverse-masking-disclosed/
		
		public function addTool($tool:DisplayObject):void{
			$tool.x = tools.width;
			tools.addChild($tool);
			tools.y = -1 * tools.height;
			tools.x = -1 * tools.width - 5;
		}
		
		public function startBoundingBox($start:LatLon = null):void{
			
			
			var f:InteractiveObject = this.foreground as InteractiveObject;
			f.mouseEnabled = false;
			f.parent.mouseEnabled = false;
			
			
			var m:Map = pane.map as Map;
			m.addEventListener(MapEvent.SIZE_CHANGED,function($evt:MapEvent):void{
				drawModal();
			});
			drawModal();
			//blendMode = BlendMode.LAYER;
			box.blendMode = BlendMode.ERASE;
			//addChild(modal);
			blendMode = BlendMode.LAYER;
			addChild(modal);
			modal.addChild(box);
			modal.addChild(brdr);
			modal.mouseEnabled = false;
			box.mouseEnabled = false;
			brdr.mouseEnabled = false;
			this.mouseEnabled = false;
			
			
			corner1 = new Marker(new LatLng($start.latitude,$start.longitude),_formatCornerMarker());
			corner2 = new Marker(new LatLng($start.latitude,$start.longitude),_formatCornerMarker());
			corner1.addEventListener(MapMouseEvent.DRAG_STEP,dragCorner);
			corner1.addEventListener(MapMouseEvent.DRAG_END,dragEnd);
			corner2.addEventListener(MapMouseEvent.DRAG_STEP,dragCorner);
			corner2.addEventListener(MapMouseEvent.DRAG_END,dragEnd);
			pane.addOverlay(corner1);
			pane.addOverlay(corner2);
			

			
			
			var tools_ops:MarkerOptions = new MarkerOptions();
			tools_ops.icon = tools;
			tools_ops.hasShadow = false;
			
			tools_marker = new Marker(new LatLng($start.latitude,$start.longitude),tools_ops);
			pane.addOverlay(tools_marker);
			

			
			polygon = new Polygon([]);
			
			//pane.map.addOverlay(polygon);
			
			pane.map.addEventListener(MapMouseEvent.MOUSE_MOVE,initialDrag);
			pane.map.addEventListener(MapMouseEvent.MOUSE_UP,removeInitialDrag);
			
			enableDrawing();
			function initialDrag($evt:MapMouseEvent):void{
				corner2.setLatLng($evt.latLng);	
				drawPolygon();
			}
			
			function removeInitialDrag($evt:MapMouseEvent):void{
				pane.map.removeEventListener(MapMouseEvent.MOUSE_MOVE,initialDrag);
				pane.map.removeEventListener(MapMouseEvent.MOUSE_UP,removeInitialDrag);
				dragEnd($evt);
			}
			
			//dispatchEvent(new BoundingBoxEvent(BoundingBoxEvent.BOUNDING_BOX_DRAW_START));
			
		}
		
		public function clearBoundingBox():void{
			if(corner1){
				pane.removeOverlay(corner1);
				corner1 = null;
			}
			if(corner2){
				pane.removeOverlay(corner2);
				corner2 = null;
			}
			if(polygon){
				pane.removeOverlay(polygon);
				polygon = null;
			}
			
			if(tools_marker){
				pane.removeOverlay(tools_marker);
			}
			
			if(modal && contains(modal)){
				removeChild(modal);
			}
			
			dispatchEvent(new BoundingBoxEvent(BoundingBoxEvent.BOUNDING_BOX_CLOSE));
		}
		
		private function drawModal():void{
			var m:Map = pane.map as Map;
			modal.graphics.clear();
			modal.graphics.beginFill(0x333333,.5);
			modal.graphics.drawRect(0,0,m.width,m.height);
		}
		
		private function _formatCornerMarker():MarkerOptions{
			var ops:MarkerOptions = new MarkerOptions();
			ops.draggable = true;
			ops.icon = new draggableCorner();
			ops.gravity = 0;
			ops.iconOffset = new Point(-1* ops.icon.width/2,-1* ops.icon.height/2);
			return ops;
		}
		
		private function drawPolygon():void{
			
			if(corner1 && corner2){
				box.graphics.clear();
				box.graphics.beginFill(0xFFFFFF);
				
				brdr.graphics.clear();
				brdr.graphics.lineStyle(2,0x333333);
				
				var pt1:Point = pane.fromLatLngToPaneCoords(corner1.getLatLng(),true);
				var pt2:Point = pane.fromLatLngToPaneCoords(corner2.getLatLng(),true);
				
				
				box.x = pt1.x;
				box.y = pt1.y;
				box.graphics.drawRect(0,0,pt2.x - pt1.x,pt2.y - pt1.y);
				
				brdr.x = pt1.x;
				brdr.y = pt1.y;
				brdr.graphics.drawRect(0,0,pt2.x - pt1.x,pt2.y - pt1.y);
				
				polygon.setPolyline(
					1,
					[
						new LatLng(corner1.getLatLng().lat(),corner1.getLatLng().lng(),true),
						new LatLng(corner1.getLatLng().lat(),corner2.getLatLng().lng(),true),
						new LatLng(corner2.getLatLng().lat(),corner2.getLatLng().lng(),true),
						new LatLng(corner2.getLatLng().lat(),corner1.getLatLng().lng(),true)
					]
				);
				
				tools_marker.setLatLng(polygon.getLatLngBounds().getNorthEast());
			}

		}
		
		private function enableDrawing():void{
			//dispatch start drawing event
			pane.map.disableDragging();
			tools.alpha = .1;
			
		}
		
		private function disableDrawing():void{
			//dispatch done drawing event
			pane.map.enableDragging();
			tools.alpha = 1;
		}
		
		private function dragEnd($evt:MapMouseEvent):void{
			disableDrawing();
			var _evt:Event = new Event(Event.CHANGE);
			this.dispatchEvent(_evt);
			var bnds:LatLngBounds = polygon.getLatLngBounds();
			if(bnds){
				var cr1:LatLon = new LatLon(bnds.getSouth(),bnds.getWest());
				var cr2:LatLon = new LatLon(bnds.getNorth(),bnds.getEast());
				dispatchEvent(new BoundingBoxEvent(BoundingBoxEvent.BOUNDING_BOX_DRAW_END,cr1,cr2));
			}
		}
		
		private function dragCorner($evt:MapMouseEvent):void{
			enableDrawing();
			drawPolygon();
		}
		
		
		public override function positionOverlay($zoomChanged:Boolean):void{
			drawPolygon();
		}
		
		
		
		
	}
}