class Quaternion implements Transformable < Quaternion > {
  static final String printformat = "(%.2f, %.2f, %.2f, %.2f)";
  float x = 0.0; 
  float y = 0.0; 
  float z = 0.0;
  float w = 1.0;

  Quaternion() {
  }

  Quaternion(float x, float y, float z, float w) {
    set(x, y, z, w);
  }

  Quaternion(float angle, Vector axis) {
    set(angle, axis);
  }

  Quaternion (PMatrix2D mat3x3) {
    set(mat3x3);
  }

  Quaternion (PMatrix3D mat4x4) {
    set(mat4x4);
  }

  Quaternion (Vector i, Vector j, Vector k) {
    set(i, j, k);
  }

  Quaternion (float ix, float jx, float kx, 
    float iy, float jy, float ky, 
    float iz, float jz, float kz) {
    set(ix, jx, kx, iy, jy, ky, iz, jz, kz);
  }

  String toString() {
    return String.format(printformat, x, y, z, w);
  }

  int compareTo(Quaternion q) {
    return w > q.w ? 1 : w < q.w ? -1 :
      z > q.z ? 1 : z < q.z ? -1 :
      y > q.y ? 1 : y < q.y ? -1 :
      x > q.x ? 1 : x < q.x ? -1 : 0;
  }

  Quaternion add(Quaternion q) {
    return add(q.x, q.y, q.z, q.w);
  }

  Quaternion add(Quaternion a, Quaternion b) {
    x = a.x + b.x;
    x = a.y + b.y;
    x = a.z + b.z;
    x = a.w + b.w;
    return this;
  }

  Quaternion add(float qx, float qy, float qz, float qw) {
    x += qx; 
    y += qy; 
    z += qz; 
    w += qw;
    return this;
  }

  float angle() {
    return acos(w) * 2.0;
  }

  boolean approx(Quaternion q) {
    return approx(q.x, q.y, q.z, q.w, EPSILON);
  }

  boolean approx(Quaternion q, float tolerance) {
    return approx(q.x, q.y, q.z, q.w, tolerance);
  }

  boolean approx(float qx, float qy, float qz, float qw, 
    float tolerance) {
    return approximates(w, qw, tolerance) &&
      approximates(z, qz, tolerance) &&
      approximates(y, qy, tolerance) &&
      approximates(x, qx, tolerance);
  }

  Vector axis() {
    return axis(new Vector());
  }

  Vector axis(Vector out) {
    float sin = asin(w);
    if (sin != 0.0) {
      sin = 1.0 / sin;
      out.set(x * sin, y * sin, z * sin);
      out.normalize();
      return out;
    }
    out.set(1.0, 0.0, 0.0);
    return out;
  }

  Quaternion div(Quaternion q) {
    mult(new Quaternion().invert(q));
    return this;
  }

  Quaternion div(float scalar) {
    scalar = 1.0 / scalar;
    x *= scalar; 
    y *= scalar; 
    z *= scalar; 
    w *= scalar;
    return this;
  }

  float dot(Quaternion q) {
    return x * q.x + y * q.y + z * q.z + w * q.w;
  }

  float dot(float qx, float qy, float qz, float qw) {
    return x * qx + y * qy + z * qz + w * qw;
  }

  Vector forward() {
    return forward(new Vector());
  }

  Vector forward(Vector out) {
    // Equivalent to
    // return mult(0.0, 0.0, 1.0, out);
    out.x = y * w + w * y + z * x + x * z;
    out.y = -x * w + y * z + z * y - w * x; 
    out.z = w * w - x * x + z * z - y * y;
    return out;
  }

  Quaternion invert() {
    float dot = magnitudeSq();
    dot = dot == 0.0 ? 0.0 : 1.0 / dot;
    x = -x * dot;
    y = -y * dot;
    z = -z * dot;
    w = w * dot;
    return this;
  }

  Quaternion invert(Quaternion in) {
    float dot = in.magnitudeSq();
    dot = dot == 0.0 ? 0.0 : 1.0 / dot;
    x = -in.x * dot;
    y = -in.y * dot;
    z = -in.z * dot;
    w = in.w * dot;
    return this;
  }

  Quaternion lookAt(Coord origin, Coord target, Vector up) {
    Vector k = new Vector(origin, target);
    k.normalize();
    return lookAt(k, up);
  }

  Quaternion lookAt(Vector forward, Vector up) {
    if (forward.approx(0.0, 0.0, 0.0, EPSILON)) {
      return this;
    }
    Vector i = new Vector();
    Vector j = new Vector();
    i.cross(forward, up);
    i.normalize();
    j.cross(forward, i);
    j.normalize();
    return set(i.x, j.x, forward.x, 
      i.y, j.y, forward.y, 
      i.z, j.z, forward.z);
  }

  float magnitude() {
    return sqrt(x * x + y * y + z * z + w * w);
  }

  float magnitudeSq() {
    return x * x + y * y + z * z + w * w;
  }

  Quaternion mult(float scalar) {
    x *= scalar; 
    y *= scalar; 
    z *= scalar; 
    w *= scalar;
    return this;
  }

  Quaternion mult(Quaternion b) {
    float tx = x;
    float ty = y;
    float tz = z;
    x = x * b.w + w * b.x + y * b.z - z * b.y;
    y = y * b.w + w * b.y + z * b.x - tx * b.z;
    z = z * b.w + w * b.z + tx * b.y - ty * b.x;
    w = w * b.w - tx * b.x - ty * b.y - tz * b.z;
    return this;
  }

  Quaternion mult(Quaternion a, Quaternion b) {
    x = a.x * b.w + a.w * b.x + a.y * b.z - a.z * b.y;
    y = a.y * b.w + a.w * b.y + a.z * b.x - a.x * b.z;
    z = a.z * b.w + a.w * b.z + a.x * b.y - a.y * b.x;
    w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z;
    return this;
  }

  Quaternion normalize() {
    float m = magnitudeSq();
    if (m != 0.0 && m != 1.0) {
      div(sqrt(m));
    }
    return this;
  }

  Quaternion normalize(Quaternion in) {
    float m = magnitudeSq();
    if (m != 0.0 && m != 1.0) {
      m = 1.0 / sqrt(m);
      x = in.x * m;
      y = in.y * m;
      z = in.z * m;
      w = in.w * m;
    }
    return this;
  }

  Quaternion random() {
    // Alternatively, create a randomSpherical
    // axis and a random angle.
    x = (float)Math.random() * 2.0 - 1.0;
    y = (float)Math.random() * 2.0 - 1.0;
    z = (float)Math.random() * 2.0 - 1.0;
    w = (float)Math.random() * 2.0 - 1.0;
    return normalize();
  }

  Quaternion reset() {
    return set(0.0, 0.0, 0.0, 1.0);
  }

  Quaternion rescale(float scalar) {
    float mag = magnitudeSq();
    if (mag == 0.0) {
      return this;
    } else if (mag == 1.0) {
      mult(scalar);
      return this;
    }
    mult(scalar / sqrt(mag));
    return this;
  }

  Vector right() {
    return right(new Vector());
  }

  Vector right(Vector out) {
    // Equivalent to
    // return mult(1.0, 0.0, 0.0, out);
    out.x = w * w - y * y + x * x - z * z;
    out.y = z * w + w * z + x * y + y * x;
    out.z = -y * w + z * x + x * z - w * y;
    return out;
  }

  Quaternion rotateBy(float angle, Vector axis) {
    rotateBy(angle, axis.x, axis.y, axis.z);
    return this;
  }

  Quaternion rotateBy(float angle, float axisx, 
    float axisy, float axisz) {
    float a = acos(w) * 2.0 + angle;
    float halfangle = 0.5 * floorMod(a, TWO_PI);
    float sinhalf = sin(halfangle);
    x = axisx * sinhalf; 
    y = axisy * sinhalf;
    z = axisz * sinhalf; 
    w = cos(halfangle);
    return this;
  }

  Quaternion rotateX(float angle) {
    float cosa = cos(angle * 0.5);
    float sina = sin(angle * 0.5);
    float tempx = x;
    float tempy = y;
    x = cosa * x + sina * w;
    y = cosa * y + sina * z;
    z = cosa * z - sina * tempy;
    w = cosa * w - sina * tempx;
    return this;
  }

  Quaternion rotateY(float angle) {
    float cosa = cos(angle * 0.5);
    float sina = sin(angle * 0.5);
    float tempx = x;
    float tempy = y;
    x = cosa * x - sina * z;
    y = cosa * y + sina * w;
    z = cosa * z + sina * tempx;
    w = cosa * w - sina * tempy;
    return this;
  }

  Quaternion rotateZ(float angle) {
    float cosa = cos(angle * 0.5);
    float sina = sin(angle * 0.5);
    float tempx = x;
    float tempz = z;
    x = cosa * x + sina * y;
    y = cosa * y - sina * tempx;
    z = cosa * z + sina * w;
    w = cosa * w - sina * tempz;
    return this;
  }

  Quaternion set(float x, float y, float z, float w) {
    this.x = x; 
    this.y = y; 
    this.z = z; 
    this.w = w;
    return this;
  }

  Quaternion set(Quaternion q) {
    x = q.x; 
    y = q.y; 
    z = q.z; 
    w = q.w;
    return this;
  }

  Quaternion set(float angle, Vector axis) {
    float halfangle = 0.5 * angle;
    float sinhalf = sin(halfangle);
    x = axis.x * sinhalf; 
    y = axis.y * sinhalf;
    z = axis.z * sinhalf; 
    w = cos(halfangle);
    return this;
  }

  Quaternion set(PMatrix2D mat3x3) {
    return set(mat3x3.m00, mat3x3.m01, 0.0, 
      mat3x3.m10, mat3x3.m11, 0.0, 
      0.0, 0.0, 1.0);
  }

  Quaternion set(PMatrix3D mat4x4) {
    return set(mat4x4.m00, mat4x4.m01, mat4x4.m02, 
      mat4x4.m10, mat4x4.m11, mat4x4.m12, 
      mat4x4.m20, mat4x4.m21, mat4x4.m22);
  }

  Quaternion set(Vector i, Vector j, Vector k) {
    return set(i.x, j.x, k.x, 
      i.y, j.y, k.y, 
      i.z, j.z, k.z);
  }

  Quaternion set(float ix, float jx, float kx, 
    float iy, float jy, float ky, 
    float iz, float jz, float kz) {
    w = sqrt(max(0.0, 1.0 + ix + jy + kz)) * 0.5;
    x = sqrt(max(0.0, 1.0 + ix - jy - kz)) * 0.5;
    y = sqrt(max(0.0, 1.0 - ix + jy - kz)) * 0.5;
    z = sqrt(max(0.0, 1.0 - ix - jy + kz)) * 0.5;
    x *= Math.signum(jz - ky);
    y *= Math.signum(kx - iz);
    z *= Math.signum(iy - jx);
    return this;
  }

  Quaternion sub(Quaternion q) {
    return sub(q.x, q.y, q.z, q.w);
  }

  Quaternion sub(Quaternion a, Quaternion b) {
    x = a.x - b.x;
    x = a.y - b.y;
    x = a.z - b.z;
    x = a.w - b.w;
    return this;
  }

  Quaternion sub(float qx, float qy, float qz, float qw) {
    x -= qx; 
    y -= qy; 
    z -= qz; 
    w -= qw;
    return this;
  }

  PMatrix3D toMatrix(PMatrix3D out) {
    float x2 = x + x; 
    float y2 = y + y; 
    float z2 = z + z;
    float xsq2 = x * x2; 
    float ysq2 = y * y2; 
    float zsq2 = z * z2;
    float xy2 = x * y2; 
    float xz2 = x * z2; 
    float yz2 = y * z2;
    float wx2 = w * x2; 
    float wy2 = w * y2; 
    float wz2 = w * z2;
    out.set(
      1.0 - ysq2 - zsq2, xy2 - wz2, xz2 + wy2, 0.0, 
      xy2 + wz2, 1.0 - xsq2 - zsq2, yz2 - wx2, 0.0, 
      xz2 - wy2, yz2 + wx2, 1.0 - xsq2 - ysq2, 0.0, 
      0.0, 0.0, 0.0, 1.0);
    return out;
  }

  PMatrix3D toPMatrix3D() {
    return toMatrix(new PMatrix3D());
  }

  Vector up() {
    return up(new Vector());
  }

  Vector up(Vector out) {
    // Equivalent to
    // return mult(0.0, 1.0, 0.0, out);
    out.x = -z * w + x * y + y * x - w * z;
    out.y = w * w - z * z + y * y - x * x;
    out.z = x * w + w * x + y * z + z * y;
    return out;
  }
}
