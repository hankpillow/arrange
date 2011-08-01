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
		* 
		* @return *
		* */
		public function get content():*
		{
			return grid.get( index );
		}
		/**
		* Reset pointer
		* 
		* @return GridIterator
		* */
		public function reset():GridIterator
		{
			index = 0;
			return this;
		}
		/**
		* 
		* @param	loop	Boolean
		* 
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
			return index++;
		}
		/**
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
			return index--;
		}
		/**
		* @param	loop	Boolean
		* @return *
		* */
		public function up( loop:Boolean = false ) : *
		{
			var result:int = index;
			var p : Pointer = pointer;
			if (p){
				if (p.r==0 && index>0){
					p.c--;
					p.r = grid.height-1;
				}else{
					p.r--;
				}
				index = grid.pointerToIndex(p);
			}
			return result;
		}
		/**
		* @param	loop	Boolean
		* @return *
		* */
		public function down( loop:Boolean = false ):*
		{
			var result:int = index;
			var p : Pointer = pointer;
			if (p){
				if (p.r>=grid.height-1 && index<grid.size-1){
					p.c++;
					p.r = 0;
				}else{
					p.r++;
				}
				index = grid.pointerToIndex(p);
			}
			return result;
		}
		/**
		* @private
		* hasNext, hasPrev etc. doesn't matter which name you give, reading about iterator pattern
		* i just realize that hasNext doesn't check if the current index + 1 is valid, it just check
		* if the current index exists because every action to increase/decrease happens when next(), prev() etc are called.
		* 
		* @return Boolean
		**/
		private function has(p_pointer:Pointer = null):Boolean{
			return grid.hasIndex( p_pointer? grid.pointerToIndex(p_pointer) : index );
		}
		/**
		 * @param	p_pointer	Pointer
		 * 
		 * @return Boolean
		 * */
		public function hasNext( p_pointer: Pointer = null ) : Boolean
		{
			return has(p_pointer);
		}
		/**
		* @param	p_pointer	Pointer
		* 
		* @return Boolean
		* */
		public function hasPrev( p_pointer: Pointer = null ):Boolean
		{
			return has(p_pointer);
		}
		/**
		* @param	p_pointer	Pointer
		* 
		* @return Boolean
		* */
		public function hasUp( p_pointer: Pointer = null ) : Boolean
		{
			return has(p_pointer);
		}
		/**
		* @param	p_pointer	Pointer
		* 
		* @return Boolean
		* */
		public function hasDown( p_pointer: Pointer = null ) : Boolean
		{
			return has(p_pointer);
		}
		/**
		* goes to the first position
		* 
		* @return int
		**/
		public function first():int{
			index = 0;
			return index;
		}
		/**
		* goes to the last position
		* 
		* @return int
		**/
		public function last():int{
			index = grid.size-1;
			return index;
		}
	}
}