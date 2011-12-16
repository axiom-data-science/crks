package com.axiomalaska.timeline.charts
{
	import com.axiomalaska.timeline.charts.axes.SkinnableAxis;
	import com.axiomalaska.timeline.charts.axes.SkinnableTimeAxis;
	import com.axiomalaska.timeline.skins.ChartSkin;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	

	
	public class SkinnableChart extends SkinnableComponent   
	{
		
		[SkinPart(required="true")]
		public var chartSeriesDisplay:Group;
		
		[SkinPart(required="true")]
		public var verticalAxisDisplay:Group;
		
		[SkinPart(required="false")]
		public var horizontalAxisDisplay:Group;
		
		[Bindable]
		public var chartSeries:Vector.<SkinnableChartSeries>;
		
		[Bindable]
		public var verticalAxis:SkinnableAxis;
		
		[Bindable]
		public var horizontalAxis:SkinnableAxis;
		
		//[Bindable]
		//public var dataProvider:ArrayCollection;
		
		public var maxValue:Number;
		public var minValue:Number;
		
		
		public function SkinnableChart()
		{
			super();
		}
		
		override public function stylesInitialized():void {
			if(!this.getStyle("skinClass") && !skin){
				this.setStyle("skinClass",Class(com.axiomalaska.timeline.skins.ChartSkin));
			}
			super.stylesInitialized();
		}
		
		override protected function partAdded(partName:String, instance:Object):void{
			
			super.partAdded(partName, instance);
			
			if(chartSeries !== null && instance == chartSeriesDisplay){
				for each(var stc:SkinnableChartSeries in chartSeries){
					//stc.dataProvider = dataProvider;
					evalMinMax(stc.dataProvider);
					chartSeriesDisplay.addElement(stc);
					onChartSeriesAdded(stc);
				}
			}
			
			if(verticalAxis !== null && instance == verticalAxisDisplay){
				//evalMinMax(dataProvider);
				verticalAxis.min = minValue;
				verticalAxis.max = maxValue;
				verticalAxisDisplay.addElement(verticalAxis);

			}
		}
		
		
		private function onChartSeriesAdded($chartSeries:SkinnableChartSeries):void{
			var ws:ChangeWatcher = BindingUtils.bindSetter(onChartSeriesDataProviderAdded,$chartSeries,'dataProvider');
		}
		
		private function onChartSeriesDataProviderAdded($val:ArrayCollection = null):void{
			if($val){
				$val.addEventListener(CollectionEvent.COLLECTION_CHANGE,onChartSeriesDataProviderChange);
				evalChartSeriesMinMax($val);
			}
			
		}
		
		private function onChartSeriesDataProviderChange($evt:CollectionEvent):void{
			evalChartSeriesMinMax($evt.currentTarget as ArrayCollection);
		}
		
		
		private function evalMinMax($ac:ArrayCollection = null):void{
			if($ac){
				for each(var obj:Object in $ac){
					if(!maxValue || obj.value > maxValue){
						maxValue = obj.value;
					}
					if(!minValue || obj.value < minValue){
						minValue = obj.value;
					}
				}
			}
		}
		
		private function evalChartSeriesMinMax($ac:ArrayCollection = null):void{
			evalMinMax($ac);
			if(minValue && maxValue){
				for each(var stc:SkinnableChartSeries in chartSeries){
					stc.minValue = minValue;
					stc.maxValue = maxValue;
				}
			}
		}
		
		
		
		
	}
}