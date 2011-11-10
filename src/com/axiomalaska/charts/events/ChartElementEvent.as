package com.axiomalaska.charts.events
{
	import com.axiomalaska.charts.base.IAxiomChartElement;
	import com.axiomalaska.charts.base.SkinnableAxiomChartElement;
	
	import flash.events.Event;

	
	public class ChartElementEvent extends Event
	{
		
		public static const CHART_ELEMENT_INVALIDATE:String = 'chart_element_invalidate';
		
		public var chartElement:IAxiomChartElement;
		
		public function ChartElementEvent($type:String, $chartElement:IAxiomChartElement, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			chartElement = $chartElement;
		}
	}
}