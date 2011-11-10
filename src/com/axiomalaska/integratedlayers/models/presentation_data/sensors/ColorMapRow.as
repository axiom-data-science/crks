package com.axiomalaska.integratedlayers.models.presentation_data.sensors
{
	public class ColorMapRow
	{
		public function ColorMapRow($value:Number,$color:uint,$text_color:String = '#000000')
		{
			value = $value;
			color = $color;
			text_color = $text_color;
		}
		
		public var value:Number;
		public var color:uint;
		public var text_color:String;
	}
}