class Dimension implements Transformable < Dimension > {
  static final String printformat = "(%.2f, %.2f, %.2f)";
  float w = 1.0;
  float h = 1.0;
  float d = 1.0;

  Dimension() {
  }

  Dimension(float scalar) {
    set(scalar);
  }

  Dimension(float w, float h) {
    set(w, h);
  }

  Dimension(float w, float h, float d) {
    set(w, h, d);
  }

  String toString() {
    return String.format(printformat, 
      w, h, d);
  }

  int compareTo(Dimension dim) {
    return d > dim.d ? 1 : d < dim.d ? -1 :
      h > dim.h ? 1 : h < dim.h ? -1 :
      w > dim.w ? 1 : w < dim.w ? -1 : 0;
  }

  Dimension add(Dimension dim) {
    w += dim.w;
    h += dim.h;
    d += dim.d;
    return this;
  }

  Dimension add(Dimension a, Dimension b) {
    w = a.w + b.w;
    h = a.h + b.h;
    d = a.d + b.d;
    return this;
  }

  Dimension add(float scalar) {
    w += scalar;
    h += scalar;
    d += scalar;
    return this;
  }

  Dimension add(float w, float h) {
    this.w += w;
    this.h += h;
    return this;
  }

  Dimension add(float w, float h, float d) {
    this.w += w;
    this.h += h;
    this.d += d;
    return this;
  }

  boolean approx(Dimension dim) {
    return approx(dim.w, dim.h, dim.d, EPSILON);
  }

  boolean approx(Dimension dim, float tolerance) {
    return approx(dim.w, dim.h, dim.d, tolerance);
  }

  boolean approx(float dimw, float dimh, float dimd, float tolerance) {
    return approximates(d, dimd, tolerance) &&
      approximates(h, dimh, tolerance) &&
      approximates(w, dimw, tolerance);
  }

  Dimension div(Dimension dim) {
    w /= dim.w;
    h /= dim.h;
    d /= dim.d;
    return this;
  }

  Dimension div(Dimension a, Dimension b) {
    w = a.w / b.w;
    h = a.h / b.h;
    d = a.d / b.d;
    return this;
  }

  Dimension div(float scalar) {
    scalar = 1.0 / scalar;
    w *= scalar;
    h *= scalar;
    d *= scalar;
    return this;
  }

  Dimension div(float dw, float dh) {
    w /= dw;
    h /= dh;
    return this;
  }

  Dimension div(float dw, float dh, float dd) {
    w /= dw;
    h /= dh;
    d /= dd;
    return this;
  }

  Dimension mult(Dimension d) {
    return mult(d.w, d.h, d.d);
  }

  Dimension mult(Dimension a, Dimension b) {
    w = a.w * b.w;
    h = a.h * b.h;
    d = a.d * b.d;
    return this;
  }

  Dimension mult(float scalar) {
    w *= scalar;
    h *= scalar;
    d *= scalar;
    return this;
  }

  Dimension mult(float dw, float dh) {
    w *= dw;
    h *= dh;
    return this;
  }

  Dimension mult(float dw, float dh, float dd) {
    w *= dw;
    h *= dh;
    d *= dd;
    return this;
  }

  Dimension reset() {
    set(1.0, 1.0, 1.0);
    return this;
  }

  Dimension set(Dimension scale) {
    set(scale.w, scale.h, scale.d);
    return this;
  }

  Dimension set(float scalar) {
    this.w = scalar;
    this.h = scalar;
    this.d = scalar;
    return this;
  }

  Dimension set(float w, float h) {
    this.w = w;
    this.h = h;
    return this;
  }

  Dimension set(float w, float h, float d) {
    this.w = w;
    this.h = h;
    this.d = d;
    return this;
  }

  Dimension sub(Dimension dim) {
    w -= dim.w;
    h -= dim.h;
    d -= dim.d;
    return this;
  }

  Dimension sub(Dimension a, Dimension b) {
    w = a.w - b.w;
    h = a.h - b.h;
    d = a.d - b.d;
    return this;
  }

  Dimension sub(float scalar) {
    w -= scalar;
    h -= scalar;
    d -= scalar;
    return this;
  }

  Dimension sub(float w, float h) {
    this.w -= w;
    this.h -= h;
    return this;
  }

  Dimension sub(float w, float h, float d) {
    this.w -= w;
    this.h -= h;
    this.d -= d;
    return this;
  }
}
