package com.axiomalaska.integratedlayers.events
{
	import com.axiomalaska.crks.dto.Module;
	
	import flash.events.Event;
	
	public class ModuleEvent extends Event
	{
		
		public static const SHOW_MODULE:String = 'show_module';
		public static const HIDE_MODULE:String = 'hide_module';
		
		public var module:Module;
		
		public function ModuleEvent($type:String, $module:com.axiomalaska.crks.dto.Module)
		{
			super($type, true);
			module = $module;
		}
	}
}