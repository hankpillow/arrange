/**
 * @author igor almeida.
 * @version 1.3
 * */
package redneck.grid
{
	public class GridIterator
	{

		private var grid : Grid;
		private var index : int = 0;

		public function GridIterator( p_grid : Grid ):void{
			grid = p_grid;
		}
		/**
		* @return Pointer
		**/
		public function get pointer():Pointer
		{
			return grid.indexToPointer( index );
		}
		/**
		* Return the grid content's by <code>pointer</code>
		* 
		* @see Grid.get
		* @return *
		* */
		public function get content():*
		{
			return grid.get( index );
		}
		/**
		* Reset index to 0
		* 
		* @see first.
		* @return int
		* */
		public function reset():int
		{
			index = 0;
			return index;
		}
		/**
		* Goes to the first index
		* 
		* @return int
		**/
		public function first():int{
			index = 0;
			return index;
		}
		/**
		* Goes to the last index
		* 
		* @return int
		**/
		public function last():int{
			index = grid.size-1;
			return index;
		}
		/**
		* Goes to the next index.
		* If the next index doesnt exist, it will stay where it is.
		* 
		* @param	loop	Boolean
		* @return *
		* */
		public function next( loop:Boolean = false):int
		{
			if( loop ){
				var p : Pointer = pointer.clone();
				p.c = p.c==grid.width-1 ? 0 : p.c+1;
				index = grid.pointerToIndex(p);
				return index;
			}
			else if( hasNext() ){
				return ++index
			}
			return index;
		}
		/**
		* Goes to the previews index.
		* If the next index doesnt exist, it will stay where it is.
		* 
		* @param	loop	Boolean
		* @return *
		* */
		public function prev( loop:Boolean = false ):*
		{
			if( loop ){
				var p : Pointer = pointer.clone();
				p.c = p.c==0 ? grid.width-1 : p.c-1;
				index = grid.pointerToIndex(p);
				return index;
			}
			else if( hasPrev() ){
				return --index;
			}
			return index;
		}
		/**
		* Goes in the same column, um row down.
		* 
		* @param	loop	Boolean
		* @return int
		* */
		public function up( loop:Boolean = false ) : int
		{
			var p : Pointer = pointer;
			if (p){
				if (p.r==0 && index>0){
					p.c--;
					p.r = grid.height-1;
				}
				else{
					p.r--;
				}
				const value : int = grid.pointerToIndex(p);
				if (grid.hasIndex(value)){
					index = value;
				}
			}
			return index;
		}
		/**
		* Moves the pointer one row down.
		* 
		* @param	loop	Boolean
		* @return *
		* */
		public function down( loop:Boolean = false ):int
		{
			var p : Pointer = pointer;
			if (p){
				if (p.r>=grid.height-1 && index<grid.size-1){
					p.c++;
					p.r = 0;
				}
				else{
					p.r++;
				}
				const value : int = grid.pointerToIndex(p);
				if (grid.hasIndex(value)){
					index = value;
				}
			}
			return index;
		}
		/**
		* Check if increasing 1 in the current index will result a valid index.
		* 
		* @param	p_pointer	Pointer
		* @return Boolean
		* */
		public function hasNext( p_pointer: Pointer = null ) : Boolean
		{
			return grid.hasIndex( p_pointer? grid.pointerToIndex(p_pointer)+1 : (index+1) );
		}
		/**
		* Check if decreasing 1 in the current index will result a valid index.
		* 
		* @param	p_pointer	Pointer
		* @return Boolean
		* */
		public function hasPrev( p_pointer: Pointer = null ):Boolean
		{
			return grid.hasIndex( p_pointer? grid.pointerToIndex(p_pointer)-1 : (index-1) );
		}
		/**
		* Check if decreasing <code>grid.width</code> will result a valid index
		* 
		* @param	p_pointer	Pointer
		* @return Boolean
		* */
		public function hasUp( p_pointer: Pointer = null ) : Boolean
		{
			var check_pointer : Pointer = p_pointer;
			if (check_pointer==null){
				check_pointer = pointer.clone();
				check_pointer.r--;
			}
			return grid.hasIndex( grid.pointerToIndex(check_pointer) );
		}
		/**
		* Check if increasing <code>grid.width</code> will result a valid index
		* 
		* @param	p_pointer	Pointer
		* @return Boolean
		* */
		public function hasDown( p_pointer: Pointer = null ) : Boolean
		{
			var check_pointer : Pointer = p_pointer;
			if (check_pointer==null){
				check_pointer = pointer.clone();
				check_pointer.r++;
			}
			return grid.hasIndex( grid.pointerToIndex(check_pointer) );
			
		}
	}
}