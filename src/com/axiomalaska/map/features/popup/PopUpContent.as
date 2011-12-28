package com.axiomalaska.map.features.popup
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import mx.controls.Text;
	
	public class PopUpContent extends Sprite
	{
		
		[Embed(source = "/assets/images/close.png")]
		private var CloseButtonImage:Class;
		
		public var titleHTML:String;
		public var contentHTML:String;
		public var title:Sprite;
		public var content:Sprite;
		public var closeButton:Sprite;
		public var hasCloseButton:Boolean = true;
		public var stroke:uint = 0xCCCCCC;
		public var strokeWidth:int = 2;
		public var backgroundColor:uint = 0xFFFFFF;
		public var backgroundAlpha:Number = 1;
		public var default_width:int = 200;
		public var padding:int = 5;
		public var cornerRadius:int = 10;
		
		public function PopUpContent($titleHTML:String = null,$contentHTML:String = null,$default_width:Number = NaN,$params:Object = null)
		{
			if($titleHTML){
				titleHTML = $titleHTML;
			}
			
			if($contentHTML){
				contentHTML = $contentHTML;
			}
			
			if(!isNaN($default_width)){
				default_width = $default_width;
			}
			
			if($params){
				for(var p:String in $params){
					if(this.hasOwnProperty(p)){
						this[p] = $params[p];
					}
				}
			}

			super();
			draw();
		}
		
		public function draw():void{
			
			while(this.numChildren > 0){
				this.removeChildAt(0);
			}
			
			if(hasCloseButton){
				if(!closeButton){
					closeButton = drawCloseButton();
				}
			}
			
			if(!title){
				title = drawTitle();
				title.y = padding;
				title.x = padding;
			}

			
			if(!content){
				content = drawContent();
			}
			
			content.y = padding;
			content.x = padding;

			
			content.y += title.y + title.height;
			
			addChild(title);
			addChild(content);
			
			graphics.lineStyle(strokeWidth,stroke);
			graphics.beginFill(backgroundColor,backgroundAlpha);
			graphics.drawRoundRect(0,0,default_width + padding*2,title.height + content.height + padding*2,cornerRadius,cornerRadius);
			
			var _mask:Sprite = new Sprite();
			_mask.mouseChildren = true;
			_mask.graphics.beginFill(0xFFFFFF);
			_mask.graphics.drawRoundRect(0,0,default_width + padding*2 - 50,title.height + content.height + padding*2,cornerRadius,cornerRadius);
			//this.mask = _mask;
			
			if(hasCloseButton){
				closeButton.x = default_width + padding - closeButton.width;
				closeButton.y = padding;
				//cloaseButton.y = 
				addChildAt(closeButton,this.numChildren - 1);
			}
			
		}
		
		public function drawTitle():Sprite{
			var _sp:Sprite = new Sprite();
			_sp.mouseChildren = true;
			var _title_txt:TextField = new TextField();
			_title_txt.width = default_width;
			
			if(hasCloseButton){
				_title_txt.width -= closeButton.width - 4;
			}
			
			_title_txt.autoSize = 'left';
			_title_txt.wordWrap = true;
			_title_txt.multiline = true;			
			if(titleHTML){
				_title_txt.htmlText = '<font face="Arial" size="13"><b>' + titleHTML + '</b></font>';
				_sp.addChild(_title_txt);
				//_sp.graphics.beginFill(0xFFFFFF);
				_sp.graphics.drawRect(0,0,_title_txt.width,_title_txt.height);
			}
			
			return _sp;
		}
		
		public function drawContent():Sprite{
			var _sp:Sprite = new Sprite();
			_sp.mouseChildren = true;
			var _text_txt:TextField = new TextField();
			_text_txt.width = default_width;
			_text_txt.autoSize = 'left';
			_text_txt.wordWrap = true;
			_text_txt.multiline = true;
			if(contentHTML){
				_text_txt.htmlText = '<font color="#333333" face="Arial" size="12">' + contentHTML + '</font>';
				_sp.addChild(_text_txt);
				_sp.graphics.drawRect(0,0,_text_txt.width,_text_txt.height);
			}			
			
			return _sp;
		}
		
		public function drawCloseButton():Sprite{
			var _button:DisplayObject = new CloseButtonImage();
			var _over:Sprite = new Sprite();
			_over.graphics.beginFill(0xFFFFFF,0);
			_over.graphics.drawRect(0,0,_button.width,_button.height);
			_over.addChild(_button);
			_over.buttonMode = true;
			return _over;
		}
	}
}