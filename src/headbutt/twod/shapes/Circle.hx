package headbutt.twod.shapes;

using glm.Vec2;
using glm.Mat3;
import headbutt.twod.Shape;

class Circle implements Shape {
    public var position: Vec2;
    public var centre(get, never): Vec2;
    public var radius: Float;

    /**
       Create a new circle
       @param position The centre of the circle in global coordinates
       @param radius The radius of the circle
    */
    public function new(position: Vec2, radius: Float) {
        this.position = position;
        this.radius = radius;
    }

    function get_centre(): Vec2 {
        return position;
    }

    public function support(direction: Vec2): Vec2 {
        var c: Vec2 = centre.copy(new Vec2());
        var d: Vec2 = direction.normalize(new Vec2());
        d.multiplyScalar(radius, d);
        c.addVec(d, c);
        return c;
    }
}