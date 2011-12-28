package com.axiomalaska.map.types.google
{
	import com.axiomalaska.map.interfaces.ILayer;
	import com.axiomalaska.map.interfaces.ILayerGroup;
	import com.axiomalaska.map.layers.LayerGroup;
	import com.axiomalaska.map.types.google.GoogleMap;
	import com.google.maps.interfaces.IOverlay;
	import com.google.maps.interfaces.IPane;
	
	import mx.controls.Alert;
	
	public class GoogleMapV2 extends GoogleMap
	{
		
		public var panes_map:Object = {};
		public var pane_to_layers:Object = {};
		public var layers_map:Object = {};
		public var layer_to_pane:Object = {};
		public var layer_groups_map:Object = {};
		public var layer_to_layer_group:Object = {};
		
		
		
		public function GoogleMapV2()
		{
			super();
		}
		
		override public function getLayerByName($name:String):ILayer{
			if(layers_map.hasOwnProperty($name)){
				return layers_map[$name];
			}
			return null;
		}
		
		override public function addLayerToGroup($layer:ILayer,$layer_group:ILayerGroup):Boolean{
			var pane:IPane;
			if(!panes_map.hasOwnProperty($layer_group.id)){
				pane = manager.createPane();
				panes_map[$layer_group.id] = pane;
				layer_groups_map[$layer_group.id] = $layer_group;
				pane_to_layers[$layer_group.id] = [];
			}else{
				pane = panes_map[$layer_group.id];
			}
			
			_setPaneOrder();
			
			if($layer is IOverlay){
				if(layers_map.hasOwnProperty($layer.id)){
					//trace('Layer already exists');
					//pane.removeOverlay(layers_map[$layer.id]);
					removeLayer($layer);
				}
				
				var overlay:IOverlay;			
				layers_map[$layer.id] = $layer;
				layer_to_pane[$layer.id] = $layer_group.id;
				layer_to_layer_group[$layer.id] = $layer_group;
				pane_to_layers[$layer_group.id].push($layer);
				layers.push($layer);
				overlay = $layer as IOverlay;	
				
				pane.addOverlay(overlay);
				
				
				
				return true;
			}
			
			
			
			return false;
		}
		
		private function _setPaneOrder():void{
			var temp:Array = [];
			for(var p:String in panes_map){
				temp.push(layer_groups_map[p]);
			}
			
			temp.sort(function($a:LayerGroup,$b:LayerGroup):int{
				if($a.zindex > $b.zindex){
					return 1;
				}else if($b.zindex > $a.zindex){
					return -1;
				}
				return 0;
			});
			
			var ct:int = 0;
			for each(var lg:LayerGroup in temp){
				manager.placePaneAt(panes_map[lg.id],ct);
				ct ++;
			}	
		}
		
		private function _setLayerOrder($layer_group:LayerGroup):void{
			
		}
		
		override public function addLayer($layer:ILayer):Boolean{
			var layer_group:LayerGroup = new LayerGroup();
			layer_group.id = 0;
			return addLayerToGroup($layer,layer_group);
		}
		
		override public function removeLayer($layer:ILayer):Boolean{
			if($layer && $layer.id){
				if(layers_map.hasOwnProperty($layer.id) && layer_to_pane.hasOwnProperty($layer.id)){
					var pane:IPane = panes_map[layer_to_pane[$layer.id]];
					var overlay:IOverlay = layers_map[$layer.id];
					pane.removeOverlay(overlay);
					delete layers_map[$layer.id];
					var lrs:Array = pane_to_layers[layer_to_pane[$layer.id]];
					lrs.splice(lrs.indexOf($layer),1);
					layers.splice(layers.indexOf($layer),1);
					delete layer_to_pane[$layer.id];
					delete layer_to_layer_group[$layer.id];
					
					return true;
				}
			}
			return false;
		}
	}
}