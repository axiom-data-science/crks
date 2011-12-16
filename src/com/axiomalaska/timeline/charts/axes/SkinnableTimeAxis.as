package com.axiomalaska.timeline.charts.axes
{
	import com.axiomalaska.timeline.charts.axes.labels.SkinnableAxisLabel;
	import com.axiomalaska.timeline.skins.TimelineSkin;
	
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.Graphic;
	import spark.primitives.Rect;
	import spark.primitives.supportClasses.FilledElement;
	

	[Style(name="tickColor", type="uint", format="Color", inherit="no")]
	[Style(name="tickWeight", type="int")]
	[Style(name="tickAlpha", type="number")]
	[Style(name="tickVisible", type="boolean")]
	
	[Style(name="backgroundColors",type="Array",format="Color", inherit="no")]
	[Style(name="backgroundVisible", type="boolean")]
	
	
	public class SkinnableTimeAxis extends SkinnableAxis
	{
		

		
		[SkinPart(required="false")]
		public var timelineGroup:Group;		
		
		private var _startdate:Date;
		private var _enddate:Date;
		
		
		private var _timeInterval:Number;
		private var _chartStartDate:Date;
		private var _dateLabelFormat:Function;
		

		
		[Bindable]
		public function get startdate():Date{
			return _startdate;
		}
		public function set startdate($date:Date):void{
			
			if(!_startdate || _startdate.time != $date.time){
				_startdate = $date;				
				minMaxChanged = true; 
				rebuildInterface();
			}
		}
		
		public function setStartDate($date:Date):void{
			_startdate = $date;
		}
		
		
		[Bindable]
		public function get enddate():Date{
			return _enddate;
		}
		public function set enddate($date:Date):void{
			if(!_enddate || _enddate.time != $date.time){
				_enddate = $date;
				minMaxChanged = true;
				rebuildInterface();
			}
		}
		
		public function setEndDate($date:Date):void{
			_enddate = $date;
		}
		

		
		override public function rebuildInterface():void{
			if(width && height && startdate && enddate){
				buildSegments();
				commitProperties();
				invalidateProperties();
				invalidateDisplayList();
				interfaceBuilt = true;
			}
		}
		//THIS WILL MAKE IT EASIER TO CREATE A DATE SPAN SLIDER
		public function updateDateRange($startdate:Date,$enddate:Date):void{
			_startdate = $startdate;
			_enddate = $enddate;
			minMaxChanged = true;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		
		
		
		public function SkinnableTimeAxis()
		{
			super();
		}
		
		
		
		private function getXValForValue($value:Number):Number{
			var xVal:Number;
			if(width && startdate && enddate){
				
				var spread:Number = Math.abs(enddate.time - startdate.time);
				var pixelsPerSecond:Number = width / spread;
				
				xVal = width - (((enddate.time - $value) * width) / spread);
			}
			return xVal;
		}
		
		override public function stylesInitialized():void {
			super.stylesInitialized();
			if(!this.getStyle("skinClass") && !skin){
				this.setStyle("skinClass",Class(com.axiomalaska.timeline.skins.TimelineSkin));
			}
		}
		

		
		override public function calculateSegmentPositions():void{
			if(width && height && startdate && enddate){
				var nSegments:int = segments.length;
				var _r:Number = Math.abs(enddate.time - startdate.time);
				var _w:Number = width;

				for (var j:int = 0; j < nSegments; j++){
					segments[j].point = new Point(getXValForValue(segments[j].value));
				}
				
				minMaxChanged = false;
			}
		}
		
		
		
		/*
		* COULD ATTACH LISTENER TO WHOLE SKIN..
		*/
		
		/*
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
		*/
		
		
		private var minute:Number = 60*1000;
		private var hour:Number = 60*minute;
		private var day:Number = 24 * hour;
		private var week:Number = 7 * day;
		private var month:Number = 31 * day;
		private var year:Number = day * 365;
		private var altyear:Number = year * 2;
		private var decade:Number = year * 10;
		private var altdecade:Number = decade * 2;
		
		private function calculateTimeInterval():void{
			
			var diff:Number = Math.abs(enddate.time - startdate.time);
			var st:Number;
			var sd:Date;
			if(diff < hour){
				_timeInterval = hour/4;
				st = startdate.time - _timeInterval;
				sd = new Date(st);
				_chartStartDate = new Date(sd.getFullYear(),sd.getMonth(),sd.getDate(),sd.getHours(),0);
				_dateLabelFormat = formatTimeLong;
			}else if(diff < hour * 6){
				_timeInterval = hour/2;
				st = startdate.time - _timeInterval;
				sd = new Date(st);
				_chartStartDate = new Date(sd.getFullYear(),sd.getMonth(),sd.getDate(),0,0);
				_dateLabelFormat = formatTimeLong;
			}else if(diff < day){
				_timeInterval = hour;
				st = startdate.time - _timeInterval;
				sd = new Date(st);
				_chartStartDate = new Date(sd.getFullYear(),sd.getMonth(),sd.getDate(),0,0);
				_dateLabelFormat = formatTimeLong;
			}else if(diff < day * 3){
				_timeInterval = hour;
				st = startdate.time - _timeInterval;
				sd = new Date(st);
				_chartStartDate = new Date(sd.getFullYear(),sd.getMonth(),sd.getDate(),0,0);
				_dateLabelFormat = formatTime;
			}else if(diff < month){	
				_timeInterval = week;
				st = startdate.time - _timeInterval;
				sd = new Date(st);
				_chartStartDate = new Date(sd.getFullYear(),sd.getMonth(),sd.getDate(),0,0);
				_dateLabelFormat = formatDay;
			}else if(diff < year){
				_timeInterval = month;
				st = startdate.time - _timeInterval;
				sd = new Date(st);
				_chartStartDate = new Date(sd.getFullYear(),sd.getMonth(),0,0,0);
				_dateLabelFormat = formatMonth;
			}else if(diff < year * 5){
				_timeInterval = month * 6;
				st = startdate.time - _timeInterval;
				sd = new Date(st);
				_chartStartDate = new Date(sd.getFullYear(),sd.getMonth(),0,0,0);
				_dateLabelFormat = formatMonth;
			}else if(diff < decade){
				_timeInterval = year;
				st = startdate.time - _timeInterval;
				sd = new Date(st);
				_chartStartDate = new Date(sd.getFullYear(),0,0,0,0);
				_dateLabelFormat = formatYear;
			}else if(diff < decade * 3){
				_timeInterval = altyear;
				st = startdate.time - _timeInterval;
				sd = new Date(st);
				_chartStartDate = new Date(sd.getFullYear(),0,0,0,0);
				_dateLabelFormat = formatYear;
			}else{
				_timeInterval = decade;
				st = startdate.time - _timeInterval;
				sd = new Date(st);
				_chartStartDate = new Date(sd.getFullYear(),0,0,0,0);
				_dateLabelFormat = formatYear;
			}
			
		}
		
		
		
		
		
		private function buildSegments():void{
			
			calculateTimeInterval();
			
			var endtime:Number = enddate.time;
			
			var running:Number;
			var arr:Vector.<AxisItem> = new Vector.<AxisItem>;
			
			var secondsPerPixel:Number = (endtime - _chartStartDate.time) / width;
			var minLabelWidth:Number = 150;
			
			//_timeInterval = minLabelWidth * secondsPerPixel;
			var diff:Number = endtime - startdate.time;
			var ti:Number = _timeInterval;
			var ct:Number = diff/ti;
			var maxLabels:Number = width / minLabelWidth;
			
			var i:int = 1;
			while(ct > maxLabels){
				ti = _timeInterval * i;
				ct = diff/ti;
				i ++;
			}
			
			
			running = _chartStartDate.time;
			
			while(running < endtime){
				arr.push(_dateLabelFormat.call(null,new Date(running)));
				running += ti;
			}
			
			arr.push(_dateLabelFormat.call(null,new Date(running)));			
			segments = arr;

		}
		
		private var _dayLabels:Array = ['Sun','Mon','Tues','Wed','Thurs','Fri','Sat']
		private var _monthLabels:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		
		private function _createLabelInstance($date:Date,$text:String):AxisItem{
			var ai:AxisItem = new AxisItem();
			ai.value = $date.time;
			ai.label = $text;
			return ai;
		}
		
		
		private function formatYear($date:Date):AxisItem{
			var d:Date = new Date($date.fullYearUTC,0);
			return _createLabelInstance(d,d.fullYear.toString());
		}
		
		
		private function formatMonth($date:Date):AxisItem{
			var d:Date = new Date($date.fullYearUTC,$date.monthUTC);
			return _createLabelInstance(d,_monthLabels[d.getMonth()] + ' ' + d.getFullYear());
		}
		
		
		private function formatDay($date:Date):AxisItem{
			var d:Date = new Date($date.fullYearUTC,$date.monthUTC,$date.dateUTC);
			return _createLabelInstance(d,_monthLabels[d.getMonth()] + ' ' + d.getDate());
		}
		
		private function formatTime($date:Date):AxisItem{
			return _createLabelInstance($date, $date.getMonth() + '/' + $date.getDate() + ' ' + $date.getHours() + ':' + _padTime($date.getMinutes()));
		}
		
		private function formatTimeLong($date:Date):AxisItem{
			return _createLabelInstance($date,$date.getMonth() + '/' + $date.getDate() + ' ' + $date.getHours() + ':' + _padTime($date.getMinutes()));
		}
		
		private function _padTime($num:Number,$targetLength:int = 2,$padChar:String = '0'):String{
			var str:String = String($num);
			while(str.length < $targetLength){
				str = str + $padChar;
			}
			return str;
		}
		
	}
}