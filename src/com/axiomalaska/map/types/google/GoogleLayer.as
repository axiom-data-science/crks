package com.axiomalaska.map.types.google
{

	import com.axiomalaska.map.features.MapFeature;
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.types.google.event.PositionOverlayEvent;
	import com.axiomalaska.utilities.Style;
	import com.google.maps.LatLng;
	import com.google.maps.PaneId;
	import com.google.maps.interfaces.IMap;
	import com.google.maps.interfaces.IPane;
	import com.google.maps.overlays.OverlayBase;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	
	
	
	public class GoogleLayer extends OverlayBase implements ILayer
	{
		
		private var _label:String;
		private var _icon:DisplayObject;
		private var _style:Style;
		private var _features:Array = new Array();
		private var _zindex:int = -1;
		public var featuresById:Object = new Object();
		
	
		
		public function GoogleLayer($name:String = null)
		{
			super();
			if($name){
				name = $name;
			}
			this.addEventListener(PositionOverlayEvent.POSITION_OVERLAY_EVENT,onPositionOverlayEvent);
		}
		
		//INTERFACES
		
		
		public function removeAllFeatures():void{
			for each(var _feature:MapFeature in features){
				if(this.contains(_feature)){
					this.removeChild(_feature);
				}
			}
			features = [];
			featuresById = {};
			
		}
		
		public function removeFeature($feature:MapFeature):void{
			if(this.contains($feature)){
				this.removeChild($feature);
			}
		}
		
		public function addFeature($feature:MapFeature):void
		{
			features.push($feature);
			featuresById[$feature.id] = $feature;
			$feature.draw();
			this.addChild($feature);
		}
		
		
		public function set features($features:Array):void{
			_features = $features;
		}
		public function get features():Array{
			return _features;
		}
		
		public function set label($label:String):void{
			_label = $label;
		}
		
		public function get label():String{
			return _label;
		}

		public function set icon($icon:DisplayObject):void{
			_icon = $icon;
		}
		public function get icon():DisplayObject{
			return _icon;
		}
		
		public function set style($style:Style):void{
			_style = $style;
		}
		public function get style():Style{
			return _style;
		}
		
		public function get zindex():int{
			return _zindex;
		}
		public function set zindex($zindex:int):void{
			_zindex = $zindex;
		}
		
		public function draw():void{
			//
		}
		public function redraw():void{
			this.positionOverlay(false);
		}
		public function hide():void{
			this.visible = false;
		}
		public function show():void{
			this.visible = true;	
		}
		
		//OVERRIDES
		
		override public function positionOverlay(arg0:Boolean):void {
			
			
			var e : PositionOverlayEvent = new PositionOverlayEvent( PositionOverlayEvent.POSITION_OVERLAY_EVENT );
			e.zoomChange = arg0;
			dispatchEvent( e );
			
		}
		
		override public function getDefaultPane(arg0:IMap):IPane {
			return ( arg0.getPaneManager().getPaneById( PaneId.PANE_OVERLAYS ) );
		}
		
		
		//CUSTOM
		
		public function getPointForLatLng( position : LatLng ) : Point {
			
			if ( pane ) {    
				return pane.fromLatLngToPaneCoords( position );
			} else {
				return null;
			}
			
		}
		
		private function onPositionOverlayEvent($evt:PositionOverlayEvent):void{
			var panDelta : Point;
			
			var ctr:LatLng = pane.map.getCenter();
			var w:Number = pane.getViewportBounds().width;
			
			if(features.length > 0){
				if ( !$evt.zoomChange ) {
					
					var refMarker : Object = features[0];
					
					var oldPosition : Point = new Point(  featuresById[ String( refMarker.id ) ].x, featuresById[ String( refMarker.id ) ].y );
					var newPosition : Point = this.getPointForLatLng( new LatLng(refMarker.latlon.latitude,refMarker.latlon.longitude) );
					
					panDelta = new Point( newPosition.x - oldPosition.x, newPosition.y - oldPosition.y );
				}
				
				for each ( var mD:Object in _features ) {
					
					var marker:DisplayObject = featuresById[String( mD.id )];
					
					var position : Point;
					
					if ( $evt.zoomChange ) {
						position = this.getPointForLatLng( new LatLng(mD.latlon.latitude,mD.latlon.longitude) );
						/*if(position.x > w){
							var l:Number = mD.latlon.longitude;
							if(ctr.lng() < 0){
								if(l > 0){
									l = -180 - (180 - l);
								}
							}else{
								if(l < 0){
									l = 180 + (180 - Math.abs(l));
								}
							}
							position = this.getPointForLatLng( new LatLng(mD.latlon.latitude,l,true));
						}*/
						
					} else {
						if ( panDelta ) 
							position = new Point( marker.x + panDelta.x, marker.y + panDelta.y );
					}
					
					if ( position ) {
						//trace(pane.map.getCenter());
						//trace(pane.getViewportBounds());
						//trace(mD.latlon.latitude + ',' + mD.latlon.longitude + ' // ' + position.x + ' / ' + position.y);
						if(position.x > w || position.x < 0){
							//trace('doing it..');
							var l:Number = mD.latlon.longitude;
							if(ctr.lng() < 0){
								if(l > 0){
									l = -180 - (180 - l);
								}
							}else{
								if(l < 0){
									l = 180 + (180 - Math.abs(l));
								}
							}
							position = this.getPointForLatLng( new LatLng(mD.latlon.latitude,l,true));
							//trace(position);
						}
						marker.x = position.x;
						marker.y = position.y;
						
					}
				}
			}
		}
		
		
	}
}