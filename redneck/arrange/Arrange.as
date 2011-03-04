/**
 * 
 *	Arrange is life!
 *
 * 	Arrange is just a simple way to change the position of your objects.
 *	@usage
 *	new Arrange( [buttonA, buttonB, buttonX] ).toRight().byBottom().round( );
 *
 *	@author igor almeida
 *	@version 2.0
 *	@since 11.04.2008
 * 
 */
package redneck.arrange
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import redneck.grid.*;
	
	public class Arrange
	{
		private var simulating : Boolean
		private var properties : ArrangeProperties;
		/**
		*	when using grid methods the created grid goes to this var. 
		*	on this var
		* 
		* @see vGrid
		* @see hGrid
		**/
		public var grid : Grid
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
			properties = new ArrangeProperties
			arrangeList = new Vector.<DisplayWrapper>( );
			if (to_arrange){
				createWrapperList(to_arrange);
			}
		}
		 /**
		 *	@param	a	Array, Vector
		 * 
		 *	@return Arrange
		 **/
		internal function createWrapperList( p_list:* ) : void
		{
			var c:int = 0;
			while( c<p_list.length ){
				add(p_list[ c ])
				c++;
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
			if (item && (item is Point || ( item.hasOwnProperty("x") && item.hasOwnProperty("y") && item.hasOwnProperty("width") && item.hasOwnProperty("height") ) ) ){
				var value : DisplayWrapper = new DisplayWrapper(item);
					value.simulate = this.simulating
				arrangeList.push( value );
			}
			return this
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
				obj.simulate = simulating
			} )
			return this
		}
		/**
		* removes specific item
		* 
		* @param item	*
		* 
		* @return Arrange
		**/
		public function remove( item:* ):Arrange{
			if (item){
				var index: int = -1
				arrangeList.forEach( function(w:Object,i:int,arr:*):void{
					if (w.item==item){
						index = i
					}
				});
				if (index!=-1){
					arrangeList.splice(index,1);
				}
			}
			return this;
		}
		/**
		*	Put the itens on left side of the next
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES
		* 
		*	@param	props		Object
		* 	
		* 	@return Arrange
		**/
		public function toLeft( prop : Object = null) : Arrange
		{
			prop = prop == null ? properties : (prop is ArrangeProperties) ? prop as ArrangeProperties : ArrangeProperties.fromObject( prop )
			placeTo( "x", -1, prop);
			return this;
		}
		/**
		*	Put the itens on right side of the next
		* 
		* 	@see ArrangeProperties.ALLOWED_PROPERTIES
		* 
		*	@param	props		Object
		*
		*	@return Arrange
		**/
		public function toRight( prop : Object = null) : Arrange
		{
			prop = prop == null ? properties : (prop is ArrangeProperties) ? prop as ArrangeProperties : ArrangeProperties.fromObject( prop )
			placeTo( "x", 1, prop);
			return this
		}
		/**
		*	Put the itens on above position of the next.
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES 
		* 
		*	@param	props		Object
		*	
		*	@return Arrange
		**/
		public function toTop( prop : Object = null) : Arrange {
			prop = prop == null ? properties : (prop is ArrangeProperties) ? prop as ArrangeProperties : ArrangeProperties.fromObject( prop )
			placeTo( "y", -1, prop );
			return this;
		}
		/**
		*	Put the itens on under position of the next.
		* 
		* 	@see ArrangeProperties.ALLOWED_PROPERTIES 
		* 
		*	@param	props		Object	
		* 
		*	@return Arrange
		**/
		public function toBottom( prop:Object = null ) : Arrange
		{
			prop = prop == null ? properties : (prop is ArrangeProperties) ? prop as ArrangeProperties : ArrangeProperties.fromObject( prop )
			placeTo( "y", 1, prop );
			return this;
		}
		/**
		 * @private
		 **/
		internal function placeTo( prop:String, operator:int, xtras : Object ) : void
		{
			if ( arrangeList.length<=1 ){
				return;
			}

			var c:int
			var s:Number
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
					arrangeList[ c ][ prop ] = arrangeList[ c ][ prop ] + ( ( ( reffPos - objPos ) * operator + s + padding ) * xtras.step ) * operator;
				}
				c++;
			}
		}
		/**
		*	Align all itens by the top position of the first item
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES 
		* 
		*	@param	props		Object
		* 
		*	@return Arrange
		**/
		public function byTop( prop:Object = null ) : Arrange
		{
			prop = prop == null ? properties : (prop is ArrangeProperties) ? prop as ArrangeProperties : ArrangeProperties.fromObject( prop )
			placeBy( "y", 1, prop);
			return this
		}
		/**
		*	Align all itens by the bottom position of the first item.
		* 
		* 	@see ArrangeProperties.ALLOWED_PROPERTIES
		* 
		*	@param	props		Object
		*
		*	@return Arrange
		**/
		public function byBottom( prop:Object = null ) : Arrange
		{
			prop = prop == null ? properties : (prop is ArrangeProperties) ? prop as ArrangeProperties : ArrangeProperties.fromObject( prop )
			placeBy( "y", -1, prop );
			return this
		}
		/**
		*	Align all itens by the left side of the first item.
		* 	
		*	@see ArrangeProperties.ALLOWED_PROPERTIES
		* 
		*	@param	props		Object	
		* 
		* 	@return Arrange
		**/
		public function byLeft( prop:Object = null ) : Arrange
		{
			prop = prop == null ? properties : (prop is ArrangeProperties) ? prop as ArrangeProperties : ArrangeProperties.fromObject( prop )
			placeBy( "x", 1, prop);
			return this;
		}
		/**
		*	Align all itens by the right side of the first item.
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES 
		* 
		*	@param	props		Object	
		*	
		*	@return Arrange
		**/
		public function byRight( prop:Object = null ) : Arrange
		{
			prop = prop == null ? properties : (prop is ArrangeProperties) ? prop as ArrangeProperties : ArrangeProperties.fromObject( prop )
			placeBy( "x", -1, prop);
			return this;
		}
		/**
		 * @private
		 **/
		internal function placeBy( prop:String, operator:int = 0, xtras:Object = null ) : void
		{
			if ( arrangeList.length<=1 || arrangeList[0]==null ){
				return;
			}

			var c:int = 0;
			var s : Number;
			var objSize : Number;
			var objPos : Number;

			const size:String = (prop == "x") ? "width" : "height";
			const padding : Number = (prop == "x") ? xtras.padding_x : xtras.padding_y;
			const reffSize : Number = arrangeList[ 0 ][ size ];
			const reffPos : Number = arrangeList[ 0 ][ prop ];

			while ( c<arrangeList.length)
			{
				if( c>0 && arrangeList[ c ] != null )
				{
					objSize	= arrangeList[ c ][ size ];
					objPos	= arrangeList[ c ][ prop ];
					s 		= isNaN(xtras[size]) ? reffSize : xtras[size];
					arrangeList[ c ][ prop ] = arrangeList[ c ][ prop ] + ( ( ( ( reffPos - objPos + ( operator==1 ? 0 : s - objSize ) ) ) * operator ) * operator ) * xtras.step + ( padding * operator )
				}
				c++;
			}
		}
		/**
		*	Align all itens by the center width of the first item.
		* 
		*	@see ArrangeProperties.ALLOWED_PROPERTIES 
		* 
		*	@param	props		Object	
		* 
		*	@return Arrange
		**/
		public function center( prop:Object = null ) : Arrange
		{
			centerY( prop );
			return centerX( prop );
		}
		/**
		*	Align all itens by the center height of the first.
		* 
		* 	@see ArrangeProperties.ALLOWED_PROPERTIES
		* 
		*	@param	props		Object	
		*
		*	@return Arrange
		**/
		public function centerY( prop:Object = null ) : Arrange
		{
			prop = prop == null ? properties : (prop is ArrangeProperties) ? prop as ArrangeProperties : ArrangeProperties.fromObject( prop )
			placeCenter( "y", prop);
			return this
		}
		/**
		*	Align all itens by the center X of the first item.
		* 
		*	@see	ArrangeProperties.ALLOWED_PROPERTIES 
		*
		*	@param	props		Object	
		*
		*	@return Arrange
		**/
		public function centerX( prop:Object = null ) : Arrange
		{
			prop = prop == null ? properties : (prop is ArrangeProperties) ? prop as ArrangeProperties : ArrangeProperties.fromObject( prop )
			placeCenter( "x", prop);
			return this
		}
		/**
		* @private
		**/
		internal function placeCenter( prop:String, xtras:Object ) : void
		{
			if ( arrangeList[ 0 ]==null && arrangeList.length<=1 ){
				return;
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
					arrangeList[ c ][ prop ] = arrangeList[ c ][ prop ] - ( ( objPos - reffPos ) + ( s * .5 - reff ) + padding ) * xtras.step;
				}
				c++;
			}
		}
		/**
		* 	@see Grid
		* 	@see Arrange.grid
		*	@see ArrangeProperties.ALLOWED_PROPERTIES
		*
		*	@param	columns		uint
		*	@param	rows		uint
		*	@param	prop		Object
		*
		*	@return Arrange
		**/
		private function createGrid( columns:uint, rows:uint, props: Object = null) : Arrange
		{
			grid = new Grid ( columns, rows );
			var size : int = grid.size;
			var count :int = 0;

			while ( count<size )
			{
				if (count<arrangeList.length){
					grid.add( count, arrangeList[ count ].target );
				}
				count++;
			}

			grid.iterator.reset( );
			var lazyProp : ArrangeProperties = properties.clone();
			if ( props) {
				lazyProp.step = props["step"] || 1;
				lazyProp.width = props["width"] || NaN;
				lazyProp.height = props["height"] || NaN;
			}

			// arranging first column
			new Arrange(grid.getColumn(0)).byLeft(lazyProp).toBottom(props);

			var toArrange : Array;
			count = 0;
			size = grid.getColumn(0).length;

			while ( count < size ){
				// getting rows and aligning it
				toArrange = grid.getRow(count);
				new Arrange(toArrange).byTop(lazyProp).toRight(props);
				count++;
			}
			toArrange = null;
			lazyProp = null;
			return this
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
		public function vGrid( columns:uint, prop:Object = null ) : Arrange {
			return createGrid( columns, Math.ceil(arrangeList.length/columns), prop );
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
		public function hGrid( rows:uint, prop:Object = null ) : Arrange {
			return createGrid( Math.ceil(arrangeList.length/rows), rows, prop );
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
			var c : int
			if (reverse_list){
				c = 0;
				while(c<arrangeList.length){
					if (arrangeList[c].target && arrangeList[c].target.hasOwnProperty("parent")){
						arrangeList[c].target.parent.addChild(arrangeList[c].target);
					}
					c++
				}
			}else{
				c = arrangeList.length;
				while(c--){
					if (arrangeList[c].target && arrangeList[c].target.hasOwnProperty("parent")){
						arrangeList[c].target.parent.addChild(arrangeList[c].target);
					}
				}
			}
			return this
		}
		/**
		*	Return the bounds of all items together.
		* 
		*	@return Rectangle
		*/
		public function get bounds( ) : Rectangle
		{
			var bounds : Rectangle = new Rectangle
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
			var count:int = arrangeList.length;
			while (count--){
				if ( arrangeList[ count ] ){
					arrangeList[ count ].x = int( arrangeList[ count ].x );
					arrangeList[ count ].y = int( arrangeList[ count ].y );
				}
			}
			return this
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
		public function chain(list:Array):Arrange
		{
			if (arrangeList && arrangeList.length>0 && list){
				//concat the very list with the given list
				return new Arrange( [arrangeList[arrangeList.length-1].target].concat(list) );
			}
			else if (list){
				//if empty, no worry, just return a new arrange
				return new Arrange(list);
			}
			//even if everything goes wrong you'll get your dreamed arrangeList
			return new Arrange();
		}
	}
}