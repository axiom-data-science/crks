package com.axiomalaska.map.types.google.base_layers
{
	import com.google.maps.MapType;
	import com.google.maps.StyledMapType;
	import com.google.maps.StyledMapTypeOptions;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.styles.MapTypeStyle;
	import com.google.maps.styles.MapTypeStyleElementType;
	import com.google.maps.styles.MapTypeStyleRule;
	
	public class BWMapTypeStyled extends StyledMapType implements IMapType
	{
		public function BWMapTypeStyled($name:String = 'B&W Terrain')
		{
			//CAN'T USE TERRAIN TYPE..
			var mts:MapTypeStyle = new MapTypeStyle(MapTypeStyleElementType.ALL,MapTypeStyleElementType.ALL,[MapTypeStyleRule.saturation(-80)]);
			var styles:Array = [mts];
			var ops:StyledMapTypeOptions = new StyledMapTypeOptions({
				name:$name
			});
			super(styles, ops);
		}
	}
}