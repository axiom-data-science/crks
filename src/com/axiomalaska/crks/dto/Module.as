package com.axiomalaska.crks.dto {
	import com.axiomalaska.models.SpatialBounds;
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.crks.helpers.LayerTypes;
	import com.axiomalaska.crks.interfaces.ILegendItem;
	import com.axiomalaska.crks.interfaces.IMetaDataItem;
	import com.axiomalaska.crks.interfaces.ISpatialExtentItem;
	
	import mx.collections.ArrayCollection;

	// Generated May 25, 2011 4:36:19 PM by Hibernate Tools 3.2.2.GA
	

	
	[Bindable]
	[RemoteClass(alias="com.axiomalaska.crks.dto.ModuleDTO")]
	public class Module extends ModuleGenerated implements ILegendItem,ISpatialExtentItem,IMetaDataItem{
		
		public var iconCode:String;
		
		//FROM SERVICE
		public var hasMetadata:Boolean;
		
		public var activeOnMap:Boolean;
		
		public var searchTerm:String;
		public function searchLayerGroups():void{
			layerGroups.filterFunction = null;
			layerGroups.filterFunction = runLayerGroupFilter;
			layerGroups.refresh();
		}
		
		public function set children($children:ArrayCollection):void{
			//just a getter
		}
		public function get children():ArrayCollection{
			return layerGroups;
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
		
		private var _spatialBounds:SpatialBounds;
		public function set spatialBounds($spatialBounds:SpatialBounds):void{
			
		}
		public function get spatialBounds():SpatialBounds{
			if(!_spatialBounds){
				if(maxLat && maxLng && minLat && minLng){
					_spatialBounds = new SpatialBounds(minLat,minLng,maxLat,maxLng);
				}else if(
					layerGroups && 
					layerGroups.length > 0 && 
					(layerGroups.getItemAt(0) as LayerGroup).layers && 
					(layerGroups.getItemAt(0) as LayerGroup).layers.length > 0
				){
					var l:Layer = (layerGroups.getItemAt(0) as LayerGroup).layers.getItemAt(0) as Layer;
					_spatialBounds = l.spatialBounds;
				}
				
			}
			return _spatialBounds;
		}
		
		private var _hasBounds:Boolean;
		public function set hasBounds($hasBounds:Boolean):void{
			_hasBounds = $hasBounds;
		}
		public function get hasBounds():Boolean{
			if(spatialBounds){
				_hasBounds = true;
			}else{
				_hasBounds = false;
			}
			return _hasBounds;
		}
		
		private var _hasTimeComponent:Boolean;
		public function set hasTimeComponent($hasTimeComponent:Boolean):void{
			_hasTimeComponent = $hasTimeComponent;
		}
		public function get hasTimeComponent():Boolean{
			if(!_hasTimeComponent){
				if(this.startTimeUtc && this.endTimeUtc){
					_hasTimeComponent = true;
				}
			}
			return _hasTimeComponent;
		}
		
		
		public function runLayerGroupFilter($layer_group:LayerGroup):Boolean{
			
			var ret:Boolean = false;
			
			var srch:String = $layer_group.label;
			
			if(srch.length > 0 && searchTerm){
				ret = srch.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1;
			}else{
				ret = true;
			}
			
			
			return ret;
		}
	}
}