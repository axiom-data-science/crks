package com.axiomalaska.charts.implementations
{
	import com.axiomalaska.charts.base.AxiomChartPlottableItem;
	import com.axiomalaska.charts.base.SkinnableAxiomChartElement;
	import com.axiomalaska.charts.scale.AbstractScale;
	import com.axiomalaska.charts.scale.IScale;
	
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	

	

	
	[Style(name="lineColor", format="Color")]
	[Style(name="lineWeight", format="int")]
	[Style(name="displayPoints", format="bool")]
	[Style(name="displayFill", format="bool")]
	
	public class SkinnableLineChartImplementation extends SkinnableAxiomChartElement implements IAxiomChartImplementation
	{

		
		/* TEMPLATE VARS */
		
		
		/* PUBLIC VARS */
		
		[Bindable]
		override public var plottablePointFormatFunction:Function = defaultLineChartPointFormatFunction;
			
		private function defaultLineChartPointFormatFunction($obj:Object):Point{
			if(xField && $obj.hasOwnProperty(xField) && yField && $obj.hasOwnProperty(yField)){
				return new Point(horizontalScale.valueToLayout($obj[xField]),verticalScale.valueToLayout($obj[yField],true));
			}
			return null;
		}
		
		
		private var _xField:String;
		
		[Bindable]
		public function set xField($xField:String):void{
			if(_xField != $xField){
				_xField = $xField;
				_dataInvalid = true;
				//trace('XFIELD INVALID' + this.id + ' => ' + getQualifiedClassName(this));
				invalidate();
			}
		}
		public function get xField():String{
			return _xField;
		}
		
		private var _yField:String;
		
		[Bindable]
		public function set yField($yField:String):void{
			if(_yField != $yField){
				_yField = $yField;
				_dataInvalid = true;
				//trace('YFIELD INVALID' + this.id + ' => ' + getQualifiedClassName(this));
				invalidate();
			}
		}
		public function get yField():String{
			return _yField;
		}
		
		private var _labelField:String;
		
		[Bindable]
		public function set labelField($labelField:String):void{
			if(_labelField != $labelField){
				_labelField = $labelField;
				invalidate();
			}
		}
		public function get labelField():String{
			return _labelField;
		}
		
		
		private var _dataProvider:ArrayCollection;
		
		[Bindable]
		public function set dataProvider($dataProvider:ArrayCollection):void{
			if(_dataProvider != $dataProvider){
				_dataProvider = $dataProvider;
				addDataProviderListeners();
				//trace('DATAPROVIDER BEING SET INVALID ' + this.id + ' => ' + getQualifiedClassName(this));
				_dataInvalid = true;
				redraw();
				//invalidate();
			}
		}
		public function get dataProvider():ArrayCollection{
			return _dataProvider;
		}
		
		private function addDataProviderListeners():void{
			dataProvider.filterFunction = filterDataProvider;
			dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,onDataProviderChange);
		}
		

		
		private function filterDataProvider($item:Object):Boolean{
			//trace('DP LENGTH FILTERING!' + dataProvider.length);
			if($item[xField].time >= horizontalScale.minValue && $item[xField].time <= horizontalScale.maxValue){
				return true;
			}else{
				
				var prevIndex:int = dataProvider.getItemIndex($item) - 1;
				if(prevIndex >= 0){
					var prevItem:Object = dataProvider.getItemAt(prevIndex);
					if(prevItem.time >= horizontalScale.minValue && prevItem.time <= horizontalScale.maxValue){
						return true;
					}
				}
				
				var nextIndex:int = dataProvider.getItemIndex($item) + 1;
				if(nextIndex < dataProvider.length){
					var nextItem:Object = dataProvider.getItemAt(nextIndex);
					if(nextItem.time >= horizontalScale.minValue && nextItem.time <= horizontalScale.maxValue){
						return true;
					}
				}
				
			}
			return false;
		}
		
		private var _dpLength:int;
		private function onDataProviderChange($evt:CollectionEvent):void{
			
			if($evt.kind == CollectionEventKind.REFRESH && _dpLength != dataProvider.length){
				_dataInvalid = true;
				//trace('DP CHANGED INVALID ' + this.id + ' => ' + getQualifiedClassName(this));
				//trace(this.id + ' DP LENGTH = ' + dataProvider.length);
				//invalidate();
				_dpLength = dataProvider.length;
				redraw();
				
			}
		}
		
		private function removeDataProviderListeners():void{
			dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,onDataProviderChange);
		}
		
		
		private var _horizontalScale:IScale;
		
		[Bindable]
		public function set horizontalScale($horizontalScale:IScale):void{
			if(_horizontalScale != $horizontalScale){
				_horizontalScale = $horizontalScale;
				addHorizontalScaleListeners();
				invalidate();
			}
		}
		public function get horizontalScale():IScale{
			return _horizontalScale;
		}
		
		private function addHorizontalScaleListeners():void {
			if (!_horizontalScale) return;
			
			AbstractScale(_horizontalScale).addEventListener("invalidate",onHorizontalScaleChange);
			AbstractScale(_horizontalScale).addEventListener("dataFieldChange",onHorizontalScaleChange);
			AbstractScale(_horizontalScale).addEventListener("minValueChange",onHorizontalScaleChange);
			AbstractScale(_horizontalScale).addEventListener("maxValueChange",onHorizontalScaleChange);
			AbstractScale(_horizontalScale).addEventListener("minLayoutChange",onHorizontalScaleChange);
			AbstractScale(_horizontalScale).addEventListener("maxLayoutChange",onHorizontalScaleChange);
			
		}
		
		private function removeHorizontalScaleListeners():void {
			if (!_horizontalScale) return;
			AbstractScale(_horizontalScale).removeEventListener("invalidate",onHorizontalScaleChange);
			AbstractScale(_horizontalScale).removeEventListener("dataFieldChange",onHorizontalScaleChange);
			AbstractScale(_horizontalScale).removeEventListener("minValueChange",onHorizontalScaleChange);
			AbstractScale(_horizontalScale).removeEventListener("maxValueChange",onHorizontalScaleChange);
			AbstractScale(_horizontalScale).removeEventListener("minLayoutChange",onHorizontalScaleChange);
			AbstractScale(_horizontalScale).removeEventListener("maxLayoutChange",onHorizontalScaleChange);
		}
		
		private function onHorizontalScaleChange(e:Event):void {
			//trace('HS INVALID' + this.id + ' => ' + getQualifiedClassName(this));
			if(dataProvider){
				dataProvider.refresh();
				//trace('HO SCALED CHANGED! (' + this.id + ') ' + flash.utils.getQualifiedClassName(this));
				_dataInvalid = true;
			}
			//invalidate();
		}
		
		
		private var _verticalScale:IScale;
		
		[Bindable]
		public function set verticalScale($verticalScale:IScale):void{
			if(_verticalScale != $verticalScale){
				_verticalScale = $verticalScale;
				addVerticalScaleListeners();
				invalidate();
			}
		}
		public function get verticalScale():IScale{
			return _verticalScale;
		}
		
		private function addVerticalScaleListeners():void {
			AbstractScale(_verticalScale).addEventListener("invalidate",onVerticalScaleChange);
			AbstractScale(_verticalScale).addEventListener("dataFieldChange",onVerticalScaleChange);
			AbstractScale(_verticalScale).addEventListener("minValueChange",onVerticalScaleChange);
			AbstractScale(_verticalScale).addEventListener("maxValueChange",onVerticalScaleChange);
			AbstractScale(_verticalScale).addEventListener("minLayoutChange",onVerticalScaleChange);
			AbstractScale(_verticalScale).addEventListener("maxLayoutChange",onVerticalScaleChange);
			
		}
		
		private function removeVerticalScaleListeners():void {
			if (!_verticalScale) return;
			AbstractScale(_verticalScale).removeEventListener("invalidate",onVerticalScaleChange);
			AbstractScale(_verticalScale).removeEventListener("dataFieldChange",onVerticalScaleChange);
			AbstractScale(_verticalScale).removeEventListener("minValueChange",onVerticalScaleChange);
			AbstractScale(_verticalScale).removeEventListener("maxValueChange",onVerticalScaleChange);
			AbstractScale(_verticalScale).removeEventListener("minLayoutChange",onVerticalScaleChange);
			AbstractScale(_verticalScale).removeEventListener("maxLayoutChange",onVerticalScaleChange);
			
		}
		
		private function onVerticalScaleChange(e:Event):void {
			if(dataProvider){
				dataProvider.refresh();
				_dataInvalid = true;
				invalidate();
			}
		}
		
		private var _dataInvalid:Boolean = false;
		
		override public function readyForRedraw():Boolean{
			if(
				_dataInvalid === true &&
				dataProvider && dataProvider.length > 0 && 
				horizontalScale && horizontalScale.minValue && horizontalScale.maxValue && horizontalScale.maxLayout &&
				verticalScale && verticalScale.minValue && verticalScale.maxValue && verticalScale.maxLayout &&
				xField && yField
			){
				// && graphicalElement && graphicalElement.width > 0 && graphicalElement.height > 0
				return true;
			}
			return false;
		}
		
		override public function buildPlottableItems():void{						
			if(readyForRedraw()){
				//trace(this.id + ' DI = ' + _dataInvalid);
				_dataInvalid = false;
				
				var vec:Vector.<AxiomChartPlottableItem> = new Vector.<AxiomChartPlottableItem>;
				for each(var obj:Object in dataProvider){					
					vec.push(createPlottableItem(obj));
				}
				
				setPlottableItems(vec);	
				
				
				//trace('REBUILT (' + dataProvider.length + ') ' + this.id + ' => ' + getQualifiedClassName(this));
				//trace(this.id + ' DI = ' + _dataInvalid);
			}
			
		}
		
		override public function getNearestPlottableItem($point:Point):AxiomChartPlottableItem{			
			var ai:AxiomChartPlottableItem = _findPlottableItem($point.x,'x');
			return ai;
			
		}
		
		private function _findPlottableItem($value:Number,$point_key:String = 'x'):AxiomChartPlottableItem{
			
			var selected:AxiomChartPlottableItem;
			
			if(plottableItems && plottableItems.length > 0){
				var first:AxiomChartPlottableItem = plottableItems[0];
				var last:AxiomChartPlottableItem = plottableItems[plottableItems.length - 1];
				//trace('DATE = ' + $date.toLocaleDateString() + ' FIRST = ' + first.startTimeUtc.toLocaleDateString() + ' LAST = ' + last.startTimeUtc.toLocaleDateString());
				
				if(
					$value >= first.point[$point_key] && 
					$value <= last.point[$point_key]
				)
				{
					var solved:Boolean = false;
					var top_index:int = plottableItems.length - 1;
					var bottom_index:int = 0;
					var diff:int = top_index - bottom_index;
					var index:int = Math.floor((top_index + bottom_index)/ 2);
					//trace('START INDEX = ' + index + ' == ' + (rasterTimeStratas.getItemAt(index) as RasterTimeStrata).startTimeUtc.toLocaleDateString());
					
					for(var ct:int = 0;ct < plottableItems.length; ct ++){
						
						var test:AxiomChartPlottableItem = plottableItems[index];
						
						//trace('testing x = ' + test.point[$point_key]);
						
						if($value > test.point[$point_key]){
							bottom_index = index;
						}else{
							top_index = index;
						}
						
						diff = top_index - bottom_index;
						index = Math.floor((top_index + bottom_index)/ 2);
						
						//trace(index);
						
						if(diff < 2){
							
							var existDiff:Number = Math.abs($value - test.point[$point_key]);
							
							if(index > 0){
								var prev:AxiomChartPlottableItem = plottableItems[index - 1];
								var prevDiff:Number = Math.abs($value - prev.point[$point_key]);
								
								if(prevDiff < existDiff){
									test = prev;
								}
							}
							
							if(index < plottableItems.length - 1){
								var next:AxiomChartPlottableItem = plottableItems[index + 1];
								var nextDiff:Number = Math.abs($value - next.point[$point_key]);
								if(nextDiff < existDiff){
									test = next;
								}
							}
							
							
							selected = test;
							break;
						}
					}
					
					//trace('found x = ' + selected.point.x);
					
					//trace('--> ' + index);

				}else{
					
					if($value < first.point[$point_key]){

						selected = first;
					}else{
						selected = last;
					}
				}
				
			}
			
			return selected;
		}
		
		
		
	}
}