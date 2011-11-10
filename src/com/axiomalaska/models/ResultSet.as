package com.axiomalaska.models
{
	import mx.charts.chartClasses.DataDescription;
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="com.axiom.services.netcdf.data.ResultSet")]	
	public class ResultSet
	{
		//array of VariableDescriptors
		public var descriptors:Array;
		
		public var descriptor:VariableDescriptor;
		
		//array of VariableDatas
		public var data:Array;
		public var dataObject:Object;
		public var stations:Array;
		public var sources:Object;
		public var sensors:Object;
		
		//
		public var loading:Boolean = true;
		public var metadata:MetaDataItem;
		public var currentTime:Date;
		
		public var depth:int;
		
		
		private var _collection:ArrayCollection;
		public function set collection($collection:ArrayCollection):void{
			_collection = $collection;
		}
		public function get collection():ArrayCollection{
			if(!_collection){
				var _src:Array = [];
				var vd:VariableDescriptor;
				if(descriptor){
					vd = descriptor;
				}else if(descriptors){
					vd = descriptors[0];
				}
				var d:VariableData = data[vd.primaryKey]
				
				
				//var dic:Object = {};	
				
				//track every row that isn't null
				//and insert a key, so that we can match result 
				//set data with period indexes sent over with initial layers load
				var period_key:int = 0;
					
				for(var i:int = 0;i < d.values.length;i ++){
					
					var ob:Object = {};
					
					
					//if(d.values[i] != null){
						if(d.metadata.dataType == VariableType.DATE && d.values[i] is Date){
							
							var td:Date = d.values[i];
							//var nd:Date = new Date(td.fullYear,td.month,td.date,td.hours,td.minutes,td.seconds);
							//ob[vd.primaryKey.toString()] = new Date(td.time - 9*60*60*1000);
							ob[vd.primaryKey.toString()] = td;
						}else{
							ob[vd.primaryKey.toString()] = d.values[i];
						}
					//}
					
					if(vd.dataFields){
						for(var j:int = 0;j < vd.dataFields.length;  j ++){
							var vdd:VariableDataDescriptor = vd.dataFields[j];
							for(var ind:String in vdd.indexes){
								var df:VariableData = data[ind];
								ob[ind] = df.values[i];
							}

						}
					}
					
					
					//var vecs:Array = vd.getVectorFields();
					if(vd.vectors){
						for(var v:int = 0;v < vd.vectors.length; v ++){
							//trace('VECTOR INT ' + v);
							var vvd:VariableVectorDescriptor = vd.vectors[v];
							var mag:VariableData = data[vvd.magnitude];
							var az:VariableData = data[vvd.azimuth];
							ob[vvd.magnitude.toString()] = mag.values[i];
							ob[vvd.azimuth.toString()] = az.values[i];
						}
					}
					
					_src.push(ob);
					
				}
				
				_src.sort(function($a:Object,$b:Object):int{
					//trace('comparing ' + $a[d.metadata.dataType].toString() + ' ==> ' + $b[d.metadata.dataType].toString());
					//if($a[d.metadata.dataType] > $b[d.metadata.dataType]){
					if($a[vd.primaryKey.toString()] < $b[vd.primaryKey.toString()]){
						return -1;
					}else if($a[vd.primaryKey.toString()] > $b[vd.primaryKey.toString()]){
						return 1;
					}
					
					return 0;
				});
				
				_collection = new ArrayCollection(_src);
			}
			
			return _collection;
		}
		
		private var _keyed_collection:ArrayCollection;
		public function set keyed_collection($keyed_collection:ArrayCollection):void{
			_keyed_collection = $keyed_collection;
		}
		
		public function get keyed_collection():ArrayCollection{
			if(!_keyed_collection){
				var _src:Array = [];
				var vd:VariableDescriptor = descriptors[0];
				var d:VariableData = data[vd.primaryKey]
				
				
				//var dic:Object = {};	
				
				for(var i:int = 0;i < d.values.length;i ++){
					
					var ob:Object = {};
					
					if(vd.dataFields){
						for(var j:int = 0;j < vd.dataFields.length;  j ++){
							var vdd:VariableDataDescriptor = vd.dataFields[j];
							for(var ind:String in vdd.indexes){
								
								var df:VariableData = data[ind];
								ob[df.metadata.label + '(' + df.metadata.unit + ')'] = df.values[i];
							}
						}
					}
					
					if(vd.vectors){
						for(var v:int = 0;v < vd.vectors.length; v ++){
							//trace('VECTOR INT ' + v);
							var vvd:VariableVectorDescriptor = vd.vectors[v];
							var mag:VariableData = data[vvd.magnitude];
							var az:VariableData = data[vvd.azimuth];
							ob[mag.metadata.label + '(' + mag.metadata.unit + ')'] = mag.values[i];
							ob[az.metadata.label + '(' + az.metadata.unit + ')'] = az.values[i];
						}
					}
					
					//if(d.values[i] != null){
						if(d.metadata.dataType == VariableType.DATE && d.values[i] is Date){
							
							var td:Date = d.values[i];
							var nd:Date = new Date(td.fullYear,td.month,td.date,td.hours,td.minutes,td.seconds);
							ob[d.metadata.label] = nd;
							
						}else{
							ob[d.metadata.label] = d.values[i];
						}
						
						
						_src.push(ob);
					//}
					
				}
				
				_src.sort(function($a:Object,$b:Object):int{
					if($a[d.metadata.label] > $b[d.metadata.label]){
						return 1;
					}else if($b[d.metadata.label] > $a[d.metadata.label]){
						return -1;
					}
					
					return 0;
				});
				
				_keyed_collection = new ArrayCollection(_src);
			}
			
			return _keyed_collection;
		}
		
		public function getMaxValue():Number{
			var val:Number;
			for each(var descriptor:VariableDescriptor in descriptors){
				for each(var df:VariableDataDescriptor in descriptor.dataFields){
					for each(var v:Number in data[df.value].values){
						if(!val || v > val){
							val = v;
						}
					}
				}
				for each(var vf:VariableVectorDescriptor in descriptor.vectors){
					for each(var m:Number in data[vf.magnitude].values){
						if(!val || m > val){
							val = m;
						}
					}
				}
			}
			trace('max val is ' + val);
			return val;
		}
		
		
	}
	

}