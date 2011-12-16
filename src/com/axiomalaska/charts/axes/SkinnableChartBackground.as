package com.axiomalaska.charts.axes
{
	import com.axiomalaska.charts.base.AxiomChartPlottableItem;
	import com.axiomalaska.charts.base.SkinnableAxiomChartElement;
	import com.axiomalaska.charts.events.ChartElementEvent;
	
	public class SkinnableChartBackground extends SkinnableAxiomChartElement
	{
		
		override public function get plottableItems():Vector.<AxiomChartPlottableItem>{
			return axis.getPlottableItems();
		}
		
		private var _axis:SkinnableAxis;
		
		[Bindable]
		public function set axis($axis:SkinnableAxis):void{
			if($axis != _axis){
				_axis = $axis;
				setAxisListeners();
			}
		}
		public function get axis():SkinnableAxis{
			return _axis;
		}
		
		private function setAxisListeners():void{
			axis.addEventListener(ChartElementEvent.CHART_ELEMENT_INVALIDATE,onAxisChange);
		}
		
		private function onAxisChange($evt:ChartElementEvent):void{
			redraw();
		}
		
		private function removeAxisListeners():void{
			axis.removeEventListener(ChartElementEvent.CHART_ELEMENT_INVALIDATE,onAxisChange);
		}
		
		override public function readyForRedraw():Boolean{
			if(axis){
				return true;
			}
			return false;
		}
		
		override public function redraw():void{
			super.redraw();
		}
		
		
		
		
		
	}
}