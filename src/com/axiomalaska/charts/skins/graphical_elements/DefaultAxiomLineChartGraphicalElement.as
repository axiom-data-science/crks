package com.axiomalaska.charts.skins.graphical_elements
{
	import com.axiomalaska.charts.base.AxiomChartPlottableItem;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.geom.Point;

	public class DefaultAxiomLineChartGraphicalElement extends AxiomChartGraphicalElement
	{
		

		[Bindable]
		public var displayPoint:Boolean = false;
		
		[Bindable]
		public var displayFill:Boolean = false;
		

		override protected function draw(g:Graphics):void{
			
			//trace('DRAWING LINE');
			
			//VARS FOR CURVES!
			/*
			 * http://www.cartogrammar.com/blog/actionscript-curves-update/
			 * http://cartogrammar.com/source/CubicBezier.as 
			*/
			
			/*		z:Number			-A factor (between 0 and 1) to reduce the size of curves by limiting the distance of control points from anchor points.
			*							 For example, z=.5 limits control points to half the distance of the closer adjacent anchor point.
			*							 I put the option here, but I recommend sticking with .5
			
			*		angleFactor:Number	-Adjusts the size of curves depending on how acute the angle between points is. Curves are reduced as acuteness
			*							 increases, and this factor controls by how much.
			*							 1 = curves are reduced in direct proportion to acuteness
			*							 0 = curves are not reduced at all based on acuteness
			*							 in between = the reduction is basically a percentage of the full reduction
			*/
			var z:Number = .5;
			var angleFactor:Number = .75
			
			var cntr:int = 0;
			
			var gx:Number = drawX;
			var gy:Number = drawY;
			
			_commands = new Vector.<int>;
			_data = new Vector.<Number>;
			_di = 0;
			_ci = 0;

			
			if(segments && segments.length > 0){
				
				
				if(segments[0].point){
					_commands[_ci++] = GraphicsPathCommand.MOVE_TO;
					_data[_di++] = gx + segments[0].point.x;
					_data[_di++] = gy + segments[0].point.y;
				}
				
				var len:int = segments.length;
				var lastWasEmpty:Boolean = false;
				var nextIsEmpty:Boolean = false;
				

				if((width /segments.length ) < 5){
					displayPoint = false;
				}
				
				for(var i:int = 0;i < len; i++){
					var segment:AxiomChartPlottableItem = segments[i];
					
					if(segment.point){
						if((i + 1 < len && !segments[i + 1].point) ||
							//i == 0 ||
							i == len
						){
							nextIsEmpty = true;
						}
						
						if(lastWasEmpty || nextIsEmpty || displayPoint){
							//g.beginFill(0x000000);
							g.drawCircle(gx + segment.point.x,gy + segment.point.y,2);
							//g.endFill();
							lastWasEmpty = false;
							nextIsEmpty = false;
						}
						
						var controlPoint:Point = segment.point;
						if(i > 0 && i < len - 1){
							var p0:Point;
							var p1:Point = segment.point;
							var p2:Point;
							if(segments[i + 1].point){
								p2 = segments[i + 1].point;
							}
							//prev
							if(segments[i - 1].point){
								p0 = segments[i - 1].point;
							}
							
							if(p0 && p2){
								//From prev to current
								var a:Number = Point.distance(p0,p1);
								if(a < .01){
									a = .01;
								}
								
								//From current to next
								var b:Number = Point.distance(p1,p2);
								if(b < .01){
									b = .01;
								}
								
								//From prev to next
								var c:Number = Point.distance(p0,p2);
								if(c < .01){
									c = .01;
								}
								
								var cos:Number =  (b*b+a*a-c*c)/(2*b*a);
								// Make sure above value is between -1 and 1 so that Math.acos will work
								if (cos < -1){
									cos = -1;
								}else if (cos > 1) {
									cos = 1;
								}
								
								var C:Number = Math.acos(cos);	// Angle formed by the two sides of the triangle (described by the three points above) adjacent to the current point
								
								// Duplicate set of points. Start by giving previous and next points values RELATIVE to the current point.
								var aPt:Point = new Point(p0.x-p1.x,p0.y-p1.y);
								var bPt:Point = new Point(p1.x,p1.y);
								var cPt:Point = new Point(p2.x-p1.x,p2.y-p1.y);
								
								/*
								We'll be adding adding the vectors from the previous and next points to the current point,
								but we don't want differing magnitudes (i.e. line segment lengths) to affect the direction
								of the new vector. Therefore we make sure the segments we use, based on the duplicate points
								created above, are of equal length. The angle of the new vector will thus bisect angle C
								(defined above) and the perpendicular to this is nice for the line tangent to the curve.
								The curve control points will be along that tangent line.
								*/
								if (a > b){
									aPt.normalize(b);	// Scale the segment to aPt (bPt to aPt) to the size of b (bPt to cPt) if b is shorter.
								} else if (b > a){
									cPt.normalize(a);	// Scale the segment to cPt (bPt to cPt) to the size of a (aPt to bPt) if a is shorter.
								}
								
								
								
								// Offset aPt and cPt by the current point to get them back to their absolute position.
								aPt.offset(p1.x,p1.y);
								cPt.offset(p1.x,p1.y);
								// Get the sum of the two vectors, which is perpendicular to the line along which our curve control points will lie.
								var ax:Number = bPt.x-aPt.x;	// x component of the segment from previous to current point
								var ay:Number = bPt.y-aPt.y; 
								var bx:Number = bPt.x-cPt.x;	// x component of the segment from next to current point
								var by:Number = bPt.y-cPt.y;
								var rx:Number = ax + bx;	// sum of x components
								var ry:Number = ay + by;
								
								// Correct for three points in a line by finding the angle between just two of them
								if (rx == 0 && ry == 0){
									rx = -bx;	// Really not sure why this seems to have to be negative
									ry = by;
								}
								
								// Switch rx and ry when y or x difference is 0. This seems to prevent the angle from being perpendicular to what it should be.
								if (ay == 0 && by == 0){
									rx = 0;
									ry = 1;
								} else if (ax == 0 && bx == 0){
									rx = 1;
									ry = 0;
								}
								var r:Number = Math.sqrt(rx*rx+ry*ry);	// length of the summed vector - not being used, but there it is anyway
								var theta:Number = Math.atan2(ry,rx);	// angle of the new vector
								
								var controlDist:Number = Math.min(a,b)*z;	// Distance of curve control points from current point: a fraction the length of the shorter adjacent triangle side
								var controlScaleFactor:Number = C/Math.PI;	// Scale the distance based on the acuteness of the angle. Prevents big loops around long, sharp-angled triangles.
								controlDist *= ((1-angleFactor) + angleFactor*controlScaleFactor);	// Mess with this for some fine-tuning
								var controlAngle:Number = theta+Math.PI/2;	// The angle from the current point to control points: the new vector angle plus 90 degrees (tangent to the curve).
								var controlPoint2:Point = Point.polar(controlDist,controlAngle);	// Control point 2, curving to the next point.
								var controlPoint1:Point = Point.polar(controlDist,controlAngle+Math.PI);	// Control point 1, curving from the previous point (180 degrees away from control point 2).
								// Offset control points to put them in the correct absolute position
								controlPoint1.offset(p1.x,p1.y);
								controlPoint2.offset(p1.x,p1.y);
								
								/*
								Haven't quite worked out how this happens, but some control points will be reversed.
								In this case controlPoint2 will be farther from the next point than controlPoint1 is.
								Check for that and switch them if it's true.
								*/
								if (Point.distance(controlPoint2,p2) > Point.distance(controlPoint1,p2)){
									controlPoint = controlPoint2;
								} else {
									controlPoint = controlPoint1;
								}
								
								/*
								g.beginFill(0x333333);
								g.drawCircle(gx + controlPoint1.x,gy + controlPoint1.y,2);
								g.endFill();
								
								g.beginFill(0x666666);
								g.drawCircle(gx + controlPoint2.x,gy + controlPoint2.y,2);
								g.endFill();
								*/
								
								
								
								
								
							}
							
							
							
							
						}
						
						/*
						_data[_di++] = gx + controlPoint.x;
						_data[_di++] = gy + controlPoint.y;
						_data[_di++] = gx + segment.point.x;
						_data[_di++] = gy + segment.point.y;
						_commands[_ci++] = GraphicsPathCommand.CURVE_TO;
						*/
						
						_data[_di++] = gx + segment.point.x;
						_data[_di++] = gy + segment.point.y;
						_commands[_ci++] = GraphicsPathCommand.LINE_TO;
						
						
						
						
						
					}else{
						
						
						var next:AxiomChartPlottableItem;
						var m:int = i + 1;
						if(m >= segments.length){
							m = 0;
						}
						next = segments[m];
						var nct:int = 0;
						while(!next.point && nct < segments.length){
							if(m >= segments.length){
								m = 0;
							}
							next = segments[m];
							m ++;
							nct ++;
						}
						
						
						if(next.point){
							_data[_di++] = gx + next.point.x;
							_data[_di++] = gy + next.point.y;
							_commands[_ci++] = GraphicsPathCommand.MOVE_TO;
							if(i > 0){
								lastWasEmpty = true;
							}
						}
					}
					
					
				}
			}
			
			
			if (_ci != _commands.length)
			{
				_commands.splice(_ci, _commands.length - _ci);
				_data.splice(_di, _data.length - _di);
			}
			
			/*
			if(displayFill){
				_commands.push(GraphicsPathCommand.LINE_TO);
				_data.push(width + stroke.weight*2);
				_data.push(height + 4);
				_commands.push(GraphicsPathCommand.LINE_TO);
				_data.push(0);
				_data.push(height + stroke.weight*2);
			}
			*/
			
			g.endFill();

			g.drawPath(_commands, _data);
			
		}
		
	}
}