# Arrange

Arranging objects is a simple, but boring and very repetitive task.
Usually, most of the view’s code is about alignment and positioning of objects on the screen.

Thinking of a way to avoid this repetition I've been coding Arrange for a long time.

We also have a great redesign made by cassiozen:
*https://github.com/cassiozen/AS3-Layout-Manager*

At the beginning Arrange was a static class but after the last year I realize that the most times I used it I called Arrange twice at least, and after some benchmarks I remade it completely because a lot of math and loops could be avoided using instances instead of static.

It’s very simple with only one objective: arrange things on the screen!

The principle Arrange is simple and the same for every method. The very first argument is a list (array or vector) with your objects to be arranged.
Always the reference is the first object, I mean, if you have this list [obj1,obj2,obj3] and call toBottom, it will place obj2 under obj1 and obj3 under obj2. This is how it works!

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
* byDepth
* simulate *(see above)*

## The ArrangeProperties
Every method accepts an ArrangeProperties object (or any object with allowed properties *ArrangeProperties.ALLOWED_PROPERTIES*)

<pre><code>place( [sp1,sp2,spN] ).toRight( {padding_x:10} );</code></pre>
In this example the given list will be arranged placing every item to right side of the previous and adding a padding with 10px.

<pre><code>place( [sp1,sp2,spN] ).toRight( {step:0.5} );</code></pre>
In this example the given list will be arranged placing every item at the 50% of the "real" right side.
If you have 2 objects with 50px (at 0,0 position) and call the method above, the second object will be placed at x=25 and not at x=50 as if you had called *toRight* without any *step*.

But if your object has a timeline in which the object's size changes during this time, you can also pass an optional object with *width* and *height* and the engine will ignore the real size and use the given one.

## What's new?

* Now we have the wrapper *place* but if you prefer you can just call *new Arrange([sprite1,sprite2,...spriteN]).toRight();*
* You can also add/remove items (in case of using the same Arrange instance for a long time)
* Before, all grid method (horizontalGrid and verticalGrid) returned a Grid instance, now, following this new *chain* design,
after calling these methods you can grab your grid instance at the <code>grid</code> property. Example: <code>myGrid = place( array-with-stuff ).vGrid(3).grid;</code>
* The <code>simulate</code> is a brand new feature for Arrange. Actually it was made after Rinaldi (https://github.com/rafaelrinaldi) asked me a way of not changing the position but getting a list with the result if they had been arranged.
This is a great feature because you can use Arrange to know where you should place your objects and use your preferred tween engine to animate it. Let's see how to use it:

<pre><code>place(list).simulate().toRight().byTop().list.forEach( function(o:Object,...rest):void{
	Tweener.addTween(o.target,{x:o.point.x,y:o.point.y})
} );</code></pre>

After calling <code>simulate</code> the engine will stop changing the position and start "faking".
You can get this simulation result at <code>list</code> property, and all objects will have a <code>target</code> and <code>point</code> which you can use to figure where to put it.
You can also stop faking it by calling <code>place(list).simulate(false)</code>