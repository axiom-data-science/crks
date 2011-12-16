package com.axiomalaska.crks.dto {
	// Generated May 25, 2011 4:36:19 PM by Hibernate Tools 3.2.2.GA
	
	[Bindable]
	[RemoteClass(alias="com.axiomalaska.crks.dto.PortalLayerGroupDTO")]
	public class PortalLayerGroup extends PortalLayerGroupGenerated{
		
		
		private var _sortOrder:Number;
		
		override public function set sortOrder($sortOrder:int):void{
			
		}
		
		override public function get sortOrder():int{
			if(!_sortOrder){
				if(this.layerGroup && this.layerGroup.layers){
					var ct:int = 0;
					var ttl:Number = 0;
					for each(var layer:Layer in layerGroup.layers){
						if(layer.layerSubtype){
							var t:LayerSubtype = layer.layerSubtype;
							if(t.ZIndex){
								ttl += t.ZIndex;
								ct ++;
							}
						}
					}
					
					_sortOrder = Math.floor(ttl/ct);
					
				}
			}
			return _sortOrder;
		}
		
	}
}