package com.axiomalaska.map.types.google.base_layers
{
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapType;
	import com.google.maps.MapTypeOptions;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.interfaces.IProjection;
	import com.google.maps.interfaces.ITileLayer;
	
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	
	public class BWMapType extends MapType implements IMapType
	{
		
		private var map:Map;
		
		public function BWMapType($map:Map,$name:String = 'B&W Terrain')
		{
			map = $map;
			super(MapType.PHYSICAL_MAP_TYPE.getTileLayers(),MapType.NORMAL_MAP_TYPE.getProjection(),$name);
			var bw:IMapType = this;
			map.addEventListener(MapEvent.MAPTYPE_CHANGED,function($evt:MapEvent):void{
					if(map.getCurrentMapType() == bw){
						setMapFilter();
					}else{
						unsetMapFilters();
					}
			});
		}
		
		private function setMapFilter( ) : void
		{
			
			
			var red:Number = 0.3086; // luminance contrast value for red
			var green:Number = 0.694; // luminance contrast value for green
			var blue:Number = 0.0820; // luminance contrast value for blue
			var alpha:Number = 1;
			var cm:ColorMatrixFilter = new ColorMatrixFilter([red, green, blue, 0, 0, 
				red, green, blue, 0, 0, 
				red, green, blue, 0, 0, 
				0, 0, 0, alpha, 0]);
			
			
			var s1:Sprite = map.getChildAt(1) as Sprite;
			var s2:Sprite = s1.getChildAt(0) as Sprite;
			s2.filters = [cm];   
		}
		
		private function unsetMapFilters():void{
			var s1:Sprite = map.getChildAt(1) as Sprite;
			var s2:Sprite = s1.getChildAt(0) as Sprite;
			s2.filters = undefined;
			//s2.filters = [filter];
		}
	}
}