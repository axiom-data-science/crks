package com.axiomalaska.integratedlayers.models.presentation_data.sensors
{
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.RealTimeDataMarker;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Sensor;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.SensorTypes;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.Station;
	import com.axiomalaska.integratedlayers.models.layers.data.stations_layer.StationsDataLayer;
	import com.axiomalaska.map.LatLon;
	import com.axiomalaska.map.types.google.overlay.SimpleMarker;
	import com.axiomalaska.utilities.Style;

	[Bindable]
	public class SensorLegendPM
	{
		public var scalar_realtime_active:Boolean = true;
		public var vector_realtime_active:Boolean = true;
		
		public var visible_sensor_limit:Number = 300;
		
		public var selected_scalar_preview_sensor:Sensor;
		public var selected_vector_preview_sensor:Sensor;
		
		public var poll_timeout:int = 2;
		
		public var stationDataLayer:StationsDataLayer;
		
		private var _marker_color:uint = 0xFFFFFF;
		private var _marker_alpha:Number = .9;
		private var _marker_size:Number = 4;
		private var _marker_stroke:uint = 0x666666;
		private var _marker_strokeSize:Number = 2;
		
		public var marker_style:Style = new Style({
			color:_marker_color,
			alpha:_marker_alpha,
			size:_marker_size,
			stroke:_marker_stroke,
			strokeSize:_marker_strokeSize	
		});
		
		
		public var web_cam_marker_style:Style = new Style({
			color:_marker_color,
			alpha:_marker_alpha,
			size:_marker_size,
			stroke:0x990000,
			strokeSize:_marker_strokeSize
		});
		
		public var tide_marker_style:Style = new Style({
			color:_marker_color,
			alpha:_marker_alpha,
			size:_marker_size,
			stroke:0x006699,
			strokeSize:_marker_strokeSize
		});
		
		
		public var highlight_style:Style = new Style({
			color:0xFFFFCC,
			size:_marker_size + 5,
			stroke:0x660000,
			strokeSize:_marker_strokeSize + 6
		});
	
		
		public function getStationMarker($station:Station):RealTimeDataMarker{
			var s:Style = marker_style;
			var m:RealTimeDataMarker;
			
			if($station.sensors.indexOf(stationDataLayer.sensors_type_map[SensorTypes.TIDES]) >= 0){
				m = getTideMarker($station,new LatLon($station.latitude,$station.longitude));
			}else if($station.sensors.indexOf(stationDataLayer.sensors_type_map[SensorTypes.WEB_CAM]) >= 0){
				m = getWebCamMarker($station,new LatLon($station.latitude,$station.longitude));
			}else{
				m = getMarker($station,new LatLon($station.latitude,$station.longitude));
			}
			
			
			var hm:SimpleMarker = new SimpleMarker(new LatLon(),null,marker_style);
			hm.draw();
			hm.visible = false;
			m.addChild(hm);
			m.id = 'pp' + $station.id;
			m.draw();
			return m;
		}
		
		public function getMarker($station:Station = null,$latlon:LatLon = null):RealTimeDataMarker{
			return new RealTimeDataMarker($latlon,{station:$station},marker_style);
		}
		
		public function getTideMarker($station:Station = null,$latlon:LatLon = null):RealTimeDataMarker{
			return new RealTimeDataMarker($latlon,{station:$station},tide_marker_style);
		}
		
		public function getWebCamMarker($station:Station = null,$latlon:LatLon = null):RealTimeDataMarker{
			return new RealTimeDataMarker($latlon,{station:$station},web_cam_marker_style);
		}
		
	}
}