package
{
	import redneck.arrange.*;

	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;

	public class ArrangeTest extends Sprite
	{
		private var list : Vector.<*>;
		public function ArrangeTest()
		{
			super();
			list = new Vector.<*>();
			list.push(addChild(getBox("box")));
			list.push(addChild(getScrollrectBox()));
			list.push(addChild(getCircle()));
			list.push(addChild(getField("i am a textfield")));
			place(list).toRight({x:5}).toBottom();

		}
		private function getScrollrectBox():Sprite{
			var result : Sprite = getBox("scrollrect");
				result.scrollRect = new Rectangle(0,0,result.width*0.5,result.height*0.5);
				result.name = "scrollrect_item";
			return result;
		}

		private function getCircle():Sprite{
			var result  : Sprite = new Sprite;
				result.graphics.beginFill(Math.random()*0xff+Math.random()*0xffff+Math.random()*0xffff,1);
				result.graphics.drawCircle(0,0,20);
				result.graphics.endFill();
				result.name = "circle";
			var xx : Sprite = getPlaceHolder(40,40,0,0,1,.2);
				result.addChild(xx);
				xx.x -= 20;
				xx.y -= 20;
			return result;
		}

		private function getBox(value:String=""):Sprite{
			var result : Sprite = getPlaceHolder(Math.random()*50+50,Math.random()*50+50,Math.random()*0xff+Math.random()*0xffff+Math.random()*0xffff,1,1,0.5);
			//var result : Sprite = getPlaceHolder(50,50,0xffff,1,1,0.5);
			result.addChild(getField(value));
			result.name = "box_"+value;
			return result;
		}
		
		private function getField(value:String):TextField{
			var result : TextField = new TextField;
				result.autoSize = "left";
				result.background = true;
				result.border = true;
				result.text = value;
				result.name = "field";
			return result;
		}
		
		public function getPlaceHolder( p_width:Number, p_height:Number, p_fillColor: int = 0xffffff, p_fillAlpha: Number = 0, p_lineColor:int = 0xff0000, p_lineAlpha:Number = 1 ) : Sprite
		{

			var place_holder : Sprite = new Sprite();
				place_holder.graphics.beginFill( p_fillColor,p_fillAlpha );
				place_holder.graphics.drawRect( 0,0,p_width, p_height );
				place_holder.graphics.endFill();
				if (p_lineAlpha>0){
					place_holder.graphics.lineStyle( 1, p_lineColor, p_lineAlpha );
					place_holder.graphics.lineTo( p_width, p_height );
					place_holder.graphics.moveTo( p_width, 0 );
					place_holder.graphics.lineTo( 0, p_height );
					place_holder.graphics.endFill();
					place_holder.graphics.lineStyle( 1, p_lineColor, p_lineAlpha );
					place_holder.graphics.drawRect( 0,0,p_width, p_height );
					place_holder.graphics.endFill();
				}			
			return place_holder;
		}
	}
}
