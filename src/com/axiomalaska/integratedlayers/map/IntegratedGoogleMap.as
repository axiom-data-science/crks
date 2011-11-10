package com.axiomalaska.integratedlayers.map
{
	
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.types.google.GoogleMapV2;
	import com.axiomalaska.crks.dto.Layer;
	import com.axiomalaska.crks.dto.LayerGroup;
	import com.axiomalaska.crks.dto.LayerType;
	import com.google.maps.interfaces.IOverlay;
	import com.google.maps.interfaces.IPane;
	
	import mx.collections.ArrayCollection;
	
	public class IntegratedGoogleMap extends GoogleMapV2
	{
	
		public var layer_types_collection:ArrayCollection;
		public var layer_types_map:Object = {};
		public var layer_type_to_pane:Object = {};
		
		public function getLayergroupFromLayer($layer:ILayer):LayerGroup{
			if(layer_to_layer_group.hasOwnProperty($layer.id)){
				return layer_to_layer_group[$layer.id] as LayerGroup;
			}
			return null;
		}
		
		public function getLayerTypePane($layer_type:LayerType):IPane{
			if(layer_type_to_pane.hasOwnProperty($layer_type.id)){
				return layer_type_to_pane[$layer_type.id] as IPane;
			}
			return null;
		}
		
		
		public function registerLayerType($layer_type:LayerType):IPane{
			//CREATE PANE OR ADD ONE
			if(!layer_types_map.hasOwnProperty($layer_type.id)){
				layer_types_map[$layer_type.id] = $layer_type;
			}
			if(layer_types_collection.getItemIndex($layer_type) < 0){
				layer_types_collection.addItem($layer_type);
			}
			
			var pane:IPane;
			if(!layer_type_to_pane.hasOwnProperty($layer_type.id)){
				pane = manager.createPane();
			}else{
				pane = layer_type_to_pane[$layer_type.id];
			}
			
			
			
			return pane;
		}
		
		
		public function addLayerGroup($layer_group:LayerGroup):Boolean{
			//ADD LAYER GROUP TO PANE
			var pane:IPane = registerLayerType($layer_group.layerType);
			for each(var layer:Layer in $layer_group.layers){
				pane.addOverlay(layer.mapLayer as IOverlay);
			}
			
			return false;
		}
		
		override public function addLayer($layer:ILayer):Boolean{
			//
			return false;
		}
		
		
		private function _setPaneOrder():void{
			var temp:Array = [];
			for(var p:String in layer_type_to_pane){
				temp.push(layer_groups_map[p]);
			}
			
			temp.sort(function($a:LayerType,$b:LayerType):int{
				if($a.zindex > $b.zindex){
					return 1;
				}else if($b.zindex > $a.zindex){
					return -1;
				}
				return 0;
			});
			
			var ct:int = 0;
			for each(var lt:LayerType in temp){
				manager.placePaneAt(panes_map[lt.id],ct);
				ct ++;
			}	
		}
		
		private function _setLayerGroupOrder($layer_type:LayerType):void{
			//iterate through layergroups setting order
		}
		
		
		
		
		
		
		override public function resetLayerOrder():void{
			
			
			
			for(var layerGroupId:String in panes_map){
				//var arr:Array = 
				var pane:IPane = panes_map[layerGroupId];
				
				var layers:Array = pane_to_layers[layerGroupId];
				layers.sort(function($a:ILayer,$b:ILayer):int{
					if($a.zindex > $b.zindex){
						return -1;
					}else if($b.zindex > $a.zindex){
						return 1;
					}
					return 0;
				});
				
				for each(var layer:IOverlay in layers){
					var l:ILayer = layer as ILayer;
					//trace('SETTING LAYER ' + l.name + ' TO ' + l.zindex);
					pane.bringToTop(layer);
				}
				
				//pane.bringToTop();
			}
		}
		
		
		
	}
}