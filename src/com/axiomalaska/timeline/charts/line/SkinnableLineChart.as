package com.axiomalaska.timeline.charts.line
{

	
	import com.axiomalaska.timeline.charts.axes.TimeLineItem;
	import com.axiomalaska.timeline.charts.SkinnableChartSeries;
	import com.axiomalaska.timeline.skins.TimeLineChartSkin;
	
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	
	[Style(name="lineColor", type="uint", format="Color", inherit="no")]
	[Style(name="lineWeight", type="int", inherit="no")]
	
	public class SkinnableLineChart extends SkinnableChartSeries
	{
		
		
		[SkinPart(required="true")]
		public var lineChartGraphic:LineChartGraphicalElement;

		private var _segments:Vector.<TimeLineItem> = new Vector.<TimeLineItem>;
		

		
		public function SkinnableLineChart()
		{
			super();
		}
		
		override public function stylesInitialized():void {
			if(!this.getStyle("skinClass") && !skin){
				this.setStyle("skinClass",Class(com.axiomalaska.timeline.skins.TimeLineChartSkin));
			}
			super.stylesInitialized();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(dataProvider){
				calculateSegmentPositions();
				lineChartGraphic.segments = _segments;
			}
		}
		
		override public function positionSegments():void{
			
		}
		
		override public function calculateSegmentPositions():void{
			
			if(dataProvider){
				var nSegments:int = dataProvider.length;
				
				var obj:Object;
	
				if(!maxValue && !minValue){
					for each(obj in dataProvider){
						if(!maxValue || obj.value > maxValue){
							maxValue = obj.value;
						}
						if(!minValue || obj.value < minValue){
							minValue = obj.value;
						}
					}
					
				}
				
				
				if(!startdate && !enddate){
					for each(obj in dataProvider){
						if(!startdate || obj.date.time < startdate.time){
							setStartDate(new Date(obj.date));
							
						}
						if(!enddate || obj.date.time > enddate.time){
							setEndDate(new Date(obj.date));
						}
					}
					
				}
	
				
				
				var _r:Number = Math.abs(enddate.time - startdate.time);
				var _w:Number = width;
				var _h:Number = height;
							
				var _hr:Number = maxValue - minValue;
				
				_segments = new Vector.<TimeLineItem>;
				var k:int = 0;
				for (var j:int = 0; j < nSegments; j++)
				{
					
					var item:Object = dataProvider.getItemAt(j);
					var prev:Object = item;
					var next:Object = item;
					if(j > 0){
						prev = dataProvider.getItemAt(j-1);
					}
					if((j + 1) < dataProvider.length){
						next = dataProvider.getItemAt(j + 1);
					}
					
					
					if(
						(item.date.time > startdate.time && item.date.time < enddate.time) ||
						(next.date.time > startdate.time) ||
						(prev.date.time < enddate.time)
					){
						var tli:TimeLineItem = new TimeLineItem();
						if(!isNaN(item.value)){
							var _rX:Number = (_w * (item.date.time - startdate.time)) / _r;
							var _y:Number = _h - (_h * (item.value - minValue)) / _hr;
							tli.point =  new Point(_rX,_y);
							tli.label = item.value;
						}
						
						tli.date = item.date;
						_segments[k] = tli;
						k ++;
					}
				}
			}
			

		}
	}
}