package com.axiomalaska.integratedlayers.views.test.timeline.newtest
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
	import com.axiomalaska.integratedlayers.views.test.timeline.AHRulerGraphicElement;
	
	
	
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
		public var ruler:AHRulerGraphicElement;
		
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
		public function get labels():Array{
			return _labels;
		}
		public function set labels(values:Array):void 
		{
			if (_labels != values)
			{
				_labels = values;
				_bLabelsChanged = true;
				invalidateSize();
				invalidateProperties();
				invalidateDisplayList();
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
				//onDateChange();
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
				//onDateChange();
				invalidateSize();
				invalidateProperties();
				invalidateDisplayList();
				
			}
		}
		
		private function onDateChange():void{
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
			labels = [];
			
			if(_bStartDateRangeChange){
				
				running = enddate.time;
				
				while(running > startdate.time){
					var reydt:Date = new Date(running);
					var reydd:Date = new Date(reydt.fullYearUTC,0,0);
					labels.push({date:reydd,text:'Y2:' + reydd.getFullYear()});
					running -= altyear;
				}
			}else{
				running = startdate.time;
				while(running < enddate.time){
					var aydt:Date = new Date(running);
					var aydd:Date = new Date(aydt.fullYearUTC,0,0);
					labels.push({date:aydd,text:'Y2:' + aydd.getFullYear()});
					running += altyear;
				}
			}
			
			trace(labels);
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
				//skin.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			}
		}
		
		override protected function detachSkin():void
		{
			if (skin) 
			{
				//skin.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
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
				rulerGroup.width = _labels.length * labelDistance;
				ruler.divisions = _labels.length;
				
				_bLabelsChanged = false;
			}
			
			if (_bLabelDistanceChanged)
			{
				rulerGroup.width = _labels.length * labelDistance;
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
				var nLables:int;
				var _r:Number = Math.abs(enddate.time - startdate.time);
				var _w:Number = this.width;
				
				var minute:Number = 60*1000;
				var hour:Number = 60*minute;
				var day:Number = 24 * hour;
				var week:Number = 7 * day;
				var month:Number = 31 * day;
				var year:Number = day * 365;
				var altyear:Number = year * 2;
				var decade:Number = year * 10;
				var altdecade:Number = decade * 2;
				
				var running:Number = startdate.time;
				//rulerGroup.width = _w;

				/*
				if(_bStartDateRangeChange){
					
					for (var i:int = nLables - 1; i >= 0; i--)
					{
						var _x:Number = _w - (_w * (enddate.time - tickLineLabelInstances[i].date.time)) / _r;
						trace(tickLineLabelInstances[i].text + ' ==> ' + _x + ' ' + rulerGroup.width);
						tickLineLabelInstances[i].move(_x, LABEL_PADDING);
					}
					
				}else{
					
				*/
				
					for (var j:int = 0; j < nLables; j++)
					{
						tickLineLabelInstances[j].move((_w * (tickLineLabelInstances[j].date.time - startdate.time)) / _r, LABEL_PADDING);
					}
				/*
				}
				*/
				
				
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

