import glm.Vec2;
import headbutt.twod.shapes.Circle;
import headbutt.twod.shapes.Polygon;
import headbutt.twod.Headbutt;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

class Main {
    static var ctx:CanvasRenderingContext2D;

    static var hb:Headbutt;
    static var poly:Polygon;
    static var circ:Circle;
    static var mouseCirc:Circle;

    static var lastTime:Float = 0;

    public static function main() {
        var canvas:CanvasElement = cast(Browser.document.getElementById('canvas'));
        canvas.width = canvas.clientWidth;
        canvas.height = canvas.clientHeight;
        ctx = canvas.getContext2d();
        Browser.window.requestAnimationFrame(draw);

        // initialize the shapes here
        mouseCirc = new Circle(new Vec2(100, 100), 16);
        poly = new Polygon(new Vec2(), [
            new Vec2(110, 55), new Vec2(200, 62), new Vec2(150, 120)
        ]);

        hb = new Headbutt();

        canvas.addEventListener('mousemove', onMouseMove);
        canvas.addEventListener('touchstart', onTouch);
        canvas.addEventListener('touchmove', onTouch);
    }

    static function onMouseMove(evt:js.html.MouseEvent):Void {
        moveCircle(evt.clientX, evt.clientY);
    }

    static function onTouch(evt:js.html.TouchEvent):Void {
        moveCircle(evt.touches[0].clientX, evt.touches[0].clientY);
        evt.stopPropagation();
    }

    static function moveCircle(x:Float, y:Float):Void {
        var rect:js.html.DOMRect = ctx.canvas.getBoundingClientRect();
        mouseCirc.origin.x = x - rect.left;
        mouseCirc.origin.y = y - rect.top;
    }

    static function draw(ts:Float) {
        var dt:Float = (ts - lastTime) / 1000;
        lastTime = ts;

        // calculate the intersection here
        var intersection:Vec2 = hb.intersect(poly, mouseCirc);
        if(intersection != null) {
            Vec2.addVec(mouseCirc.origin, intersection, mouseCirc.origin);
        }

        /// the rest is just drawing code
        ctx.canvas.width = ctx.canvas.clientWidth;
        ctx.canvas.height = ctx.canvas.clientHeight;
        ctx.clearRect(0, 0, ctx.canvas.clientWidth, ctx.canvas.clientHeight);

        ctx.beginPath();
        ctx.moveTo(poly.vertices[0].x, poly.vertices[0].y);
        for(i in 1...poly.vertices.length) {
            ctx.lineTo(poly.vertices[i].x, poly.vertices[i].y);
        }
        ctx.lineTo(poly.vertices[0].x, poly.vertices[0].y);
        ctx.strokeStyle = '#324D5C';
        ctx.lineWidth = 4;
        ctx.lineJoin = "round";
        ctx.lineCap = "round";
        ctx.stroke();

        ctx.beginPath();
        ctx.arc(mouseCirc.origin.x, mouseCirc.origin.y, mouseCirc.radius, 0, Math.PI * 2);
        ctx.fillStyle = '#46B39D';
        ctx.fill();

        Browser.window.requestAnimationFrame(draw);
    }
}