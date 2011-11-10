package com.axiomalaska.integratedlayers.views.test.timeline
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.core.IFactory;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.Skin;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.Power;
	import spark.primitives.Rect;
	import com.axiomalaska.integratedlayers.views.test.timeline.AHLabelInstance;
	
	
	
	/**
	 * The Ruler is a skinnable component that display a ruler.
	 * 
	 * 
	 * The Ruler takes an array of labels, a label distance and the number of subdivisions
	 * and draws the ruler based on this data.
	 * 
	 * Associated is a ruler skin, where a graphic element is used to actually draw the ruler.
	 * 
	 * The labels are drawn using a dynmaic skin part to add required label instances at rt. 
	 * 
	 * @TODO: clean up code, refactor, test.
	 * 
	 * @author Andy Hulstkamp
	 * 
	 */
	
	[Style(name="color", type="uint", format="Color", inherit="yes", theme="spark")]
	
	public class AHRuler extends SkinnableComponent
	{    
		
		public static var LABEL_PADDING:Number = 5;
		
		public static var DEFAULT_LABEL_DISTANCE:Number = 186;
		
		/**
		 * Dynamic skin part for a label.
		 * These are created at runtime based on the array of labels submitted 
		 */
		[SkinPart("false")]
		public var tickLineLabel:IFactory;
		
		/**
		 * References to the labels created at rt 
		 */
		public var tickLineLabelInstances:Array;
		
		/**
		 * A SpriteVisualElement that draws the tick lines 
		 */
		[SkinPart("true")]
		public var ruler:DateBarGraphicElement;
		
		[SkinPart("true")]
		public var rulerGroup:Group;
		
		/**
		 * Labels to display
		 */
		private var _labels:Array;
		
		/**
		 * Flag to indicate label change 
		 */
		private var _bLabelsChanged:Boolean;
		
		/**
		 *  Minimum date for timeline
		 */
		private var _startdate:Date; 
		
		/**
		 * Flag to indicate date range change 
		 */
		private var _bStartDateRangeChange:Boolean;
		
		/**
		 * Maximum date for timeline
		 */
		private var _enddate:Date;
		
		/**
		 * Flag to indicate date range change 
		 */
		private var _bEndDateRangeChange:Boolean;
		
		
		/**
		 * Flag to indicate date range change 
		 */
		private var _bDateRangeChange:Boolean;
		
		
		
		/**
		 * Distance of labels 
		 */
		private var _labelDistance:Number = DEFAULT_LABEL_DISTANCE;
		
		private var _bLabelDistanceChanged:Boolean;
		
		/**
		 * Number of subdivisions required 
		 */
		private var _subdivisions:int = 2;
		
		/**
		 * Flag to indicate that number of subdivision changed 
		 */
		private var _bSubdivisionsChanged:Boolean;
		
		/**
		 * Used for animation when scaling up or down 
		 */
		private var animate:Animate;
		
		
		public function AHRuler()
		{
			super();
		}
		
		/**
		 * Number of subdivisons to draw between labels 
		 * @return 
		 * 
		 */
		public function get subdivisions():int
		{
			return _subdivisions;
		}
		
		public function set subdivisions(value:int):void
		{
			if(_subdivisions != value)
			{
				_subdivisions = value;
				_bSubdivisionsChanged = true;
				invalidateProperties();
				invalidateDisplayList();
			}
		}
		
		/**
		 * The distance between two labels 
		 * @return 
		 * 
		 */
		public function get labelDistance():Number
		{
			return _labelDistance;
		}
		
		public function set labelDistance(value:Number):void
		{
			if (_labelDistance != value) {
				_labelDistance = value;
				_bLabelDistanceChanged = true;
				invalidateProperties();
				invalidateDisplayList();
			}
		}
		
		/**
		 * An array of String values that hold the labels 
		 * @param values
		 * 
		 */
		public function set labels(values:Array):void 
		{
			
			if (_labels != values)
			{
				_labels = values;
				_bLabelsChanged = true;
				//invalidateSize();
				//invalidateProperties();
				//invalidateDisplayList();
			}
		}
		
		public function get startdate():Date{
			return _startdate;
		}
		public function set startdate($startdate:Date):void{
			if(!_startdate || _startdate.time != $startdate.time){
				_startdate = $startdate;
				_bStartDateRangeChange = true;
				_bDateRangeChange = true;
				_buildLabels();
				invalidateSize();
				invalidateProperties();
				invalidateDisplayList();
				
			}
		}
		
		public function get enddate():Date{
			return _enddate;
		}
		public function set enddate($enddate:Date):void{
			if(!_enddate || _enddate.time != $enddate.time){
				_enddate = $enddate;
				_bEndDateRangeChange = true;
				_bDateRangeChange = true;
				_buildLabels();
				invalidateSize();
				invalidateProperties();
				invalidateDisplayList();
				
			}
		}
		
		
		private function _buildLabels():void{
			var arr:Array = [];
			var minute:Number = 60*1000;
			var hour:Number = 60*minute;
			var day:Number = 24 * hour;
			var week:Number = 7 * day;
			var month:Number = 31 * day;
			var year:Number = day * 365;
			var altyear:Number = year * 2;
			var decade:Number = year * 10;
			var altdecade:Number = decade * 2;
			
			
			
			var running:Number;
			var starttime:Number = startdate.time;
			var endtime:Number = enddate.time;
			var diff:Number = Math.abs(starttime - endtime);
			var mult:int;
			var interval:Number;
			var format:Function;
			if(diff < day * 3){
				interval = hour;
				format = formatTime;
			}else if(diff < month){	
				interval = week;
				format = formatDay;
			}else if(diff < year){
				interval = month;
				format = formatMonth;
			}else if(diff < year * 5){
				interval = month * 6;
				format = formatMonth;
			}else if(diff < decade){
				interval = year;
				format = formatYear;
			}else if(diff < decade * 3){
				interval = altyear;
				format = formatYear;
			}else{
				interval = decade;
				format = formatYear;
			}
			
			
			if(_bStartDateRangeChange){
				running = Math.floor(endtime - interval/2);
				while(running > starttime){
					arr.push(format.call(null,new Date(running)));
					running -= interval;
				}
				
				
			}else{
				running = Math.floor(starttime + interval/2);
				while(running < endtime){
					arr.push(format.call(null,new Date(running)));
					running += interval;
				}
				
			}
			

			
			labels = arr;
		}
		
		private var _dayLabels:Array = ['Sun','Mon','Tues','Wed','Thurs','Fri','Sat']
		private var _monthLabels:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		
		private function _createLabelInstance($date:Date,$text:String):Object{
			return {date:$date,text:$text};
		}
		
		
		private function formatYear($date:Date):Object{
			var d:Date = new Date($date.fullYearUTC,0);
			return _createLabelInstance(d,d.fullYear.toString());
		}
		
		
		private function formatMonth($date:Date):Object{
			var d:Date = new Date($date.fullYearUTC,$date.monthUTC);
			return _createLabelInstance(d,_monthLabels[d.getMonth()] + ' ' + d.getFullYear());
		}
		
		
		private function formatDay($date:Date):Object{
			var d:Date = new Date($date.fullYearUTC,$date.monthUTC,$date.dateUTC);
			return _createLabelInstance(d,_monthLabels[d.getMonth()] + ' ' + d.getDate());
		}
		
		private function formatTime($date:Date):Object{
			return _createLabelInstance($date,_monthLabels[$date.getMonth()] + ' ' + $date.getDate() + ' ' + $date.getHours() + ':' + $date.getMinutes());
		}
		
		
		
		
		//--------------------------------------------------------------------
		//
		// Overriden functions and validation functions
		//
		//--------------------------------------------------------------------
		
		/**
		 * Overriden. Add mouse listener to the entire skin 
		 */
		override protected function attachSkin():void 
		{
			super.attachSkin();
			
			if (skin) 
			{
				skin.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			}
		}
		
		override protected function detachSkin():void
		{
			if (skin) 
			{
				skin.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			}
			
			super.detachSkin();
		}
		
		//--------------------------------------------------------------------
		//
		// Validation methods
		//
		//--------------------------------------------------------------------
		
		/**
		 * Take care of label changes and change in number of subdivisions 
		 */
		override protected function commitProperties():void 
		{
			
			super.commitProperties();
			
			if(_bDateRangeChange){
				_bDateRangeChange = false;
			}
			
			
			if (_bLabelsChanged) {
				
				//Housekeeping, get rid of all former labels
				if (tickLineLabelInstances) 
				{
					var labelInstance:Label;
					
					for (var i:int = 0; i< tickLineLabelInstances.length; i++)
					{
						labelInstance = tickLineLabelInstances[i];
						
						//will call partRemoved, make sure to remove any event listeners there if any have been added 
						this.removeDynamicPartInstance("tickLineLabel", labelInstance);
						
						//remove from skin manually (dynamic skin part are not added, removed by flex
						rulerGroup.removeElement(labelInstance);
						
						//explicit for readability, gc would get it anyway
						labelInstance = null;
					}
				}
				
				//create new array to hold label instances
				tickLineLabelInstances = new Array();
				
				//Add as many labels as needed to the skin using the dynamic skin part tickLineLabel
				for (var k:int = 0; k < _labels.length; k++)
				{
					var label:AHLabelInstance = AHLabelInstance(this.createDynamicPartInstance("tickLineLabel"));
					label.date = _labels[k].date;
					label.text = _labels[k].text;
					//label.text = _labels[k];
					tickLineLabelInstances[k] = label;
					rulerGroup.addElement(label);
				}
				//rulerGroup.width = _labels.length * labelDistance;
				ruler.divisions = _labels.length;
				
				_bLabelsChanged = false;
			}
			
			if (_bLabelDistanceChanged)
			{
				//rulerGroup.width = _labels.length * labelDistance;
				_bLabelDistanceChanged = false;
			}
			
			if (_bSubdivisionsChanged)
			{
				//proxy value pass it down the skin part
				_bSubdivisionsChanged = false;
				ruler.subdivisions = _subdivisions;
			}
		}
		
		/**
		 * Draw the skin and update the positions of the labels that have been added dynamically
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//update lables positions. See comment there
			updatePositionOfLabels();
		}
		
		//--------------------------------------------------------------------
		//
		// Events and events handlers.
		//
		//--------------------------------------------------------------------
		
		protected function onMouseClickHandler(event:MouseEvent):void 
		{
			if (event.ctrlKey)
			{
				changeResolution(event.shiftKey);
			}
		}
		
		protected function onMouseDownHandler(event:MouseEvent):void 
		{
			
			/*
			//down scale
			if (event.ctrlKey)
			{
			changeResolution(false);
			}
			//up scale
			else if (event.shiftKey)
			{
			changeResolution(true);
			}
			//move
			else if (event.altKey)
			{
			doStartDrag(event);
			}
			*/
			
			doStartDrag(event);
		}
		
		protected function doStartDrag(event:MouseEvent):void
		{
			var w:Number = this.getExplicitOrMeasuredWidth();
			var bounds:Rectangle = rulerGroup.getBounds(rulerGroup);
			bounds.bottom = bounds.top;
			bounds.left = bounds.left - (bounds.width - w);
			bounds.right = 0;
			rulerGroup.startDrag(false, bounds);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
		
		protected function onMouseUpHandler (event:MouseEvent):void
		{
			rulerGroup.stopDrag();
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);    
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);    
		}
		
		protected function changeResolution(upScale:Boolean):void 
		{
			if (!animate || !animate.isPlaying){
				
				if (labelDistance < DEFAULT_LABEL_DISTANCE / 2.5)
				{
					labelDistance = DEFAULT_LABEL_DISTANCE;
				}
				else if (labelDistance > DEFAULT_LABEL_DISTANCE * 2.5)
				{
					labelDistance = DEFAULT_LABEL_DISTANCE;
				}
				
				//reset any dragging
				rulerGroup.x = 0;
				
				createAndSetupAnimation(upScale);
				animate.play();
			}
		}
		
		//--------------------------------------------------------------------
		//
		// Drawing and animation
		//
		//--------------------------------------------------------------------
		
		protected function createAndSetupAnimation(upScale:Boolean):Animate
		{
			//create or handle animate object if needed
			if (!animate)
			{
				animate = createSimplePowerAnimate(this, "labelDistance");
			}
			else
			{
				animate.end();
			}
			
			//calculate and set motion path for animation
			var smp:SimpleMotionPath
			
			//get new distance based on up scale, down scale
			var td:int = upScale ? labelDistance * 1.25 : labelDistance / 1.25;
			
			//set start and end values for the motion
			smp = SimpleMotionPath(animate.motionPaths[0]);
			smp.valueFrom = labelDistance;
			smp.valueTo = td;
			
			return animate;
		}
		
		/**
		 * Update the positions of the labels.
		 * Note: This is actually bad practice, since it breaks Flex' separation of concerns.
		 * Might be better to place the label in a HGroup and let the layout object do the positioning
		 * 
		 * We leave it here, since this is called multiple times during animation and keeping it here involves less overhead. 
		 */
		protected function updatePositionOfLabels ():void 
		{
			if (tickLineLabelInstances && tickLineLabelInstances.length) 
			{
				var nLables:int = tickLineLabelInstances.length;
				var _r:Number = Math.abs(enddate.time - startdate.time);
				var _w:Number = this.width;
				
				if(_bStartDateRangeChange){
					
					for (var i:int = nLables - 1; i >= 0; i--)
					{						
						tickLineLabelInstances[i].move(_w - (_w * (enddate.time - tickLineLabelInstances[i].date.time)) / _r, LABEL_PADDING);
					}
					
				}else{
					
					for (var j:int = 0; j < nLables; j++)
					{
						tickLineLabelInstances[j].move((_w * (tickLineLabelInstances[j].date.time - startdate.time)) / _r, LABEL_PADDING);
					}
				}
				
				
			}
			
			_bStartDateRangeChange = false;
			_bEndDateRangeChange = false;
			
		}
		
		/**
		 * create Animate instance. Refactor out to utils. 
		 *
		 */
		public static function createSimplePowerAnimate (target:Object, property:String, duration:Number = 250, easeInFraction:Number = 0.5, exponent:Number = 2):Animate 
		{
			var animate:Animate = new Animate(target);
			animate.duration = duration;
			var smp:SimpleMotionPath = new SimpleMotionPath(property, 0, 0);
			var mp:Vector.<MotionPath> = new Vector.<MotionPath>();
			mp[0] = smp;
			animate.easer = new Power(easeInFraction, exponent);
			animate.motionPaths = mp;
			return animate;
		}
	}
}

