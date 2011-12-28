package com.axiomalaska.integratedlayers.models.presentation_data
{
	import com.axiomalaska.crks.dto.DataLayer;
	import com.axiomalaska.crks.dto.LayerGroup;
	import com.axiomalaska.crks.dto.Module;
	import com.axiomalaska.crks.dto.RasterLayer;
	import com.axiomalaska.crks.dto.VectorLayer;
	import com.axiomalaska.crks.helpers.LayerTypes;
	import com.axiomalaska.crks.interfaces.ILegendItem;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class LegendData
	{
		public var legend_items_map:Object = {};
		public var legend_items_collection:ArrayCollection = new ArrayCollection();
		
		public var sensor_legend_items_map:Object = {};
		public var sensor_legend_items_collection:ArrayCollection = new ArrayCollection();
		
		public var vector_legend_items_map:Object = {};
		public var vector_legend_items_collection:ArrayCollection = new ArrayCollection();
		
		public var raster_legend_items_map:Object = {};
		public var raster_legend_items_collection:ArrayCollection = new ArrayCollection();
		
		
		public function legendItemActive($legend_item:ILegendItem):Boolean{
			if(legend_items_map.hasOwnProperty($legend_item.id)){
				return true;
			}
			return false;
		}
		
		public function registerLegendItem($legend_item:ILegendItem):void{
			if(legend_items_collection.getItemIndex($legend_item) < 0){
				legend_items_collection.addItemAt($legend_item,0);
			}
			if(!legend_items_map.hasOwnProperty($legend_item.id)){
				legend_items_map[$legend_item.id] = $legend_item;
			}
			
			
			//if($legend_item is DataLayer || ($legend_item is Module && ($legend_item as Module).getChildLayerType() == LayerTypes.DATA_LAYER_TYPE)){

			if($legend_item is LayerGroup && ($legend_item as LayerGroup).layerType.type == LayerTypes.DATA_LAYER_TYPE){
				if(sensor_legend_items_collection.getItemIndex($legend_item) < 0){
					sensor_legend_items_collection.addItemAt($legend_item,0);
				}
				
				if(!sensor_legend_items_map.hasOwnProperty($legend_item.id)){
					sensor_legend_items_map[$legend_item.id] = $legend_item;
				}
				
			}
			
			//if($legend_item is VectorLayer || ($legend_item is Module && ($legend_item as Module).getChildLayerType() == LayerTypes.VECTOR_LAYER_TYPE)){
			
			if($legend_item is LayerGroup && ($legend_item as LayerGroup).layerType.type == LayerTypes.VECTOR_LAYER_TYPE){
				if(vector_legend_items_collection.getItemIndex($legend_item) < 0){
					vector_legend_items_collection.addItemAt($legend_item,0);
				}
				
				if(!vector_legend_items_map.hasOwnProperty($legend_item.id)){
					vector_legend_items_map[$legend_item.id] = $legend_item;
				}
			}
			
			//if($legend_item is RasterLayer || ($legend_item is Module && ($legend_item as Module).getChildLayerType() == LayerTypes.RASTER_LAYER_TYPE)){
			
			if($legend_item is LayerGroup && ($legend_item as LayerGroup).layerType.type == LayerTypes.RASTER_LAYER_TYPE){
				if(raster_legend_items_collection.getItemIndex($legend_item) < 0){
					raster_legend_items_collection.addItemAt($legend_item,0);
				}
				
				if(!raster_legend_items_map.hasOwnProperty($legend_item.id)){
					raster_legend_items_map[$legend_item.id] = $legend_item;
				}
			}
			
		}
		
		public function unregisterLegendItem($legend_item:ILegendItem):void{
			if(legend_items_collection.getItemIndex($legend_item) >= 0){
				legend_items_collection.removeItemAt(legend_items_collection.getItemIndex($legend_item));
			}
			
			if(legend_items_map.hasOwnProperty($legend_item.id)){
				delete(legend_items_map[$legend_item.id]);
			}
			
			if(sensor_legend_items_collection.getItemIndex($legend_item) >= 0){
				sensor_legend_items_collection.removeItemAt(sensor_legend_items_collection.getItemIndex($legend_item));
			}
			
			if(sensor_legend_items_map.hasOwnProperty($legend_item.id)){
				delete(sensor_legend_items_map[$legend_item.id]);
			}
			
			if(vector_legend_items_collection.getItemIndex($legend_item) >= 0){
				vector_legend_items_collection.removeItemAt(vector_legend_items_collection.getItemIndex($legend_item));
			}
			
			if(vector_legend_items_map.hasOwnProperty($legend_item.id)){
				delete(vector_legend_items_map[$legend_item.id]);
			}
			
			if(raster_legend_items_collection.getItemIndex($legend_item) >= 0){
				raster_legend_items_collection.removeItemAt(raster_legend_items_collection.getItemIndex($legend_item));
			}
			
			if(raster_legend_items_map.hasOwnProperty($legend_item.id)){
				delete(raster_legend_items_map[$legend_item.id]);
			}
			
			
			
		}
	}
}