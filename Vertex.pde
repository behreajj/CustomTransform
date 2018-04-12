class Vertex {
  Coord coord;
  Coord texCoord;
  Normal normal;

  Vertex() {
  }

  Vertex(Coord v, Coord vt, Normal vn) {
    referTo(v, vt, vn);
  }

  String toString() {
    return new StringBuilder()
      .append(coord).append(",\n")
      .append(texCoord).append(",\n")
      .append(normal)
      .toString();
  }

  Vertex copyFrom(Vertex vert) {
    return copyFrom(vert.coord, vert.texCoord, vert.normal);
  }

  Vertex copyFrom(Coord coord, Coord texCoord, Normal normal) {
    if (this.coord == null) { 
      this.coord = new Coord();
    }
    this.coord.set(coord);

    if (this.texCoord == null) {
      this.texCoord = new Coord();
    }
    this.texCoord.set(texCoord);

    if (this.normal == null) {
      this.normal = new Normal();
    }
    this.normal.set(normal);
    return this;
  }

  Vertex referTo(Vertex vert) {
    return referTo(vert.coord, vert.texCoord, vert.normal);
  }

  Vertex referTo(Coord coord, Coord texCoord, Normal normal) {
    this.coord = coord;
    this.texCoord = texCoord;
    this.normal = normal;
    return this;
  }
}
