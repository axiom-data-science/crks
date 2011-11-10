package com.axiomalaska.crks.dto {
	import com.axiomalaska.map.interfaces.ILayerGroup;
	import com.axiomalaska.models.SpatialBounds;
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.crks.helpers.LayerTypes;
	import com.axiomalaska.crks.interfaces.ILegendItem;
	import com.axiomalaska.crks.interfaces.IMetaDataItem;
	import com.axiomalaska.crks.interfaces.ISpatialExtentItem;
	
	import mx.collections.ArrayCollection;

	// Generated May 25, 2011 4:36:19 PM by Hibernate Tools 3.2.2.GA
	
	[Bindable]
	[RemoteClass(alias="com.axiomalaska.crks.dto.LayerGroupDTO")]
	public class LayerGroup extends LayerGroupGenerated implements ILegendItem,ILayerGroup,ISpatialExtentItem,IMetaDataItem{
		
		//SET BY SERVICE
		public var hasMetadata:Boolean;
		
		//SET BY FLEX
		public var activeOnMap:Boolean = false;
		
		
		public var expanded:Boolean = false;
		public var hasHelpContent:Boolean;
		public var zindex:int;
		
		public var searchTerm:String;
		public function searchLayers():void{
			layers.filterFunction = null;
			layers.filterFunction = runLayerFilter;
			layers.refresh();
		}
		public function runLayerFilter($layer:Layer):Boolean{
			
			var ret:Boolean = false;
			var srch:String = $layer.label;
			
			if(srch.length > 0 && searchTerm){
				ret = srch.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1;
			}else{
				ret = true;
			}
			
			
			return ret;
		}
		
		public function set children($children:ArrayCollection):void{
			//just a getter
		}
		public function get children():ArrayCollection{
			return layers;
		}
		
		
		private var _temporal:Temporal;
		public function set temporal($temporal:Temporal):void{
			_temporal = $temporal;
		}
		public function get temporal():Temporal{
			if(startTimeUtc && endTimeUtc){
				_temporal = new Temporal();
				_temporal.startdate = startTimeUtc;
				_temporal.enddate = endTimeUtc;
			}
			return _temporal;
		}
		
		
		private var _visible:Boolean = true;
		public function set visible($visible:Boolean):void{
			_visible = $visible;
			for each(var layer:Layer in layers){
				layer.visible = $visible;
			}
		}
		public function get visible():Boolean{
			return _visible;
		}
		
		private var _spatialBounds:SpatialBounds;
		public function set spatialBounds($spatialBounds:SpatialBounds):void{
			_spatialBounds = $spatialBounds;
		}
		public function get spatialBounds():SpatialBounds{
			if(!_spatialBounds){
				if(maxLat && maxLng && minLat && minLng){
					_spatialBounds = new SpatialBounds(minLat,minLng,maxLat,maxLng);
				}else if(
					layers && 
					layers.length > 0
				){
					var l:Layer = layers.getItemAt(0) as Layer;
					_spatialBounds = l.spatialBounds;
				}
				
			}
			return _spatialBounds;
		}
		
		private var _hasTimeComponent:Boolean;
		public function set hasTimeComponent($hasTimeComponent:Boolean):void{
			_hasTimeComponent = $hasTimeComponent;
		}
		public function get hasTimeComponent():Boolean{
			if(!_hasTimeComponent){
				if(this.startTimeUtc && this.endTimeUtc){
					_hasTimeComponent = true;
				}else{
					for each(var layer:Layer in this.layers){
						if(layer.hasTimeComponent){
							_hasTimeComponent = true;
						}
					}
				}
			}
			return _hasTimeComponent;
		}
		
		private var _hasBounds:Boolean;
		public function set hasBounds($hasBounds:Boolean):void{
			_hasBounds = $hasBounds;
		}
		public function get hasBounds():Boolean{
			if(!_hasBounds && minLat && minLng && maxLat && maxLng){
				_hasBounds = true;
			}else{
				_hasBounds = false;
			}
			return _hasBounds;
		}
		
		
		
		private var _layerType:LayerType;
		override public function set layerType($layerType:LayerType):void{
			_layerType = $layerType;
		}
		override public function get layerType():LayerType{
			if(!_layerType){
				if(layers && layers.length > 0){
					var sample_layer:Layer = layers.getItemAt(0) as Layer;
					var lt:LayerType = new LayerType();
					if(sample_layer is RasterLayer){
						lt.type = LayerTypes.RASTER_LAYER_TYPE;
					}else if(sample_layer is DataLayer){
						lt.type = LayerTypes.DATA_LAYER_TYPE;
					}else if(sample_layer is VectorLayer){
						lt.type = LayerTypes.VECTOR_LAYER_TYPE;
					}
					
					_layerType = lt;
				}
			}
			return _layerType;
		}
		
		
	}
}