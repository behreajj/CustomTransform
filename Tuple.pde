abstract class Tuple implements Transformable < Tuple > {
  static final String printformat = "(%.2f, %.2f, %.2f)";

  float x = 0.0;
  float y = 0.0;
  float z = 0.0;

  Tuple() {
  }

  Tuple(float x, float y, float z) {
    set(x, y, z);
  }

  String toString() {
    return String.format(printformat, x, y, z);
  }

  int compareTo(Tuple t) {
    return z > t.z ? 1 : z < t.z ? -1 :
      y > t.y ? 1 : y < t.y ? -1 :
      x > t.x ? 1 : x < t.x ? -1 : 0;
  }

  Tuple add(Tuple t) {
    add(t.x, t.y, t.z);
    return this;
  }

  Tuple add(Tuple a, Tuple b) {
    x = a.x + b.y;
    y = a.y + b.y;
    z = a.z + b.z;
    return this;
  }

  Tuple add(float x, float y) {
    this.x += x;
    this.y += y;
    return this;
  }

  Tuple add(float x, float y, float z) {
    this.x += x;
    this.y += y;
    this.z += z;
    return this;
  }

  boolean approx(Tuple t) {
    return approx(t.x, t.y, t.z, EPSILON);
  }

  boolean approx(Tuple t, float tolerance) {
    return approx(t.x, t.y, t.z, tolerance);
  }

  boolean approx(float tx, float ty, float tz, float tolerance) {
    return approximates(z, tz, tolerance) &&
      approximates(y, ty, tolerance) &&
      approximates(x, tx, tolerance);
  }

  Tuple div(Dimension d) {
    x /= d.w;
    y /= d.h;
    z /= d.d;
    return this;
  }

  Tuple div(Quaternion q) {
    mult(new Quaternion().invert(q));
    return this;
  }

  Tuple div(float scalar) {
    scalar = 1.0 / scalar;
    x *= scalar;
    y *= scalar;
    z *= scalar;
    return this;
  }

  Tuple mult(Dimension d) {
    x *= d.w;
    y *= d.h;
    z *= d.d;
    return this;
  }

  Tuple mult(Quaternion q) {
    float ix = q.w * x + q.y * z - q.z * y;
    float iy = q.w * y + q.z * x - q.x * z;
    float iz = q.w * z + q.x * y - q.y * x;
    float iw = -q.x * x - q.y * y - q.z * z;
    x = ix * q.w + iz * q.y - iw * q.x - iy * q.z;
    y = iy * q.w + ix * q.z - iw * q.y - iz * q.x; 
    z = iz * q.w + iy * q.x - iw * q.z - ix * q.y;
    return this;
  }

  Tuple mult(Transform t) {
    mult(t.rotation);
    mult(t.scale);
    add(t.position);
    if (t. parent != null) {
      return mult(t.parent);
    }
    return this;
  }

  Tuple mult(TransformSource t) {
    mult(t.rotation);
    mult(t.scale);
    add(t.position);
    return this;
  }

  Tuple mult(float scalar) {
    x *= scalar;
    y *= scalar;
    z *= scalar;
    return this;
  }

  Tuple negate() {
    x = -x; 
    y = -y; 
    z = -z;
    return this;
  }

  Tuple negate(Tuple in) {
    x = -in.x; 
    y = -in.y; 
    z = -in.z;
    return this;
  }

  Tuple reset() {
    return set(0.0, 0.0, 0.0);
  }

  Tuple set(Tuple t) {
    set(t.x, t.y, t.z);
    return this;
  }

  Tuple set(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    return this;
  }

  Tuple sub(Tuple t) {
    return sub(t.x, t.y, t.z);
  }

  Tuple sub(Tuple a, Tuple b) {
    x = a.x - b.x;
    y = a.y - b.y;
    z = a.z - b.z;
    return this;
  }

  Tuple sub(float x, float y) {
    this.x -= x;
    this.y -= y;
    return this;
  }

  Tuple sub(float x, float y, float z) {
    this.x -= x;
    this.y -= y;
    this.z -= z;
    return this;
  }
}
