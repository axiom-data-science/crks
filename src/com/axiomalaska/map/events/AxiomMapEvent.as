package com.axiomalaska.map.events
{
	
	import com.axiomalaska.map.interfaces.IMap;
	
	import flash.events.Event;
	
	public class AxiomMapEvent extends Event
	{
		public static const AXIOM_MAP_READY:String = 'mapready';
		public static const AXIOM_MAP_PAN_COMPLETE:String = 'mappancomplete';
		public static const AXIOM_MAP_ZOOM_COMPLETE:String = 'mapzoomcomplete';
		
		public var map:IMap;
		
		public function AxiomMapEvent($type:String,$map:IMap = null)
		{
			if($map){
				map = $map;
			}
			super($type,true);
		}
	}
}