package com.axiomalaska.integratedlayers.views.panels.help
{
	import com.axiomalaska.crks.interfaces.IMetaDataItem;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexMouseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class HelpPopupDisplay extends SkinnableComponent
	{
		
		
		[Bindable]
		public var meta_data_item:IMetaDataItem;
		
		[Bindable]
		public var content:Group;
		
		[Bindable]
		public var title:String;
		
		[Bindable]
		public var titleBarContent:Group;
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="true")]
		public var contentDisplay:Group;
		
		[SkinPart(required="true")]
		public var titleBarContentDisplay:Group;
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			
			if(content !== null && instance == contentDisplay){
				contentDisplay.addElement(content);
			}
			
			if(titleBarContent !== null && instance == titleBarContentDisplay){
				titleBarContentDisplay.addElement(titleBarContent);
			}
			
			

		}
		
		protected var isOpen:Boolean;
		
		public function open():void{
			if(!isOpen){
				PopUpManager.addPopUp(this,FlexGlobals.topLevelApplication as DisplayObject,true);
				PopUpManager.centerPopUp(this);
				isOpen = true;
				
				this.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,close);
			}	
		}
		
		public function close($evt:Event = null):void{
			PopUpManager.removePopUp(this);
			isOpen = false;
			this.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,close);
		}
		
		
		
		
	}
}