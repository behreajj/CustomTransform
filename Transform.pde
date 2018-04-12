class Transform extends TransformSource {
  Transform parent = null;

  Transform() {
  }

  Transform(float tx, float ty, float tz, 
    float rx, float ry, float rz, float rw, 
    float sw, float sh, float sd) {
    super(tx, ty, tz, rx, ry, rz, rw, sw, sh, sd);
  }

  Transform(Coord position, float angle, Vector axis, 
    Dimension scale) {
    super(position, angle, axis, scale);
  }

  Transform(Coord position, Quaternion rotation, 
    Dimension scale) {
    super(position, rotation, scale);
  }

  Transform(PMatrix2D mat3x3) {
    super(mat3x3);
  }

  Transform(PMatrix3D mat4x4) {
    super(mat4x4);
  }

  Transform draw(PGraphics3D p) {
    return draw(p, 0xffff0000, 0xff00ff00, 0xff0000ff, 1.5, 5.0);
  }

  Transform draw(PGraphics3D p, color right, color up, color forward, 
    float ln, float pt) {

    Coord t = worldPosition(new Coord());
    Quaternion r = worldRotation(new Quaternion());
    Dimension s = worldScale(new Dimension());
    Vector out = new Vector();

    p.pushStyle();
    drawAxis(p, t, r.right(out), s, right, ln, pt);
    drawAxis(p, t, r.up(out), s, up, ln, pt);
    drawAxis(p, t, r.forward(out), s, forward, ln, pt);
    p.popStyle();
    return this;
  }

  TransformSource drawAxis(PGraphics3D p, Coord t, Vector axis, 
    Dimension s, int stroke, float linweight, float ptweight) {
    p.strokeWeight(linweight);
    p.stroke(stroke);
    axis.mult(s.d);
    axis.add(t.x, t.y, t.z);    
    p.line(t.x, t.y, t.z, axis.x, axis.y, axis.z);
    p.strokeWeight(ptweight);
    p.point(axis.x, axis.y, axis.z);
    return this;
  }

  Transform lookAt(Coord target, Vector up) {
    Vector k = new Vector(worldPosition(), target);
    k.normalize();
    lookAt(k, up);
    return this;
  }

  Transform lookAt(Vector forward, Vector up) {
    Quaternion inv = parent.worldRotation(new Quaternion());
    inv.invert();
    Vector j = new Vector();
    Vector k = new Vector();
    j.set(up);
    k.set(forward);
    j.mult(inv);
    k.mult(inv);
    rotation.lookAt(k, j);
    return this;
  }

  Transform removeParent() {
    if (parent != null) {
      position = worldPosition(new Coord());
      rotation = worldRotation(new Quaternion());
      scale = worldScale(new Dimension());
      parent = null;
    }
    return this;
  }
  
  Coord worldPosition() {
    return worldPosition(new Coord());
  }

  Coord worldPosition(Coord out) {
    out.mult(this);
    return out;
  }

  Quaternion worldRotation() {
    return worldRotation(new Quaternion());
  }

  Quaternion worldRotation(Quaternion out) {
    if (parent != null) {
      parent.worldRotation(out);
      out.mult(rotation);
      return out;
    } else {
      out.set(rotation);
      return out;
    }
  }

  Dimension worldScale() {
    return worldScale(new Dimension());
  }

  Dimension worldScale(Dimension out) {
    if (parent != null) {
      parent.worldScale(out);
      out.mult(scale);
      return out;
    } else {
      out.set(scale);
      return out;
    }
  }
}
