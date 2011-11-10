package com.axiomalaska.crks.dto {
// Generated May 28, 2011 5:53:51 PM
import mx.collections.ArrayCollection;

	[Bindable]
	public class ModelVariableGenerated extends AbstractDTO {
		public var id:int;
		public var idParameterType:int;
		public var parameterType:ParameterType;
		public var idParameter:int;
		public var parameter:Parameter;
		public var idModel:int;
		public var model:Model;
		public var variableName:String;
		public var label:String;
		public var description:String;
		public var unit:String;
		public var statsMin:Number;
		public var statsMax:Number;
		public var statsMean:Number;
		public var statsStdDev:Number;
		public var vector:Boolean;
		public var statsN:Number;
		public var statsSum:Number;
		public var statsSquareSum:Number;
		public var statsLastTimeSlice:Date;
		public var normal:Boolean;
		public var rasterLayers:ArrayCollection = new ArrayCollection();
	}
}
