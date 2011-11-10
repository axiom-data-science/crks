package com.axiomalaska.integratedlayers.models.layers.data.stations_layer
{
	import com.axiomalaska.map.interfaces.ILatLon;
	import com.axiomalaska.map.types.google.overlay.SimpleMarker;
	import com.axiomalaska.utilities.Style;
	//import com.greensock.TweenMax;
	//import com.greensock.easing.Linear;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class RealTimeDataMarker extends SimpleMarker
	{
		public function RealTimeDataMarker($latlon:ILatLon, $data:Object=null, $style:Style=null)
		{
			super($latlon, $data, $style);
		}
		
		public var scalarDataPending:Boolean;
		public var vectorDataPending:Boolean;
		
		public var scalarDataLoading:Boolean;
		public var vectorDataLoading:Boolean;
		
		public var scalarDataLoaded:Boolean;
		public var vectorDataLoaded:Boolean;
		
		public var scalarDataTimeStamp:Date;
		public var vectorDataTimeStamp:Date;
		
		public var scalarData:ResultSetRow;
		public var vectorData:ResultSetRow;
		
		public var loaderDisplay:Sprite;
		public var scalarDataDisplay:Sprite;
		public var vectorDataDisplay:Sprite;
		
		public function get loading():Boolean{
			if(scalarDataLoading || vectorDataLoading){
				return true;
			}
			return false;
		}
		
		public function get active():Boolean{
			if(scalarData || vectorData){
				return true;
			}
			return false;
		}
		
		
		public var dataStyle:Style = new Style({size:18,strokeSize:2});
		
		public function showDataDead():void{
			makeDataDisplay();
			setDataDisplayColor(0xCCCCCC);
		}
		
		public function hideDataDead():void{
			setDataDisplayColor(0xFFFFFF);
			/*if(_dataDeadDisplay && contains(_dataDeadDisplay)){
				removeChild(_dataDeadDisplay);
			}*/
		}
		
		
		private var _dataDisplay:Sprite;
		private var _dataGraphic:Sprite;
		private var _dataText:TextField;
		private var _loaderSpinner:Sprite;
		

		
		private function makeDataDisplay():void{
			if(!_dataDisplay){
				_dataDisplay = new Sprite();
				_dataDisplay.graphics.lineStyle(style.strokeSize,style.stroke);
				_dataDisplay.graphics.drawCircle(0,0,dataStyle.size/2);
				
				_dataGraphic = new Sprite();
				_dataGraphic.graphics.beginFill(0xFFFFFF);
				_dataGraphic.graphics.drawCircle(0,0,dataStyle.size/2 - style.strokeSize/2);
				_dataGraphic.graphics.endFill();
				_dataDisplay.addChild(_dataGraphic);
			}
			if(!contains(_dataDisplay)){
				addChild(_dataDisplay);
			}
		}
		
		private function makeDataText():void{
			makeDataDisplay();
			if(!_dataText){
				_dataText = new TextField();
				_dataText.autoSize = TextFieldAutoSize.CENTER;
				_dataText.multiline = false;
				_dataText.width = dataStyle.size;
				//_dataText.height = dataStyle.size;
				//txt.htmlText = '<font face="arial" size="9" color="' + row.text_color + '">' + nf.format($value) + '</font>';
				//_dataText.border = true;
				_dataText.mouseEnabled = false;
				_dataText.x = -1 * _dataText.width/2;
				_dataText.y = -1 * dataStyle.size/2;				
			}
			if(!_dataDisplay.contains(_dataText)){
				_dataDisplay.addChild(_dataText);
			}
		}
		
		
		private function makeLoaderDisplay():void{
			makeDataDisplay();
			if(!_loaderSpinner){
				_loaderSpinner = drawArc(dataStyle.size/2,0,80);
				_dataDisplay.addChild(_loaderSpinner);
			}
			
		}
		
		public function setDataDisplayText($text:String,$color:String = '#333333'):void{
			makeDataText();
			_dataText.htmlText = '<font face="arial" size="9" color="' + $color + '">' + $text + '</font>';
		}
		
		public function setDataDisplayColor($color:uint = 0xFFFFFF):void{
			makeDataDisplay();
			var clr:ColorTransform = _dataGraphic.transform.colorTransform;
			clr.color = $color;
			_dataGraphic.transform.colorTransform = clr;
		}
		
		public function showData():void{
			makeDataDisplay();
			addChild(_dataDisplay);
		}
		
		public function clearVectorData():void{
			vectorData = null;
			vectorDataTimeStamp = null;
			vectorDataLoaded = false;
			if(vectorDataDisplay && contains(vectorDataDisplay)){
				removeChild(vectorDataDisplay);
			}
			stopLoader();
		}
		
		public function clearScalarData():void{
			scalarData = null;
			scalarDataLoaded = false;
			scalarDataTimeStamp = null
			setDataDisplayText('');
			setDataDisplayColor();
			stopLoader();
		}
		
		
		public function hideData():void{
			if(_dataDisplay && contains(_dataDisplay)){
				removeChild(_dataDisplay);
			}
		}
		
		public function startLoader():void{
			makeLoaderDisplay();
			if(_loaderSpinner && _dataDisplay && _dataDisplay.contains(_loaderSpinner)){
				_loaderSpinner.visible = true;
				/*if(TweenMax.getTweensOf(_loaderSpinner).length < 1){
					TweenMax.to(_loaderSpinner,2,{rotation:355,repeat:-1,ease:Linear.easeNone});
				}*//*else{
					trace('really?');
				}*/
				//toTop();
			}
		}
		
		public function stopLoader():void{
			if(!loading){
				if(_loaderSpinner && _dataDisplay && _dataDisplay.contains(_loaderSpinner)){
					//TweenMax.killTweensOf(_loaderSpinner);
					_loaderSpinner.visible = false;
				}
			}
		}
		
		public function toTop():void{
			if(parent){
				var layer:DisplayObjectContainer = parent;
				layer.setChildIndex(this,layer.numChildren - 1);
			}
		}
		
		public function toBottom():void{
			if(parent){
				var layer:DisplayObjectContainer = parent;
				layer.setChildIndex(this,0);
			}
		}
		
		public function makeVectorWedge(radius:Number, midAngle:Number, arcSpan:Number, steps:int):Sprite{
			
			
			var startAngle:Number = (midAngle - arcSpan/2) / 360;
			var arcAngle:Number = arcSpan / 360;
			var centerX:Number = 0;
			var centerY:Number = 0;
			
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(1,0xFFFFFF);
			sp.graphics.beginFill(0x990000,.4);
			
			
			
			startAngle -= .25;
			//
			var twoPI:Number = 2 * Math.PI;
			var angleStep:Number = arcAngle/steps;
			sp.graphics.moveTo(centerX, centerY);
			var xx:Number = centerX + Math.cos(startAngle * twoPI) * radius;
			var yy:Number = centerY + Math.sin(startAngle * twoPI) * radius;
			sp.graphics.lineTo(xx, yy);
			for(var i:int=1; i<=steps; i++){
				var angle:Number = startAngle + i * angleStep;
				xx = centerX + Math.cos(angle * twoPI) * radius;
				yy = centerY + Math.sin(angle * twoPI) * radius;
				sp.graphics.lineTo(xx, yy);
			}
			sp.graphics.lineTo(centerX, centerY);
			return sp;
		}
		
		private function drawArc(radius:Number, midAngle:Number = 0, spanAngle:Number = 100, steps:int = 20):Sprite{
			
			var startAngle:Number = (midAngle - spanAngle/2) / 360;
			var arcAngle:Number = spanAngle / 360;
			var centerX:Number = 0;
			var centerY:Number = 0;
			
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(dataStyle.strokeSize,0xFFFFFF);
			//
			// Rotate the point of 0 rotation 1/4 turn counter-clockwise.
			startAngle -= .25;
			//
			var twoPI:Number = 2 * Math.PI;
			var angleStep:Number = arcAngle/steps;
			//sp.graphics.moveTo(centerX, centerY);
			var xx:Number = centerX + Math.cos(startAngle * twoPI) * radius;
			var yy:Number = centerY + Math.sin(startAngle * twoPI) * radius;
			sp.graphics.moveTo(xx, yy);
			for(var i:int=1; i<=steps; i++){
				var angle:Number = startAngle + i * angleStep;
				xx = centerX + Math.cos(angle * twoPI) * radius;
				yy = centerY + Math.sin(angle * twoPI) * radius;
				sp.graphics.lineTo(xx, yy);
			}
			//sp.graphics.lineTo(centerX, centerY);
			return sp;
		}
		
	}
}