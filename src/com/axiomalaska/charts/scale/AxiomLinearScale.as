package com.axiomalaska.charts.scale
{
	public class AxiomLinearScale extends LinearScale
	{
		
		public var diffMultiplier:Number = .2;
		

		override public function get maxValue():*{
			var diff:Number = super.maxValue - super.minValue;
			if(diff == 0){
				return super.maxValue + 1;
			}
			return super.maxValue + diff * diffMultiplier;
		}
		
		override public function get minValue():*{
			var diff:Number = super.maxValue - super.minValue;
			if(diff == 0){
				return super.minValue - 1;
			}
			return super.minValue - diff * diffMultiplier;
		}
	}
}