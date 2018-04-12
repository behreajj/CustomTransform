class Vector extends Direction {
  Vector() {
    super();
  }

  Vector(float x, float y) {
    super(x, y);
  }

  Vector(float x, float y, float z) {
    super(x, y, z);
  }

  Vector (Coord a, Coord b) {
    set(a, b);
  }

  Vector cross(Vector a, Vector b) {
    x = a.y * b.z - b.y * a.z;
    y = a.z * b.x - b.z * a.x;
    z = a.x * b.y - b.x * a.y;
    return this;
  }

  Vector set(Coord a, Coord b) {
    x = b.x - a.x;
    y = b.y - a.y;
    z = b.z - a.z;
    return this;
  }
}
