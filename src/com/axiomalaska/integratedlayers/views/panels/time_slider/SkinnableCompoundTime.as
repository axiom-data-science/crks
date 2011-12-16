package com.axiomalaska.integratedlayers.views.panels.time_slider
{
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.timeline.charts.axes.SkinnableTimeAxis;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SkinnableCompoundTime extends SkinnableComponent
	{
		public function SkinnableCompoundTime()
		{
			super();
		}
		
		
		//PROPS
		
		[Bindable]
		public var minDate:Date;
		
		[Bindable]
		public var maxDate:Date;
		
		[Bindable]
		public var sliceX:Number;
		
		[Bindable]
		public var sliceDate:Date;
		
		[Bindable]
		public var boundedLowX:Number;
		
		[Bindable]
		public var boundedHighX:Number;
		
		/*
		[Bindable]
		public var boundedLowDate:Date;
		
		[Bindable]
		public var boundedHighDate:Date;
		*/
		
		[Bindable]
		public var boundedDates:Temporal;
		
		
		[Bindable]
		public var boundedWidth:Number;
		
		
		
		protected var _sliceActive:Boolean;
		
		[Bindable]
		public function set sliceActive($sliceActive:Boolean):void{_sliceActive = $sliceActive};
		public function get sliceActive():Boolean{return _sliceActive};
		
		protected var _boundsActive:Boolean;
		
		[Bindable]
		public function set boundsActive($boundsActive:Boolean):void{_boundsActive = $boundsActive};
		public function get boundsActive():Boolean{return _boundsActive};
		
		
		//TEMPLATE PARTS
		
		[Bindable]
		public var sliceSliderContent:Group;
		
		[Bindable]
		public var sliceContent:Group;
		
		[Bindable]
		public var boundsSliderContent:Group;
		
		[Bindable]
		public var boundedContent:Group;
		
		[Bindable]
		public var timeLineContent:Group;
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		
		[SkinPart(required="true")]
		public var sliceSliderContentDisplay:Group;
		
		[SkinPart(required="true")]
		public var sliceContentDisplay:Group;
		
		[SkinPart(required="true")]
		public var boundsSliderContentDisplay:Group;
		
		[SkinPart(required="true")]
		public var boundedContentDisplay:Group;
		
		[SkinPart(required="true")]
		public var timeLineDisplay:Group;
		
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			

			
			if(sliceSliderContent !== null && instance == sliceSliderContentDisplay){
				sliceSliderContentDisplay.addElement(sliceSliderContent);
			}
			
			if(sliceContent !== null && instance == sliceContentDisplay){
				sliceContentDisplay.addElement(sliceContent);
			}
				
			if(boundsSliderContent !== null && instance == boundsSliderContentDisplay){
				boundsSliderContentDisplay.addElement(boundsSliderContent);
			}
			
			if(boundedContent !== null && instance == boundedContentDisplay){
				boundedContentDisplay.addElement(boundedContent);
			}
			
			if(timeLineContent !== null && instance == timeLineDisplay){
				timeLineDisplay.addElement(timeLineContent);
			}
			
		}
	}
}