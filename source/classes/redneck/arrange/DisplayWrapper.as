/**
 * 
 * DisplayWrapper 
 * 
 * @author igor almeida
 * @version 0.3
 * @since 14.01.2009
 * 
 * */
package redneck.arrange
{
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;

	public class DisplayWrapper
	{
		//@private
		private var targetX : Number = 0;
		private var targetY : Number = 0;
		private var simulatedBounds : Rectangle;

		// the given object
		private var _target : *;
		public function get target():*{return _target;}
		// when using Arrange.simulate you should get the destination position by getting this <code>point</code>
		public function get point():Point{return new Point(targetX,targetY);}
		
		//@internal control
		internal var bounds : Rectangle;
		internal var hasParent : Boolean;
		internal var isStage: Boolean;
		internal var hasScrollRect : Boolean;
		internal var simulate : Boolean;
		/**
		* 
		* @param p_target	*	possible values: Object with x,y,width and height, Point or Rectangle.
		* 
		**/
		public function DisplayWrapper( p_target :* ) : void
		{
			_target			= p_target;
			bounds			= new Rectangle;
			isStage			= _target is Stage;
			hasScrollRect	= _target.hasOwnProperty("scrollRect") && (_target.scrollRect!=null) && (_target.scrollRect is Rectangle);
			hasParent		= _target.hasOwnProperty("parent") && (_target.parent!=null);

			simulatedBounds = getBounds().clone();

			targetX = _target.x;
			targetY = _target.y;
		}
		/**
		* return the real bounds for <code>_target</code>
		* @return Rectangle
		**/
		private function getBounds():Rectangle
		{
			if (_target==null)
			{
				return bounds;
			}

			if ( isStage )
			{
				bounds.width = _target.stageWidth;
				bounds.height = _target.stageHeight;
				bounds.x = 0;
				bounds.y = 0;
				return bounds;
			}

			if ( _target is Point )
			{
				bounds.width = 0;
				bounds.height = 0;
				bounds.x = _target.x;
				bounds.y = _target.y;
				return bounds;
			}

			bounds.width = _target.width || 0;
			bounds.height = _target.height || 0;
			bounds.x = _target.x || 0;
			bounds.y = _target.y || 0;

			if ( hasParent )
			{
				if ( _target.width + _target.height == 0 && 
					 !(_target is TextField) && 
					 _target.hasOwnProperty("transform") && 
					 (_target.transform!=null) && 
					 (_target is DisplayObjectContainer) )
				{
					// pixelbounds is the better way to get the display's size
					// because the getRect/getBounds just doesn't work for "empty" displays 
					// neither for textfields.

					// check it out:
					// trace(addChild(new Sprite()).getRect(stage))
					// (x=6710886.4, y=6710886.4, w=0, h=0)
					bounds = _target.transform.pixelBounds;
				}
				else
				{
					bounds = _target.getBounds(_target.parent);
				}
			}

			if (hasScrollRect)
			{
				bounds.width = _target.scrollRect.width;
				bounds.height = _target.scrollRect.height;
			}
			return bounds;
		}
		/**
		**/
		internal function get x ( ) :Number{
			if (simulate){
				simulatedBounds.x = targetX - (hasParent ? _target.x-bounds.x : 0);
				return simulatedBounds.x;
			}
			return getBounds().x;
		}
		/**
		**/
		internal function get y ( ) : Number{
			if (simulate){
				simulatedBounds.y = targetY - (hasParent ? _target.y-bounds.y : 0);
				return simulatedBounds.y;
			}
			return getBounds().y;
		}
		/**
		**/
		internal function set x ( value : Number ) : void {
			if (isStage)return;
			value = isNaN(value)?0:value;
			targetX = (hasParent ? _target.x-bounds.x : 0) + value;
			if (!simulate){
				_target.x = targetX
			}
		}
		/**
		**/
		internal function set y ( value : Number ) : void {
			if (isStage)return;
			value = isNaN(value)?0:value;
			targetY = (hasParent ? _target.y-bounds.y : 0) + value;
			if (!simulate){
				_target.y = targetY;
			}
		}

		internal function get width():Number{return getBounds().width;};
		internal function get height():Number{return getBounds().height;};
		internal function set height(value:Number):void{ };
		internal function set width(value:Number):void{ };

		public function toString():*{return "DisplayWrapper for:"+_target;}
	}
}