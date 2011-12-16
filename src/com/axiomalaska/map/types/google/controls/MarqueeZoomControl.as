package com.axiomalaska.map.types.google.controls
{
	import com.google.maps.LatLng;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.controls.ControlBase;
	import com.google.maps.controls.ControlPosition;
	import com.google.maps.interfaces.IMap;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.Polygon;
	import com.google.maps.overlays.PolygonOptions;
	import com.google.maps.styles.FillStyle;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	
	public class MarqueeZoomControl extends ControlBase 
	{
		
		
		public var selected:Boolean = false;
		
		private var button:Sprite = new Sprite();
		private var polygon:Polygon;
		private var corner1:LatLng;
		private var corner2:LatLng;
		
		public var tooltip:String = 'Test';
		
		[Embed(source='/assets/images/google-maps-marquee-zoom-off.png')]
		private var iconOff:Class;

		[Embed(source='/assets/images/google-maps-marquee-zoom-on.png')]
		private var iconOn:Class;
		
		[Embed(source="/assets/cursors/crosshair.png")]
		private var crosshairCursor:Class;
		
		private var iconOnButton:Sprite = new Sprite();
		private var iconOffButton:Sprite = new Sprite();
		
		
		
		public function MarqueeZoomControl()
		{
			iconOnButton.addChild(new iconOn());
			iconOnButton.mouseChildren = false;
			iconOffButton.addChild(new iconOff());
			iconOffButton.mouseChildren = false;
			super(new ControlPosition(ControlPosition.ANCHOR_TOP_LEFT,iconOffButton.width/4 + 13,128,ControlPosition.AUTO_ALIGN_X));
		}
		
		public override function initControlWithMap($map:IMap):void{
			super.initControlWithMap($map);
			createButton();
			
		}
		
		private function createButton():void{
			button.graphics.beginFill(0xFFFFFF,.4);
			button.graphics.drawCircle(iconOffButton.width/2,iconOffButton.width/2,iconOffButton.width/2);
			button.addEventListener(MouseEvent.CLICK,onButtonClick);
			button.buttonMode = true;
			addChild(button);
			styleButton();
		}
		
		private function styleButton():void{
			
			while(button.numChildren > 0){
				button.removeChildAt(0);
			}
			
			if(selected){
				button.addChild(iconOnButton);
			}else{
				button.addChild(iconOffButton);
			}
		}
		
		
		private function onButtonClick($evt:MouseEvent):void{
			selected = !selected;
			
			if(selected){
				initDrawMarqueeMode();
			}else{
				endDrawMarqueeMode();
			}
			
		}
		
		private function initDrawMarqueeMode():void{
			map.addEventListener(MapMouseEvent.MOUSE_DOWN,onDrawInit);
			map.disableDragging();
			map.addEventListener(MapMouseEvent.MOUSE_MOVE,addCrosshairCursor);
			map.addEventListener(MapMouseEvent.ROLL_OUT,removeCrosshairCursor);
			styleButton();
		}
		
		private function endDrawMarqueeMode():void{
			map.removeEventListener(MapMouseEvent.MOUSE_DOWN,onDrawInit);
			map.removeEventListener(MapMouseEvent.MOUSE_MOVE,addCrosshairCursor);
			map.removeEventListener(MapMouseEvent.ROLL_OUT,removeCrosshairCursor);
			map.enableDragging();
			selected = false;
			removeCrosshairCursor();
			styleButton();
		}
		
		private function onDrawInit($evt:MapMouseEvent):void{
			corner1 = $evt.latLng;
			corner2 = $evt.latLng;
			var po:PolygonOptions = new PolygonOptions();
			po.fillStyle = new FillStyle();
			po.fillStyle.alpha = 0;
			polygon = new Polygon([],po);
			map.addOverlay(polygon);
			map.addEventListener(MapMouseEvent.MOUSE_MOVE,onDraw);
			map.addEventListener(MapMouseEvent.MOUSE_UP,onMarqueeComplete);
		}
		
		private function onDraw($evt:MapMouseEvent):void{
			corner2 = $evt.latLng;
			
			var l1:Number = corner1.lng();
			var l2:Number = corner2.lng();
			if(l1 > 0){
				l1 = - 180 - (180-l1);
			}
			if(l2 > 0){
				l2 = - 180 - (180-l2);
			}
			

			
			polygon.setPolyline(
				1,
				[
					new LatLng(corner1.lat(),l1,true),
					new LatLng(corner1.lat(),l2,true),
					new LatLng(corner2.lat(),l2,true),
					new LatLng(corner2.lat(),l1,true)
				]
			);
		}
		
		private function onMarqueeComplete($evt:MapMouseEvent):void{
			map.removeEventListener(MapMouseEvent.MOUSE_MOVE,onDraw);
			map.removeEventListener(MapMouseEvent.MOUSE_UP,onMarqueeComplete);
			if(polygon && polygon.getLatLngBounds()){
				map.setCenter(polygon.getLatLngBounds().getCenter(),map.getBoundsZoomLevel(polygon.getLatLngBounds()));
				map.removeOverlay(polygon);
			}else{
				map.setCenter($evt.latLng,map.getZoom() + 1);
			}
			endDrawMarqueeMode();
			
			
		}
		
		private function addCrosshairCursor($evt:MapMouseEvent=null):void{
			CursorManager.setCursor(crosshairCursor,CursorManagerPriority.LOW,-10,-10);
		}
		
		private function removeCrosshairCursor($evt:MapMouseEvent=null):void{
			CursorManager.removeAllCursors();
		}
	}
}