package com.axiomalaska.crks.utilities
{
	[Bindable]
	public class ApplicationState
	{
		public var property:String;
		public var value:String;
		public var children:Vector.<ApplicationState>;
		public var parent:ApplicationState;
	}
}