### IMPORTANT CHANGES

**Arrange** worked together with **Grid** all this time and I was not giving the proper importance to it. Grid is very good to manipulate bidimensional arrays and I've decided to keep it into a new git repository. 

If you have the intention of cloning this repository keep in mind that the Grid package is not longer inside classses/redneck/grid but inside the submodule "submoldule-grid".

So, if you clone it and want to see what is inside you must do this:

* git clone git@github.com:hankpillow/arrange.git arrange 
* cd arrange
* git submodule init
* git submodule update

Now all files are there and you can check everything out. 

Once you just want to use it I rather recommend grabbing the swc/arrange.swc file which contains everything you need to use.

To see more about Grid click [here](https://github.com/hankpillow/grid).

To see more examples using Arrange click [here](http://hankpillow.github.com/arrange/examples/).

# Arrange

Arranging objects is a simple, but boring and very repetitive task.
Usually, most of the view’s code is about alignment and positioning of objects on the screen.

Thinking of a way to avoid this repetition I've been coding Arrange for a long time.

We also have a great redesign made by [cassiozen](https://github.com/cassiozen/AS3-Layout-Manager)

At the beginning Arrange was a static class but after the last year I realize that the most times I called Arrange twice at least, and after some benchmarks I remade it completely because a lot of math and loops could be avoided using instances instead of static.

It’s very simple with only one objective: arrange things on the screen!

Arrange works in a very simple and straight way. 
The very first item in the given list (Array or Vector) will be anchor for the others, so the anchor **never** changes the position.

Example: if you have this list [obj1,obj2,obj3] and call toBottom, it will place obj2 under obj1 and obj3 under obj2. This is how it works for all methods!

### What's is different:

**Before:**
<pre><code>Arrange.byRight([sprite1,sprite2,...spriteN])
Arrange.toBottom([sprite1,sprite2,...spriteN])</code></pre>

**After**
<pre><code>place([sprite1,sprite2,...spriteN]).toRight().toBottom();</code></pre>

I kept all methods and special properties in this version, just the API is a bit different and beauty :D

## Available methods:

* toLeft
* byLeft
* toRight
* byRight
* toTop
* byTop
* toBottom
* byBottom
* center *(wrapper centerX and centerY)*
* centerX
* centerY
* round *(rounds x and y)*
* vGrid *(creates a vertical grid)*
* hGrid *(creates an horizontal grid)*
* fromGrid *(uses the given Grid as data source)*
* byDepth
* simulate *(see above)*
* chain *(see above)*

## The ArrangeProperties
Every method accepts an ArrangeProperties object (or any object with allowed properties *ArrangeProperties.ALLOWED_PROPERTIES*)

<pre><code>place( [sp1,sp2,spN] ).toRight( {padding_x:10} );</code></pre>
In this example the given list will be arranged placing every item to right side of the previous and adding a padding with 10px.

If your object has a timeline in which the object's size changes during this time, you can also pass an optional object with *width* and *height* and the engine will ignore the real size and use the given one.

You have also some alias for this properties:

* <code>padding_x</code> = <code>x</code> = <code>px</code> = <code>paddingX</code>
* <code>padding_y</code> = <code>y</code> = <code>py</code> = <code>paddingY</code>
* <code>width</code> = <code>w</code>
* <code>height</code> = <code>h</code>

## What's new?

* You can also add/remove items after its creation

* Now we have a wrapper called <code>place</code> to create a new Arrange:<br>

<pre><code>new Arrange([sprite1,sprite2,...spriteN]).toRight();
place([sprite1,sprite2,...spriteN]).toRight();</code></pre>

* Before, all grid method (horizontalGrid and verticalGrid) returned a Grid instance, now, following this new *chain* design, after calling these methods you can grab your grid instance at the <code>grid</code> property. Example:<br>

<pre><code>var myGrid : Grid = place( array-with-stuff ).vGrid(3).grid;</code></pre>

* The <code>simulate</code> is a brand new feature for Arrange. Actually it was made after [Rinaldi](https://github.com/rafaelrinaldi) asked me a way of not changing the position but getting a list with the result if they had been arranged.
After calling <code>simulate</code> the engine will stop changing the position and start "faking" it. You can get this simulation result at <code>list</code> property, and all objects will have a <code>target</code> and <code>point</code> which you can use to figure where to put it.
You can also stop faking it by calling <code>place(list).simulate(false)</code>. This is a great feature because you can use Arrange to know where you should place your objects and use your preferred tween engine to animate it. Let's see how does it work:

<pre><code>place(list).simulate().toRight().byTop().list.forEach( function(o:Object,...rest):void{
	Tweener.addTween(o.target,{x:o.point.x,y:o.point.y})
} );</code></pre>

* A new method called <code>chain</code> is a very cool feature. It grabs the last item in the current list and concatenates with the given parameter

<pre><code>place( [a,b] ).toRight({x:5}).chain([c,d]).toRight()

//This is the same as:

place( [a,b] ).toRight({x:5})
place( [b,c,d] ).toRight()</code></pre>

That's it!
Happy coding!
