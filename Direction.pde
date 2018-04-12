abstract class Direction extends Tuple {
  static final String printformat = "(%.4f, %.4f, %.4f)";

  Direction() {
    super();
  }

  Direction(float x, float y) {
    set(x, y);
  }

  Direction(float x, float y, float z) {
    super(x, y, z);
  }

  String toString() {
    return String.format(printformat, x, y, z);
  }

  float dot(Direction dir) {
    return x * dir.x + y * dir.y + z * dir.z;
  }

  float dot(float dirx, float diry, float diz) {
    return x * dirx + y * diry + z * diz;
  }

  Direction fromAngle(float theta) {
    set(cos(theta), sin(theta), 0.0);
    return this;
  }

  Direction fromAngle(float theta, float phi) {
    float sinphi = sin(phi);
    set(sinphi * cos(theta), sinphi * sin(theta), cos(phi));
    return this;
  }

  float magnitude() {
    return sqrt(x * x + y * y + z * z);
  }

  float magnitudeSq() {
    return x * x + y * y + z * z;
  }

  Direction normalize() {
    float m = magnitudeSq();
    if (m != 0.0 && m != 1.0) {
      div(sqrt(m));
    }
    return this;
  }

  Direction normalize(Direction in) {
    float m = magnitudeSq();
    if (m != 0.0 && m != 1.0) {
      m = 1.0 / sqrt(m);
      x = in.x * m;
      y = in.y * m;
      z = in.z * m;
    }
    return this;
  }

  Direction randomPolar() {
    return fromAngle(random(TWO_PI));
  }

  Direction randomSpherical() {
    return fromAngle(random(TWO_PI), random(PI));
  }
  
  Direction set(float x, float y) {
    this.x = x;
    this.y = y;
    return this;
  }
}
