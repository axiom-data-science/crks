package com.axiomalaska.crks.service.result{
	import flash.utils.ByteArray;
	
	[RemoteClass(alias="com.axiomalaska.crks.service.result.WfsResult")]
	public class WfsResult{
		public var filename:String;
		public var ext:String;
		public var mimetype:String;
		public var bytes:ByteArray;
	}
}