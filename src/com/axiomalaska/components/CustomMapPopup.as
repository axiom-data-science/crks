package com.axiomalaska.components
{
	import com.gskinner.motion.GTween;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import mx.controls.Image;
	
	import org.openscales.core.basetypes.Bounds;
	import org.openscales.core.basetypes.LonLat;
	import org.openscales.core.basetypes.Pixel;
	import org.openscales.core.basetypes.Size; 
	import org.openscales.core.control.ui.Button;
	import org.openscales.core.feature.Feature;
	import org.openscales.core.popup.*;
	
	/**
	 * Anchored popup, usually the anchor is a Feature
	 */
	public class CustomMapPopup extends Popup
	{
		/**
		 * Relative position of the popup ("br", "tr", "tl" or "bl").
		 * TODO : use an enum for that
		 */
		private var _relativePosition:String = "";
		
		static public var BR:String = "br";
		static public var TR:String = "tr";
		static public var TL:String = "tl";
		static public var BL:String = "bl";
		
		private var _anchor:Sprite = null;
		public var title:TextField = new TextField;
		public var description:TextField = new TextField;
		public var imageHolder:Sprite = new Sprite();
		private var loader:Loader = new Loader();
		private var img:Image = new Image;
		public var hasImage:Boolean = false;
		public var content:Sprite = new Sprite;
		
		[Embed(source="/assets/images/close.gif")]
		private var _closeImg:Class;
		
		public function CustomMapPopup(lonlat:LonLat = null, background:uint = 0, border:Number = NaN, size:Size = null, contentHTML:String = "", anchor:Sprite = null, closeBox:Boolean = true) {
			super(lonlat, background, border, size, contentHTML, closeBox);
			
			this._anchor = anchor;
		}
		
		public function setTitle($title:String):void{
			title.width = 250;
			//title.border = true;
			title.autoSize = 'left';
			title.wordWrap = true;
			title.multiline = true;
			title.htmlText = '<font face="arial" size="14" color="#FFFFFF"><b>' + $title + '</font>';
		}
		
		public function setDescription($description:String):void{
			description.y = title.y + title.height + 10;
			description.width = 250;
			//description.border = true;
			description.autoSize = 'left';
			description.wordWrap = true;
			description.multiline = true;
			description.htmlText = '<font face="arial" size="12">' + $description + '</font>';
		}
		
		public function setImage($imagesrc:String):void{
			hasImage = true;
			var _maxw:Number = 200;
			var _maxh:Number = 150;
			imageHolder.graphics.beginFill(0xFFFFFF);
			imageHolder.graphics.drawRect(0,0,_maxw,_maxh);
			imageHolder.y = description.y + description.height + 10;
			var _loadTxt:TextField = new TextField();
			_loadTxt.multiline = false;
			_loadTxt.width = imageHolder.width;
			_loadTxt.htmlText = '<p align="center"><font face="arial" size="12" color="#666666">Loading image..</font></p>';
			_loadTxt.y = imageHolder.height/2 - _loadTxt.height/2;
			imageHolder.addChild(_loadTxt);
			/*img = new Image();
			img.load($imagesrc);
			img.addEventListener(Event.COMPLETE,function($evt:Event):void{
				
				
				var _w:Number = $evt.currentTarget.content.width;
				var _h:Number = $evt.currentTarget.content.height;
				var _nw:Number = _maxw;
				var _nh:Number = (_h *_nw) / _w;
				
				if(_nh > _maxh){
					_nh = _maxh;
					_nw = (_w * _nh) / _h;
				}
				
				
				trace('H = ' + _h + ' W= ' + _w + ' NH= ' + _nh + ' NW = ' + _nw);
				
				$evt.currentTarget.content.width = _nw;
				$evt.currentTarget.content.height = _nh;
				//$evt.currentTarget.content.x = 5;
				//$evt.currentTarget.content.y = description.y + description.height;
				
				while(imageHolder.numChildren > 0){
					imageHolder.removeChildAt(0);
				}
				imageHolder.graphics.clear();
				imageHolder.addChild($evt.currentTarget.content);
				//addChild($evt.currentTarget.content);
				
				trace('DONE');
			});*/
			
			var filerequest:URLRequest = new URLRequest($imagesrc);
			
			try{
				loader.load(filerequest);
			}catch($err:Object){
				trace('ERROR: ' + $err.message);
			}
			
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function($evt:IOErrorEvent):void{
				trace('IO ERROR');
				_loadTxt.htmlText = '<p align="center"><font face="arial" size="12" color="#660000">Image not available.</font></p>';
			});
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function($evt:Event):void{
				
				var _w:Number = loader.width;
				var _h:Number = loader.height;
				var _nw:Number = _maxw;
				var _nh:Number = (_h *_nw) / _w;
				
				if(_nh > _maxh){
					_nh = _maxh;
					_nw = (_w * _nh) / _h;
				}
				
				
				trace('H = ' + _h + ' W= ' + _w + ' NH= ' + _nh + ' NW = ' + _nw);
				
				loader.width = _nw;
				loader.height = _nh;
				//loader.x = 5;
				//loader.y = description.y + description.height;
				
				while(imageHolder.numChildren > 0){
					imageHolder.removeChildAt(0);
				}
				imageHolder.graphics.clear();
				imageHolder.addChild(loader);
			});

			
		}
		
		//private funtion _formatText($text:String,$textField:TextField,
		
		
		override public function draw(px:Pixel=null):void {
			if (px == null) {
				if ((this.lonlat != null) && (this.map != null)) {
					px = this.map.getLayerPxFromLonLat(this.lonlat);
					this.relativePosition = this.calculateRelativePosition(px);
				}
			}
			
			this.position = px;
			

			
			this.graphics.clear();
			while (this.numChildren>0) {
				this.removeChildAt(0);
			}
			
			while (content.numChildren>0){
				content.removeChildAt(0);
			}
			
			
			content.addChild(title);
			content.addChild(description);
			if(hasImage){
				content.addChild(imageHolder);
			}
			
			//content.graphics.beginFill(0xFFCC99);
			//content.graphics.drawRect(0,0,content.width,content.height);
			content.x = 5;
			content.y = 5;
			//this.size();
			size = new Size(content.width + 2*content.x,content.height + 2*content.y + 10);
			
			
			
			

				
			this.graphics.beginFill(this.background);
			this.graphics.lineStyle(this.border, 0x707070, 1, true);
			this.graphics.drawRoundRect(0,0,this.size.w, this.size.h, 20, 20);
			this.graphics.endFill();
			this.width = this.size.w;
			this.height = this.size.h;
			
			if(hasImage){
				imageHolder.x = content.width/2 - imageHolder.width/2;
			}
			
			//BACKGROUND FOR TITLE
			this.graphics.beginFill(0x707070);
			this.graphics.drawRoundRectComplex(0,0,this.size.w,content.y + title.height + 3,10,10,0,0);
			//this.graphics.drawRoundRect(0,0,this.size.w,content.y + title.height, 20, 20);
			//this.graphics.moveTo(0,title.height + content.y + 30);
			//this.graphics.beginFill(0x707070);
			//this.graphics.drawRect(0,10,this.size.w,content.y + title.height);

			
			this.addChild(content);
			
			//this.createPopupContent();
			
			if (this.closeBox == true) {
				
				var img:Bitmap = new this._closeImg();
				
				var closeImg:Button = new Button("close", img, new Pixel(this.size.w - 22 - this.border, this.border + 2));
				
				this.addChild(closeImg);
				
				closeImg.addEventListener(MouseEvent.CLICK, closePopup);
			}
			
			
			
			//super.draw(px);
		}
		
		public function calculateRelativePosition(px:Pixel):String {
			var lonlat:LonLat = this.map.getLonLatFromLayerPx(px);
			
			var extent:Bounds = this.map.extent;
			var quadrant:String = extent.determineQuadrant(lonlat);
			
			return Bounds.oppositeQuadrant(quadrant);
		}
		
		override public function set position(px:Pixel):void {
			var newPx:Pixel = this.calculateNewPx(px);
			super.position = newPx;
		}
		
		override public function set size(size:Size):void {
			super.size = size;
			
			if ((this.lonlat) && (this.map)) {
				var px:Pixel = this.map.getLayerPxFromLonLat(this.lonlat);
				this.position = px;
			}
		}
		
		public function calculateNewPx(px:Pixel):Pixel {
			var newPx:Pixel = px;
			
			var top:Boolean = (this.relativePosition == TR || this.relativePosition == TL);
			
			if(top){
				newPx.y += -this._anchor.height/2 - this.size.h;
			}
			else{
				newPx.y += this._anchor.height/2;
			}
			
			var left:Boolean = (this.relativePosition == BL || this.relativePosition == TL);
			
			if(left){
				newPx.x += -this._anchor.width/2 - this.size.w;
			}
			else{
				newPx.x += this._anchor.width/2;
			}
			
			return newPx;
		}
		
		public function get relativePosition():String {
			return this._relativePosition;
		}
		
		public function set relativePosition(value:String):void {
			this._relativePosition = value;
		}
		
		override public function set feature(value:Feature):void {
			super.feature = value;
			this._anchor = value;
		}
	}
}