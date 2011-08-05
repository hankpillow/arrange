package
{	
	import flash.display.Sprite
	import redneck.grid.*
	public class GridTest extends Sprite
	{
		public function GridTest()
		{
			super();
			
			trace("////");
			const grid : Grid = new Grid(5,5);
				grid.fill();
				grid.dump();
				
			//trace("---------------------------");
			//trace("last index:"+grid.iterator.last());
			//trace("has next?"+grid.iterator.hasNext())
			//trace("has prev?"+grid.iterator.hasPrev())
			//trace("reseting iterator:"+grid.iterator.reset());
			//trace("has prev?"+grid.iterator.hasPrev());

			//trace("reseting iterator. and running through all cells")
			//grid.iterator.reset();
			//var count : int = 0
			//while( count< grid.size )
			//{
			//	count++;
			//	trace("pointer:"+grid.iterator.pointer+" index:"+ grid.pointerToIndex(grid.iterator.pointer) +" content:"+grid.iterator.content);
			//	grid.iterator.next();
			//}
		}
	}
}