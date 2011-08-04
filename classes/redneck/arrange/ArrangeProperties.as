/**
 *
 * Object with all allowed properties
 *  
 * @author igor almeida
 * @since 06.01.2009
 * @version 0.0.1
 * 
 * */
package redneck.arrange
{
	public class ArrangeProperties
	{
		public var padding_x : Number = 0;
		public var padding_y : Number = 0;
		public var width : Number = NaN;
		public var height : Number = NaN;
		public var step : Number = 1;
		public static const ALLOWED_PROPERTIES : Array = [ "padding_x", "padding_y", "width", "height", "step"];

		public function clone():ArrangeProperties
		{
			var prop : ArrangeProperties = new ArrangeProperties;
				prop.height = height;
				prop.width = width;
				prop.padding_x = padding_x;
				prop.padding_y = padding_y;
				prop.step = step;
			return prop;
		}
		
		public function toString():String
		{
			var result : String = "";
				result  += "padding_x:" + padding_x;
				result  += ", padding_y:" + padding_y;
				result  += ", width:" + width;
				result  += ", height:" + height;
				result  += ", step:" + step;
			return "ArrangeProperties: " + result;
		}
		
		public static function fromObject ( obj : Object ) : ArrangeProperties
		{
			var result : ArrangeProperties = new ArrangeProperties();
			if( obj ){
				result.padding_x = obj.hasOwnProperty("padding_x") ? obj[ "padding_x" ] : obj.hasOwnProperty("x") ? obj["x"] : obj.hasOwnProperty("p_x") ? obj[ "p_x" ] : obj.hasOwnProperty("pX") ? obj[ "pX" ] : obj.hasOwnProperty("paddingX") ? obj[ "paddingX" ] : 0;
				result.padding_y = obj.hasOwnProperty("padding_y") ? obj[ "padding_y" ] : obj.hasOwnProperty("y") ? obj["y"] : obj.hasOwnProperty("p_Y") ? obj[ "p_Y" ] : obj.hasOwnProperty("pY") ? obj[ "pY" ] : obj.hasOwnProperty("paddingY") ? obj[ "paddingY" ] : 0;
				result.width = obj.hasOwnProperty("width") ? obj[ "width" ] : obj.hasOwnProperty("w") ? obj[ "w" ] : NaN;
				result.height = obj.hasOwnProperty("height") ? obj[ "height" ] : obj.hasOwnProperty("h") ? obj[ "h" ] : NaN;
				result.step = obj.hasOwnProperty("step") ? obj[ "step" ] : obj.hasOwnProperty("steps") ? obj[ "steps" ] : 1;
			}
			return result;
		}
	}
}