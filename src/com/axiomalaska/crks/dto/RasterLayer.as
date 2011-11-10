package com.axiomalaska.crks.dto {
	import com.axiomalaska.crks.service.result.RasterTimeElevationStrataServiceResult;
	
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	// Generated May 11, 2011 2:11:49 AM by Hibernate Tools 3.2.2.GA
	
	[Bindable]
	[RemoteClass(alias="com.axiomalaska.crks.dto.RasterLayerDTO")]
	public class RasterLayer extends RasterLayerGenerated{
		
		public function insertServerData($data:RasterTimeElevationStrataServiceResult):void{
			
			if($data.timeStrata){
				
				rasterTimeStratas = $data.timeStrata;
				
				var startTimeSortField:SortField = new SortField('startTimeUtc.time');
				var timeSort:Sort = new Sort();
				timeSort.fields = [startTimeSortField];
				timeSort.compareFunction = sortStartTime;
				rasterTimeStratas.sort = timeSort;
				rasterTimeStratas.refresh();
				
				if(rasterTimeStratas.length > 0){
					startTimeUtc = (rasterTimeStratas.getItemAt(0) as RasterTimeStrata).startTimeUtc;
					endTimeUtc = (rasterTimeStratas.getItemAt(rasterTimeStratas.length - 1) as RasterTimeStrata).endTimeUtc;
				}
			}
			
			if($data.elevationStrata){
				var elevationSortField:SortField = new SortField('elevationMeters',true,false,true);
				var elevationSort:Sort = new Sort();
				elevationSort.fields = [elevationSortField];
				$data.elevationStrata.sort = elevationSort;
				$data.elevationStrata.refresh();
			}
			
			if($data.elevationStrata){
				rasterElevationStratas = $data.elevationStrata;
			}

			
			
			
		}
		
		
		
		private function sortStartTime($a:RasterTimeStrata,$b:RasterTimeStrata, $fields:Array = null):int{
			
			if($a.startTimeUtc.time == $b.startTimeUtc.time){
				return 0;
			}
			
			if($a.startTimeUtc.time > $b.startTimeUtc.time){
				return 1;
			}else{
				return -1;
			}
		}
		
		public function findStrataNearestToTime($date:Date = null):RasterTimeStrata{
			if(!$date){
				$date = new Date();
			}
			
			var selected:RasterTimeStrata;
			
			if(rasterTimeStratas && rasterTimeStratas.length > 0){
				var first:RasterTimeStrata = rasterTimeStratas.getItemAt(0) as RasterTimeStrata;
				var last:RasterTimeStrata = rasterTimeStratas.getItemAt(rasterTimeStratas.length - 1) as RasterTimeStrata;
				//trace('DATE = ' + $date.toLocaleDateString() + ' FIRST = ' + first.startTimeUtc.toLocaleDateString() + ' LAST = ' + last.startTimeUtc.toLocaleDateString());
			
				if(
					$date.time >= first.startTimeUtc.time && 
					$date.time <= last.startTimeUtc.time
				)
				{
					var solved:Boolean = false;
					var top_index:int = rasterTimeStratas.length - 1;
					var bottom_index:int = 0;
					var diff:int = top_index - bottom_index;
					var index:int = Math.floor((top_index + bottom_index)/ 2);
					//trace('START INDEX = ' + index + ' == ' + (rasterTimeStratas.getItemAt(index) as RasterTimeStrata).startTimeUtc.toLocaleDateString());
					
					for(var ct:int = 0;ct < rasterTimeStratas.length; ct ++){
						
						var test:RasterTimeStrata = rasterTimeStratas.getItemAt(index) as RasterTimeStrata;
						//trace('INDEX (' + index + ') IS AT ' + test.startTimeUtc.toLocaleDateString());
						
						if($date.time > test.startTimeUtc.time){
							bottom_index = index;
							//trace('GREATER');
							//trace('GREATER ( ' + $date.toDateString() + ' ' + $date.time + ' > ' + test.startTimeUtc.toDateString() + ' ' + test.startTimeUtc.time + ' )');
						}else{
							//trace('LESS');
							//trace('GREATER ( ' + $date.toDateString() + ' < ' + test.startTimeUtc.toDateString() + ' )');
							top_index = index;
						}
						
						diff = top_index - bottom_index;
						index = Math.floor((top_index + bottom_index)/ 2);
						
						//trace('TOP = ' + top_index + ' BOTTOM = ' + bottom_index + ' INDEX = ' + index);
						//trace('DIFF = ' + diff);
						//trace('top index = ' + top_index + ' bottom_index = ' + bottom_index + ' index = ' + index);
						
						
						//trace(this.label + ' -- ' + ct + ' (' + index + ') ' + diff);
						
						if(diff < 2){
							//trace('Q?');
							//trace('returning ' + test.startTimeUtc.toLocaleDateString() + ' for ' + $date.toLocaleDateString() + ' after ' + ct);
							selected = test;
							break;
						}
					}
				/*}else if($date.time < first.startTimeUtc.time){
					//trace('returning first' + $date.toDateString() + ' < ' + first.startTimeUtc.toDateString());
					//selected = first;
				*/
				}else{
					trace('selected date ' + $date.toString() + ' outside of timestrata for ' + label);
					
					var days:int = 30;
					var closeEnough:Number = days * 24 * 60 * 60 * 24;
					
					if($date.time < first.startTimeUtc.time && (first.startTimeUtc.time - $date.time) < closeEnough){
						trace('selecting first (' + $date.toString() + ') since it is close enough for ' + label);
						selected = first;
					}else if($date.time > last.endTimeUtc.time && ($date.time - last.endTimeUtc.time) < closeEnough){
						selected = last;
						trace('selecting last (' + $date.toString() + ') since it is close enough for ' + label);
					}else{
						trace('NOT CLOSE NEOUGH! (' + $date.toString() + ') ' + label);
						trace('start = ' + first.startTimeUtc.toString());
						trace('end = ' + last.endTimeUtc.toString());
						trace('NEAREST END IS.. ' + new Date($date.time - closeEnough).toString());
						
					}
					//trace('returning last');
					//selected = last;
				}

			}else{
				
				trace('no time strata for ' + label + ' (' + id + ')');
			}

			return selected;
		}
		
	}
}