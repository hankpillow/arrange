/**
 * @author igor almeida
 * @version 2.0
 * */
package redneck.grid
{
	public class Grid
	{
		//@private
		private var matrix : Array;
		private var _iterator : GridIterator;
		private var _height: int;
		private var _width : int;
		private var pointer : Pointer;
		/**
		* @param	p_columns	int
		* @param	p_lines		in 
		* */
		public function Grid( p_columns:uint = 1, p_lines:uint = 1 ) : void
		{
			width = p_columns;
			height = p_lines;

			_iterator = new GridIterator ( this );

			clean();
		}
		//getters
		public function get width():int{return  _width; }
		public function set width(value:int):void{_width = Math.max(value,1); }
		public function get height():int{return  _height; }
		public function set height(value:int):void{_height = Math.max(value,1); }
		public function get size():int {return _width*_height; }
		public function get iterator():GridIterator { return _iterator; }
		/**
		* cleanup grid and reset iterator
		* @return Grid
		**/
		public function clean():Grid
		{
			pointer = new Pointer;
			matrix = new Array( size-1 );
			iterator.reset();
			return this;
		}
		/**
		* @param p_index
		* 
		* @return Pointer
		**/
		public function indexToPointer(p_index:int):Pointer
		{
			if (hasIndex(p_index)){
				pointer.r = int(p_index/width);
				pointer.c = p_index-width*pointer.r;
				return pointer;
			}
			return null;
		}
		/**
		* @param p_pointer	Pointer
		* @return int
		**/
		public function pointerToIndex( p_pointer:Pointer ):int
		{
			return p_pointer.c+width*p_pointer.r;
		}
		/**
		* @return Boolean
		**/
		public function hasIndex( p_index:int ):Boolean
		{
			return p_index>=0 && p_index<size;
		}
		/**
		* @return Boolean
		**/
		public function hasPointer(p_pointer:Pointer):Boolean
		{
			return hasIndex( pointerToIndex(p_pointer) );
		}
		/**
		* Adds <code>value</code> into <code>index</code>
		* 
		* @see hasIndex
		* 
		* @see fill
		* 
		* @return Boolean
		**/
		public function add( index : int, value : *) : Boolean
		{
			if ( hasIndex(index) ){
				matrix[ index ] = value;
				return true;
			}
			return false;
		}
		/**
		* Return the grid's value for a given index
		* 
		* @see valueFromPointer
		* @see pointerToIndex
		* 
		* @return *
		**/
		public function get( index:int ) : *
		{
			if (hasIndex(index)){
				return matrix[ index ];
			}
			return null;
		}
		/**
		* return the grid's value for a given pointer
		* 
		* @see get
		* 
		* @return *
		**/
		public function valueFromPointer(pointer:Pointer):*
		{
			return get(pointerToIndex(pointer));
		}
		/**
		* Adds <code>value</code> into all grid's position.
		* 
		* @see add
		* 
		* @param value	* everything you want to put in.
		* 
		* @return Grid
		**/
		public function fill( value:* = null) : Grid
		{
			var counter : int = 0;
			while ( counter<size){
				add( counter, value || counter );
				counter++;
			}
			return this;
		}
		/**
		* Return an array representing row <code>p_row</code>
		* 
		* @param p_row
		* 
		* @return Array
		**/
		public function getRow( p_row:int ) : Array
		{
			var result : Array = new Array;
			var index : int = width*p_row;
			const end : int = index+width;
			while (index<end)
			{
				if (hasIndex(index)){
					result.push(get(index));
				}
				index++;
			}
			return result;
		}
		/**
		* Return an array representing column <code>p_column</code>
		* 
		* @param p_column
		* 
		* @return Array
		**/
		public function getColumn( p_column:uint ):Array
		{
			var result : Array = new Array;
			var counter : int;
			var index : int;
			while ( counter<size)
			{
				index = int(counter%width);
				if (index==p_column && hasIndex(counter)){
					result.push(get(counter));
				}
				counter++;
			}
			return result;
		}
		/**
		* simple way to see how your grid is.
		* 
		* @return Grid
		**/
		public function dump():Grid
		{
			trace("Grid("+width+","+height+"):");
			var counter : int = 0;
			var row : String = "";
			while ( counter<size){
				row += get(counter)+",";
				counter++;
				if (counter%width==0){
					trace(row);
					row = "";
				}
			}
			return this;
		}
	}
}