package com.axiomalaska.integratedlayers.views.panels.help
{
	import com.axiomalaska.crks.helpers.HelpMetaData;
	import com.axiomalaska.crks.interfaces.IMetaDataItem;
	
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SkinnableMetaDataDisplay extends SkinnableComponent
	{
		
		
		[Bindable]
		public var meta_data_item:IMetaDataItem;
		
		
		private var _help_meta_data:HelpMetaData;
		
		[Bindable]
		public function set help_meta_data($help_meta_data:HelpMetaData):void{
			_help_meta_data = $help_meta_data;
		}
		public function get help_meta_data():HelpMetaData{
			return _help_meta_data;
		}
		
		
		[Bindable]
		public var content:Group;
		
		[Bindable]
		public var map:Group;
		
		[Bindable]
		public var relatedItems:Group;
		
		[Bindable]
		public var navigation:Group;
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="true")]
		public var contentDisplay:Group;
		
		[SkinPart(required="true")]
		public var mapDisplay:Group;
		
		[SkinPart(required="true")]
		public var relatedItemsDisplay:Group;
		
		[SkinPart(required="true")]
		public var navigationDisplay:Group;
		
		
		[SkinState("loading")]
		[SkinState("loaded")]
		
		override protected function getCurrentSkinState():String {
			return currentState;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			
			if(content !== null && instance == contentDisplay){
				contentDisplay.addElement(content);
			}else if(map !== null && instance == mapDisplay){
				mapDisplay.addElement(map);
			}else if(relatedItems !== null && instance == relatedItemsDisplay){
				relatedItemsDisplay.addElement(relatedItems);
			}else if(navigation !== null && instance == navigationDisplay){
				navigationDisplay.addElement(navigation);
			}

		}
		
		private var _isOpen:Boolean;
		
		public function open():void{
			if(!_isOpen){
				PopUpManager.addPopUp(this,FlexGlobals.topLevelApplication as DisplayObject,true);
				PopUpManager.centerPopUp(this);
				_isOpen = true;
			}	
		}
		
		public function close():void{
			PopUpManager.removePopUp(this);
			_isOpen = false;
		}
		
		
		
		
	}
}