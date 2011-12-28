package com.axiomalaska.timeline.charts.axes
{
	import com.axiomalaska.timeline.charts.axes.background.VerticalAxisGraphicalElement;
	import com.axiomalaska.timeline.charts.axes.labels.SkinnableAxisLabel;
	import com.axiomalaska.timeline.skins.VerticalAxisSkin;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.formatters.NumberFormatter;

	public class SkinnableVerticalAxis extends SkinnableAxis
	{
		[Bindable]
		public var dataProvider:ArrayCollection;
		
		public function SkinnableVerticalAxis()
		{
			super();
			/*this.addEventListener(FlexEvent.UPDATE_COMPLETE,function($evt:Event):void{
				rebuildInterface()}
			);*/
		}
		

		override public function stylesInitialized():void {
			if(!this.getStyle("skinClass") && !skin){
				this.setStyle("skinClass",Class(com.axiomalaska.timeline.skins.VerticalAxisSkin));
			}
			super.stylesInitialized();
		}
		
		override public function rebuildInterface():void{
			if(min && max && height && !interfaceBuilt){
				buildSegments();
				commitProperties();
				invalidateProperties();
				invalidateDisplayList();
				interfaceBuilt = true;
			}
		}
		
		
		private function buildSegments():void{
			//calculateTimeInterval();
			
			var diff:Number = max - min;
			var running:Number;
			var arr:Vector.<AxisItem> = new Vector.<AxisItem>;
			var unitsPerPixel:Number = diff / height;
			var minLabelHeight:Number = 20;
			var ct:Number = Math.floor(height / minLabelHeight);
			var unitInterval:Number = diff / ct;
			var i:int = 0;
			running = min;
			
			var nf:NumberFormatter = new NumberFormatter();
			nf.precision = 2;
			
			while(running < max){
				var ai:AxisItem = new AxisItem();
				
				ai.label = nf.format(running);
				ai.value = running;
				arr.push(ai);
				running += unitInterval;
			}
			
			segments = arr;

			
		}
		

		
		private function getYValForValue($value:Number):Number{
			var _y:Number;
			if(height && min && max){
				
				//var spread:Number = ;
				//var pixelsPerSecond:Number = height / spread;
				
				//var globalX:Number = $date.time * pixelsPerSecond;
				//xVal = (startdate.time * pixelsPerSecond) - globalX;
				_y = (((max - $value) * height) / Math.abs(max - min));
			}
			return _y;
		}
		
		override public function calculateSegmentPositions():void{
			if(width && height && min && max){
				var nSegments:int = segments.length;
				var _r:Number = Math.abs(max - min);
				
				
				for (var j:int = 0; j < nSegments; j++){
					segments[j].point = new Point(0,getYValForValue(segments[j].value));
				}
				
				
				minMaxChanged = false;

			}
		}
		
		
		override protected function commitProperties():void 
		{
			super.commitProperties();
			
			if(minMaxChanged && segments){ 	
				if(labelDisplay){
					if(labelInstances){
						var segmentLabelInstance:SkinnableAxisLabel;
						for (var i:int = 0; i< labelInstances.length; i++)
						{
							segmentLabelInstance = labelInstances[i];
							//will call partRemoved, make sure to remove any event listeners there if any have been added 
							this.removeDynamicPartInstance("segmentLabel", segmentLabelInstance);
							//remove from skin manually (dynamic skin part are not added, removed by flex
							labelDisplay.removeElement(segmentLabelInstance);	
							//explicit for readability, gc would get it anyway
							segmentLabelInstance = null;
						}
					}
					
					
					
					labelInstances = new Array();
					
					for (var k:int = 0; k < segments.length; k++)
					{
						var label:SkinnableAxisLabel = createDynamicPartInstance("segmentLabel") as SkinnableAxisLabel;
						//label.text = segments[k].label;
						label.axisItem = segments[k];
						labelDisplay.addElement(label);
						labelInstances[k] = label;
					}
					
				}
			}
				
				
				
		}
		
		
	}
}