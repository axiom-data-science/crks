package com.axiomalaska.timeline.charts
{
	import com.axiomalaska.timeline.charts.axes.SkinnableTimeAxis;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	public class SkinnableChartSeries extends SkinnableTimeAxis
	{
		
		private var _minValue:Number;
		public function set minValue($minValue:Number):void{
			_minValue = $minValue;
		}
		public function get minValue():Number{
			if(_minValue && verticalPadding){
				return _minValue - verticalPadding;
			}
			return _minValue;
		}
		
		private var _maxValue:Number;
		public function set maxValue($maxValue:Number):void{
			_maxValue = $maxValue;
		}
		public function get maxValue():Number{
			if(_maxValue && verticalPadding){
				return _maxValue + verticalPadding;
			}
			return _maxValue;
		}
		
		
		public function get verticalPadding():Number{
			var padding:Number;
			if(_minValue && _maxValue){
				padding = Math.abs((_maxValue - _minValue) * .2);
			}
			
			return padding;
		}
		
		private var _dataProvider:ArrayCollection;
		
		[Bindable]
		public function set dataProvider($dataProvider:ArrayCollection):void{
			if(_dataProvider != $dataProvider){
				_dataProvider = $dataProvider;
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,function($evt:Event):void{
					invalidateProperties();
					invalidateDisplayList();	
				});
				invalidateProperties();
				invalidateDisplayList();
			}
		}
		public function get dataProvider():ArrayCollection{
			return _dataProvider;
		}
		
		
		public function SkinnableChartSeries()
		{
			super();
		}

	}
}