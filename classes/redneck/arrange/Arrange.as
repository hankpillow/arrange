/**
 * 
 *	Arrange is life!
 *
 *	@usage
 *	var arrange: Arrange = new Arrange( [buttonA, buttonB, buttonX] ).toRight().byBottom().round( );
 *
 *	@author igor almeida
 *	@co-author rafael rinaldi
 *
 *	@version 2.2
 *
 *	@since 2008.04.11 saving developer's time.
 *
 *	2.1 change log:
	- ArrangeProperties.step removed (its not necessary once Arrange has simulatin method)
	- byDepth performance improved

 *	2.2 change log:
	- normalizeProperties created avoiding code repetition;
	- fromGrid
 *
 */
package redneck.arrange
{
	import redneck.grid.*;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Arrange
	{
		private var simulating : Boolean;
		private var properties : ArrangeProperties;
		/**
		*	when using grid methods the created grid goes to this var. 
		*	on this var
		* 
		* @see vGrid
		* @see hGrid
		**/
		public var grid : Grid;
		/**
		*	Added items lays on this list.
		* 
		* 	@see simulate
		*	@see add
		**/
		internal var arrangeList : Vector.<DisplayWrapper>;
		public function get list():Vector.<DisplayWrapper>
		{
			return arrangeList;
		}
		/**
		*	@see add
		*	@see remove
		* 
		*	@param to_arrange	Array, Vector
		**/
		public function Arrange( to_arrange : * = null ) : void
		{
			properties = new ArrangeProperties;
			arrangeList = new Vector.<DisplayWrapper>( );
			if (to_arrange){
				var c:int = 0;
				while( c<to_arrange.length ){
					add( to_arrange[ c ]);
					c++;
				}
			}
		}
		/**
		* Add a new item into the end of the current list
		* 
		* @see chain
		* 
		* @param item	* 
		* 
		* @return Arrange
		**/
		public function add( item:* ):Arrange
		{
			if (item is DisplayWrapper){
				arrangeList.push( value );
			}
			else if ( item!=null && (item is Point || ( item.hasOwnProperty("x") && item.hasOwnProperty("y") && item.hasOwnProperty("width") && item.hasOwnProperty("height") ) ) ){
				var value : DisplayWrapper = new DisplayWrapper(item);
					value.simulate = this.simulating;
				arrangeList.push( value );
			}
			return this;
		}
		/**
		*	Simulate means: Arrange will perform every method you'll 
		*	call into <code>arrangeList</code> but will **not** change
		*	any position for your real objects.
		* 
		* 	To get the result for this simulation you must check the 
		* 	<code>list</code> content and use only the 
		*	<code>targetX</code> and <code>targetY</code> values.
		* 
		* 	The idea of simulating an Arrage is that you'll be able to change
		* 	the position when you want and perform any tween engine you prefer.
		* 	
		* 	@usage
		* 	place(list).simulate().toRight().byTop().list.forEach( function(o:Object,...rest):void{
		* 		Tweener.addTween(o.target,{x:o.point.x,y:o.point.y})
		*	} );
		* 
		* 	@param value	Boolean true starts smulating and false stop.
		* 
		*	@return Arrange
		**/
		public function simulate( value:Boolean=true ):Arrange
		{
			simulating = value;
			arrangeList.forEach( function(obj : DisplayWrapper, ...rest):void{
				obj.simulate = simulating;
			} );
			return this;
		}
		/**
		* removes specific item
		* 
		* @param item	*
		* 
		* @return Arrange
		**/
		public function remove( item:* ):Arrange
		{
			if (item!=null)
			{
				var index: int = -1;
				arrangeList.some( function(display:DisplayWrapper,i:int):Boolean
				{
					if (display.target==item){
						index = i;
						return true;
					}
					return false;
				});

				if (index!=-1)
				{
					arrangeList.splice(index,1);
				}
			}
			return this;
		}
		/**
		* @return ArrangeProperties
		**/
		protected function normalizeProperties(prop:*):ArrangeProperties{
			return (prop == null) ? properties : (prop is ArrangeProperties) ? prop : ArrangeProperties.fromObject( prop );
		}
		/**
		*	Put the itens on left side of the next
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES
		* 
		*	@param	prop		Object
		* 	
		* 	@return Arrange
		**/
		public function toLeft( prop : Object = null) : Arrange {
			return placeTo( "x", -1, normalizeProperties(prop));
		}
		/**
		*	Put the itens on right side of the next
		* 
		* 	@see ArrangeProperties.ALLOWED_PROPERTIES
		* 
		*	@param	prop		Object
		*
		*	@return Arrange
		**/
		public function toRight( prop : Object = null) : Arrange {
			return placeTo( "x", 1, normalizeProperties(prop));
		}
		/**
		*	Put the itens on above position of the next.
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES 
		* 
		*	@param	prop		Object
		*	
		*	@return Arrange
		**/
		public function toTop( prop : Object = null) : Arrange {
			return placeTo( "y", -1, normalizeProperties(prop) );
		}
		/**
		*	Put the itens on under position of the next.
		* 
		* 	@see ArrangeProperties.ALLOWED_PROPERTIES 
		* 
		*	@param	prop		Object	
		* 
		*	@return Arrange
		**/
		public function toBottom( prop:Object = null ) : Arrange {
			return placeTo( "y", 1, normalizeProperties(prop) );
		}
		/**
		 * @private
		 **/
		protected function placeTo( prop:String, operator:int, xtras : Object ) : Arrange
		{
			if ( arrangeList.length<=1 ){
				return this;
			}

			var c:int;
			var s:Number;
			var reffSize : Number;
			var reffPos : Number;
			var objSize : Number;
			var objPos : Number;

			const size:String = (prop == "x") ? "width" : "height";
			const padding : Number = (prop == "x") ? xtras.padding_x : xtras.padding_y;

			while ( c < arrangeList.length )
			{
				if (c > 0 && arrangeList[ c ] != null && arrangeList[ c-1 ] != null)
				{
					reffSize	= arrangeList[ c - 1 ][ size ];
					reffPos		= arrangeList[ c - 1 ][ prop ];
					objSize		= arrangeList[ c ][ size ];
					objPos		= arrangeList[ c  ][ prop ];
					s			= isNaN(xtras[size]) ? ( operator < 0 ) ? objSize : reffSize : xtras[size];
					arrangeList[ c ][ prop ] = arrangeList[ c ][ prop ] + ( ( reffPos - objPos ) * operator + s + padding ) * operator;
				}
				c++;
			}
			return this;
		}
		/**
		*	Align all itens by the top position of the first item
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES 
		* 
		*	@param	prop		Object
		* 
		*	@return Arrange
		**/
		public function byTop( prop:Object = null ) : Arrange {
			return placeBy( "y", 1, normalizeProperties(prop));
		}
		/**
		*	Align all itens by the bottom position of the first item.
		* 
		* 	@see ArrangeProperties.ALLOWED_PROPERTIES
		* 
		*	@param	prop		Object
		*
		*	@return Arrange
		**/
		public function byBottom( prop:Object = null ) : Arrange {
			return placeBy( "y", -1, normalizeProperties(prop) );
		}
		/**
		*	Align all itens by the left side of the first item.
		* 	
		*	@see ArrangeProperties.ALLOWED_PROPERTIES
		* 
		*	@param	prop		Object	
		* 
		* 	@return Arrange
		**/
		public function byLeft( prop:Object = null ) : Arrange {
			return placeBy( "x", 1, normalizeProperties(prop));
		}
		/**
		*	Align all itens by the right side of the first item.
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES 
		* 
		*	@param	prop		Object	
		*	
		*	@return Arrange
		**/
		public function byRight( prop:Object = null ) : Arrange {
			return placeBy( "x", -1, normalizeProperties(prop));
		}
		/**
		 * @private
		 **/
		protected function placeBy( prop:String, operator:int = 0, xtras:Object = null ) : Arrange
		{
			if ( arrangeList.length<=1 || arrangeList[0]==null ){
				return this;
			}

			var c:int = 0;
			var s : Number;
			var objSize : Number;
			var objPos : Number;

			const size:String = (prop == "x") ? "width" : "height";
			const padding : Number = (prop == "x") ? xtras.padding_x : xtras.padding_y;
			const reffSize : Number = arrangeList[ 0 ][ size ];
			const reffPos : Number = arrangeList[ 0 ][ prop ];

			while ( c<arrangeList.length )
			{
				if( c>0 && arrangeList[ c ] != null )
				{
					objSize	= arrangeList[ c ][ size ];
					objPos	= arrangeList[ c ][ prop ];
					s 		= isNaN(xtras[size]) ? reffSize : xtras[size];
					arrangeList[ c ][ prop ] = arrangeList[ c ][ prop ] + ( ( reffPos - objPos + ( operator==1 ? 0 : s - objSize ) ) ) + ( padding * operator );
				}
				c++;
			}
			return this;
		}
		/**
		*	Align all itens by the center width of the first item.
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES 
		* 
		*	@param	prop		Object	
		* 
		*	@return Arrange
		**/
		public function center( prop:Object = null ) : Arrange
		{
			return centerY( prop ).centerX( prop );
		}
		/**
		*	Align all itens by the center height of the first.
		* 
		* 	@see ArrangeProperties.ALLOWED_PROPERTIES
		* 
		*	@param	prop		Object	
		*
		*	@return Arrange
		**/
		public function centerY( prop:Object = null ) : Arrange {
			return placeCenter( "y", normalizeProperties(prop));
		}
		/**
		*	Align all itens by the center X of the first item.
		* 
		*	@see	ArrangeProperties.ALLOWED_PROPERTIES 
		*
		*	@param	prop		Object	
		*
		*	@return Arrange
		**/
		public function centerX( prop:Object = null ) : Arrange {
			return placeCenter( "x", normalizeProperties(prop));
		}
		/**
		* @private
		**/
		protected function placeCenter( prop:String, xtras:Object ) : Arrange
		{
			if ( arrangeList[ 0 ]==null && arrangeList.length<=1 ){
				return this;
			}

			var c:int = 0;
			var s : Number;
			var objSize : Number;
			var objPos : Number;

			const size:String = (prop == "x") ? "width" : "height";
			const reffSize : Number = arrangeList[ 0 ][ size ];
			const reffPos : Number = arrangeList[ 0 ][ prop ];
			const reff : Number = (isNaN(xtras[size]) ? reffSize : xtras[size]) * .5;
			const padding : Number = (prop == "x") ? xtras.padding_x : xtras.padding_y;

			while ( c<arrangeList.length )
			{
				if( c>0 && arrangeList[ c ] != null )
				{
					objSize = arrangeList[ c ][ size ];
					objPos = arrangeList[ c ][ prop ];
					s = isNaN(xtras[size]) ? objSize : xtras[size];
					arrangeList[ c ][ prop ] = arrangeList[ c ][ prop ] - ( ( objPos - reffPos ) + ( s * 0.5 - reff ) + padding );
				}
				c++;
			}
			return this;
		}
		/**
		* 	The main difference between <code>fromGrid</code> and <code>vGrid</code> or <code>hGrid</code> is that 
		* 	using <code>fromGrid</code> the Arrange will not perform any Math to figure out how is your grid or even create one.
		* 	It will assume that your grid is correct and stuffed with Displayobjects.
		* 
		* 	Calling this method you save a bit of performance and you can even manipulate your <code>Grid</code> as you prefer and
		*	just update object's position.
		* 
		* 	@see vGrid
		* 	@see hGrid
		* 
		*	@param value	Grid	A grid filled with Displayobject you want to arrange in it.
		*	@param prop	Object
		* 
		*	@return Arrange
		**/
		public function fromGrid( value:Grid, prop:*=null ) : Arrange
		{
			prop = normalizeProperties(prop);
			if ( grid == null || grid != value || grid.size!=value.size ){
				grid = value;
				arrangeList = new Vector.<DisplayWrapper>( );
				grid.iterator.forEach(function(item:*,...rest):void{
					add(item);
				});
			}

			const lazyProp : ArrangeProperties = properties.clone();
				lazyProp.width = prop.width;
				lazyProp.height = prop.height;

			// arranging first column
			new Arrange(grid.getColumn(0)).byLeft(lazyProp).toBottom(prop);
			
			// getting rows
			const size:uint = grid.height;
			var count:uint = 0;
			while ( count < size ){
				// getting rows and aligning it
				new Arrange(grid.getRow(count)).byTop(lazyProp).toRight(prop);
				count++;
			}
			return this;
		}
		
		/**
		*	Create a vertical grid and arrange items.
		*	You just have to say the number of <code>columns</code> 
		*	and the number of rows will be calculated using the size of the current <code>arrangeList</code>
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES 
		*	@see Grid
		*
		*	@param	columns		int		column number
		*	@param	prop		Object
		* 
		*	@return Arrange
		**/
		public function vGrid( columns:uint, prop:Object = null ) : Arrange
		{
			grid = new Grid ( columns, Math.ceil(arrangeList.length/columns) );
			grid.iterator.forEach( function(item:*,i:uint,...rest):void{
				grid.add( arrangeList[ i ].target, i );
			} );
			return fromGrid( grid, prop );
		}
		/**
		*	Create a horizinotal grid and arrange items. 
		* 	You just have to say the number of <code>rows</code> 
		*	and the number of columns will be calculated using the size the current <code>arrangeList</code>
		* 
		* 	@see ArrangeProperties.ALLOWED_PROPERTIES 
		*	@see Grid
		* 
		*	@param	rows		int		column number
		*	@param	prop		Object
		* 
		*	@return Arrange
		**/
		public function hGrid( rows:uint, prop:Object = null ) : Arrange 
		{
			grid = new Grid ( Math.ceil(arrangeList.length/rows), rows );

			var column			: int = grid.width;
			var row				: int = grid.height;
			var row_count		: uint;
			var column_count	: uint;
			var index			: uint;
			var count			: uint;

			while(column_count<column)
			{
				while( row_count<row )
				{
					if (count<arrangeList.length)
					{
						grid.add( arrangeList[count].target, grid.pointerToIndex(new Pointer( column_count, row_count )));
						count++;
					}
					row_count++;
				}
				row_count = 0;
				column_count++
			}
			return fromGrid( grid, prop );
		}
		/**
		*	Change the depths in the same order of the array.
		*	This action only works with DisplayObjectContainer
		*
		*	@param reverse_list	Boolean will reverse the current <code>arrangeList</code> **only** for changing depths
		* 
		*	@return Arrange
		**/
		public function byDepth( reverse_list:Boolean=false ):Arrange
		{
			var count : int = arrangeList.length
			var index : uint
			while(count--)
			{
				index =  reverse_list ? count : (arrangeList.length-1)-count;
				if (arrangeList[index].target !=null && arrangeList[index].hasParent ){
					arrangeList[index].target.parent.addChild(arrangeList[index].target);
				}	
			}
			return this;
		}
		/**
		*	Return the bounds of all items together.
		* 
		*	@return Rectangle
		*/
		public function get bounds( ) : Rectangle
		{
			var bounds : Rectangle = new Rectangle;
			if (arrangeList && arrangeList.length>0)
			{
				bounds = new Rectangle( arrangeList[ 0 ].x, arrangeList[ 0 ].y, arrangeList[ 0 ].width, arrangeList[ 0 ].height );
				var count: int = 1;
				while(count<arrangeList.length){
					if ( arrangeList[ count ] == null ){continue;}
					bounds = bounds.union( new Rectangle( arrangeList[ count ].x, arrangeList[ count ].y, arrangeList[ count ].width, arrangeList[ count ].height ) );
					count++;
				}
			}
			return bounds;
		}
		/**
		*	Rounds the 'x' and 'y' position.
		*	Great stuff for "ghost pixels" in textfields.
		* 
		* 	@return Arrange
		**/
		public function round(...rest) : Arrange
		{
			const count : int = arrangeList.length;

			while (count--) {
				if (arrangeList[count]) {
					arrangeList[ count ].x = arrangeList[ count ].x ^ 0;
					arrangeList[ count ].y = arrangeList[ count ].y ^ 0;
				}
			}

			return this;
		}
		/**
		* Join the given <code>list</code> with the last item of the current <code>list</code> and return a new Arrange;
		* 
		* @see list
		* @see add
		* 
		* @usage
		* place( [a,b] ).toRight({x:5}).chain([c,d]).toRight()
		* 
		* This is the same as:
		* 
		* place( [a,b] ).toRight({x:5})
		* place( [b,c,d] ).toRight()
		* 
		* @return Arrange
		**/
		public function chain(list:*):Arrange
		{
			if ( arrangeList!=null && arrangeList.length>0 && list!=null ){
				//concat the very list with the given list
				return new Arrange( [arrangeList[arrangeList.length-1].target].concat(list) );
			}
			else if (list!=null){
				//if empty, no worry, just return a new arrange
				return new Arrange(list);
			}
			//even if everything goes wrong you'll get your dreamed arrangeList
			return new Arrange();
		}
	}
}