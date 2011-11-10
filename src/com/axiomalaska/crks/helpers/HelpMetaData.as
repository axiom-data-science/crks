package com.axiomalaska.crks.helpers
{
	import com.axiomalaska.models.SpatialBounds;
	import com.axiomalaska.models.Temporal;
	import com.axiomalaska.crks.interfaces.IMetaDataItem;
	import com.axiomalaska.crks.interfaces.ISpatialExtentItem;

	[Bindable]
	public class HelpMetaData implements ISpatialExtentItem
	{
		public var source_item:IMetaDataItem;
		public var label:String;
		public var description:String;
		public var loading:Boolean = true;
		public var temporal:Temporal;
		public var spatialBounds:SpatialBounds;
		public var metaDataUrl:String;
		
		
		public function set hasBounds($hasBounds:Boolean):void{
			
		}
		public function get hasBounds():Boolean{
			if(spatialBounds){
				return true;
			}
			return false;
		}
		

	}
}