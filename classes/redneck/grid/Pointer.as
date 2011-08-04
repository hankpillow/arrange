package redneck.grid
{
	
	public class Pointer
	{
		public var c : Number;
		public var r : Number;
		/**
		 * 
		 * @param p_c	int	column
		 * @param p_r	int	row
		 * 
		 * */
		public function Pointer(p_c:int=0,p_r:int=0)
		{
			c = p_c;	
			r = p_r;	
		}
		/**
		* 
		* compare pointer
		* 
		* @param	pt	Pointer
		* @return Boollean
		* 
		* */
		public function isDifferent(pt:Pointer):Boolean
		{
			return Pointer.isDifferent( this, pt );
		}
		/**
		* compare pointer
		* 
		* @param	pt	Pointer
		* @return Boollean
		* 
		* */
		public function isEqual(pt:Pointer):Boolean{
			return Pointer.isEqual( this, pt );
		}
		/**
		 * @return String
		 * */
		public function toString():String
		{
			return "Pointer c:"+c+" r:"+r;	
		}
		/**
		* compare two points
		* 
		* @param pt1 Pointer
		* @param pt2 Pointer
		* 
		* @return Boolean
		* 
		* */
		public static function isDifferent(pt1:Pointer, pt2:Pointer):Boolean{
			return !isEqual(pt1,pt2);
		}
		/**
		* 
		* compare two points
		* 
		* @param pt1 Pointer
		* @param pt2 Pointer
		* @return Boolean
		* 
		* */
		public static function isEqual(pt1:Pointer, pt2:Pointer):Boolean{
			return ( pt1.c == pt2.c && pt1.r == pt2.r );
		}
		/**
		* return copy
		* 
		* @return Pointer
		* */
		public function clone():Pointer{
			return new Pointer(c,r);
		}
	}
}