abstract class TransformSource
  implements Transformable < TransformSource > {
  static final String printformat =
    "\nPosition: (%.2f, %.2f, %.2f)\n" +
    "Rotation: (%.2f, %.2f, %.2f, %.2f)\n" +
    "Scale: (%.2f, %.2f, %.2f)\n";
  
  Coord position = new Coord();
  Quaternion rotation = new Quaternion();
  Dimension scale = new Dimension();

  TransformSource() {
  }

  TransformSource(float tx, float ty, float tz, 
    float rx, float ry, float rz, float rw, 
    float sw, float sh, float sd) {
    set(tx, ty, tz, rx, ry, rz, rw, sw, sh, sd);
  }

  TransformSource(Coord position, float angle, Vector axis, 
    Dimension scale) {
    set(position, angle, axis, scale);
  }

  TransformSource(Coord position, Quaternion rotation, 
    Dimension scale) {
    set(position, rotation, scale);
  }

  TransformSource(PMatrix2D mat3x3) {
    set(mat3x3);
  }

  TransformSource(PMatrix3D mat4x4) {
    set(mat4x4);
  }

  String toString() {
    return String.format(printformat, 
      position.x, position.y, position.z, 
      rotation.x, rotation.y, rotation.z, rotation.w, 
      scale.w, scale.h, scale.d);
  }

  int compareTo(TransformSource t) {
    return position.compareTo(t.position);
  }

  boolean approx(TransformSource t) {
    return approx(t, EPSILON);
  }

  boolean approx(TransformSource t, float tolerance) {
    return position.approx(t.position, tolerance) &&
      rotation.approx(t.rotation, tolerance) &&
      scale.approx(t.scale, tolerance);
  }

  abstract TransformSource draw(PGraphics3D r);

  TransformSource moveBy(Vector v) {
    position.add(v);
    return this;
  }

  TransformSource moveBy(float x, float y) {
    position.add(x, y);
    return this;
  }

  TransformSource moveBy(float x, float y, float z) {
    position.add(x, y, z);
    return this;
  }

  TransformSource moveTo(Coord c) {
    position.set(c);
    return this;
  }

  TransformSource moveTo(float x, float y) {
    position.set(x, y);
    return this;
  }

  TransformSource moveTo(float x, float y, float z) {
    position.set(x, y, z);
    return this;
  }

  TransformSource reset() {
    position.reset();
    scale.reset();
    rotation.reset();
    return this;
  }

  TransformSource rotateBy(float angle, Vector axis) {
    rotation.rotateBy(angle, axis);
    return this;
  }

  TransformSource rotateBy(float angle, float axisx, 
    float axisy, float axisz) {
    rotation.rotateBy(angle, axisx, axisy, axisz);
    return this;
  }

  TransformSource rotateX(float angle) {
    rotation.rotateX(angle);
    return this;
  }

  TransformSource rotateY(float angle) {
    rotation.rotateY(angle);
    return this;
  }

  TransformSource rotateZ(float angle) {
    rotation.rotateZ(angle);
    return this;
  }

  TransformSource rotateTo(float angle, Vector axis) {
    rotation.set(angle, axis);
    return this;
  }

  TransformSource rotateTo(Quaternion q) {
    rotation.set(q);
    return this;
  }

  TransformSource scaleBy(Dimension scale) {
    this.scale.add(scale);
    return this;
  }

  TransformSource scaleBy(float scl) {
    scale.add(scl);
    return this;
  }

  TransformSource scaleBy(float w, float h) {
    scale.add(w, h);
    return this;
  }

  TransformSource scaleBy(float w, float h, float d) {
    scale.add(w, h, d);
    return this;
  }

  TransformSource scaleTo(Dimension scale) {
    this.scale.set(scale);
    return this;
  }

  TransformSource scaleTo(float scl) {
    scale.set(scl, scl, scl);
    return this;
  }

  TransformSource scaleTo(float x, float y) {
    scale.set(x, y);
    return this;
  }

  TransformSource scaleTo(float x, float y, float z) {
    scale.set(x, y, z);
    return this;
  }

  TransformSource set(float tx, float ty, float tz, 
    float rx, float ry, float rz, float rw, 
    float sw, float sh, float sd) {
    position.set(tx, ty, tz);
    rotation.set(rx, ry, rz, rw);
    scale.set(sw, sh, sd);
    return this;
  }

  TransformSource set(TransformSource transform) {
    position.set(transform.position);
    scale.set(transform.scale);
    rotation.set(transform.rotation);
    return this;
  }

  TransformSource set(Coord translation, float angle, Vector axis, 
    Dimension scale) {
    this.position.set(translation);
    this.rotation.set(angle, axis);
    this.scale.set(scale);
    return this;
  }

  TransformSource set(Coord translation, Quaternion rotation, 
    Dimension scale) {
    this.position.set(translation);
    this.rotation.set(rotation);
    this.scale.set(scale);
    return this;
  }

  TransformSource set(PMatrix2D mat3x3) {
    position.set(mat3x3.m02, mat3x3.m12);

    Vector i = new Vector(mat3x3.m00, mat3x3.m10);
    Vector j = new Vector(mat3x3.m01, mat3x3.m11);
    float imag = i.magnitude();
    float jmag = j.magnitude();

    if (mat3x3.determinant() < 0.0) {
      jmag = -jmag;
    }
    scale.set(imag, jmag);

    i.mult(imag != 0.0 ? 1.0 / imag : 0.0);
    j.mult(jmag != 0.0 ? 1.0 / jmag : 0.0);
    rotation.set(i.x, j.x, 0.0, 
      i.y, j.y, 0.0, 
      0.0, 0.0, 1.0);
    return this;
  }

  TransformSource set(PMatrix3D mat4x4) {
    position.set(mat4x4.m03, mat4x4.m13, mat4x4.m23);

    Vector i = new Vector(mat4x4.m00, mat4x4.m10, mat4x4.m20);
    Vector j = new Vector(mat4x4.m01, mat4x4.m11, mat4x4.m21);
    Vector k = new Vector(mat4x4.m02, mat4x4.m12, mat4x4.m22);
    float imag = i.magnitude();
    float jmag = j.magnitude();
    float kmag = k.magnitude();

    if (mat4x4.determinant() < 0.0) {
      jmag = -jmag;
    }
    scale.set(imag, jmag, kmag);

    i.mult(imag != 0.0 ? 1.0 / imag : 0.0);
    j.mult(jmag != 0.0 ? 1.0 / jmag : 0.0);
    k.mult(kmag != 0.0 ? 1.0 / kmag : 0.0);

    rotation.set(i.x, j.x, k.x, 
      i.y, j.y, k.y, 
      i.z, j.z, k.z);
    return this;
  }

  PMatrix3D toMatrix(PMatrix3D m) {
    rotation.toMatrix(m);
    m.m00 *= scale.w;
    m.m10 *= scale.w;
    m.m20 *= scale.w;
    m.m01 *= scale.h;
    m.m11 *= scale.h;
    m.m21 *= scale.h;
    m.m02 *= scale.d;
    m.m12 *= scale.d;
    m.m22 *= scale.d;
    m.m03 = position.x; 
    m.m13 = position.y; 
    m.m23 = position.z;
    return m;
  }

  PMatrix3D toPMatrix3D() {
    return toMatrix(new PMatrix3D());
  }
}
