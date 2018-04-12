class Coord extends Tuple {
  static final String printformat = "(%.2f, %.2f, %.2f, %.2f)";
  float w = 1.0;

  Coord() {
    super();
  }

  Coord(float x, float y) {
    set(x, y);
  }

  Coord(float x, float y, float z) {
    super(x, y, z);
  }

  String toString() {
    return String.format(printformat, x, y, z, w);
  }

  Coord add(Vector v) {
    x += v.x;
    y += v.y;
    z += v.z;
    return this;
  }

  boolean approx(Coord c) {
    return approx(c.x, c.y, c.z, c.w, EPSILON);
  }

  boolean approx(Coord c, float tolerance) {
    return approx(c.x, c.y, c.z, c.w, tolerance);
  }

  boolean approx(float cx, float cy, float cz, float cw, 
    float tolerance) {
    return approximates(w, cw, tolerance) &&
      approximates(z, cz, tolerance) &&
      approximates(y, cy, tolerance) &&
      approximates(x, cx, tolerance);
  }

  Coord convert(PMatrix3D a, PMatrix3D b, Coord in) {
    Coord c1 = new Coord();
    c1.mult(in, b);
    mult(c1, a);
    homogenize();
    return this;
  }

  Coord draw(PGraphics3D r, color stroke, float strokeWeight) {
    r.pushStyle();
    r.strokeWeight(strokeWeight);
    r.stroke(stroke);
    r.point(x, y, z);
    r.popStyle();
    return this;
  }

  Coord homogenize() {
    if (w != 0.0 && w != 1.0) {
      w = 1.0 / w;
      x *= w;
      y *= w;
      z *= w;
      w = 1.0;
    }
    return this;
  }

  Coord model(PGraphics3D r, Coord in) {
    convert(r.cameraInv, r.modelview, in);
    return this;
  }

  Coord mult(Coord c, PMatrix3D m) {
    x = m.m00 * c.x + m.m01 * c.y + m.m02 * c.z + m.m03 * c.w;
    y = m.m10 * c.x + m.m11 * c.y + m.m12 * c.z + m.m13 * c.w;
    z = m.m20 * c.x + m.m21 * c.y + m.m22 * c.z + m.m23 * c.w;
    w = m.m30 * c.x + m.m31 * c.y + m.m32 * c.z + m.m33 * c.w;
    return this;
  }

  Coord randomCartesian(Dimension min, Dimension max) {
    x = random(min.w, max.w);
    y = random(min.h, max.h);
    z = random(min.d, max.d);
    return this;
  }

  Coord reset() {
    set(0.0, 0.0, 0.0, 1.0);
    return this;
  }

  Coord screen(PGraphics3D r, Coord in) {
    convert(r.projection, r.modelview, in);
    x = r.width * (1.0 + x) * 0.5;
    // Flipped y-axis.
    y = r.height * (1.0 - y) * 0.5;
    z = (1.0 + z) * 0.5;
    return this;
  }

  Coord set(Coord c) {
    set(c.x, c.y, c.z, c.w);
    return this;
  }

  Coord set(float x, float y) {
    this.x = x;
    this.y = y;
    return this;
  }

  Coord set(float x, float y, float z, float w) {
    this.x = x; 
    this.y = y; 
    this.z = z; 
    this.w = w;
    return this;
  }

  Coord sub(Vector v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
    return this;
  }
}
