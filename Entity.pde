class Entity {
  String name = "Entity";
  Transform transform;
  Material material;
  Mesh mesh;

  // For local use.
  protected Coord v = new Coord();
  protected Normal vn = new Normal();
  protected Coord vt = new Coord();
  protected Quaternion wr = new Quaternion();

  Entity() {
  }

  Entity(Transform transform, Material material, Mesh shape) {
    this.transform = transform;
    this.material = material;
    this.mesh = shape;
  }

  Entity draw(PGraphics3D r) {
    Coord[] coords = mesh.coords;
    Coord[] texCoords = mesh.texCoords;
    int[][][] faces = mesh.faces;
    int[] vertex;
    transform.worldRotation(wr);
    Normal[] normals = mesh.normals;

    r.pushStyle();
    material.drawStyle(r);
    for (int i = 0, sz0 = faces.length, j; i < sz0; ++i) {
      int sz1 = faces[i].length;
      r.beginShape(sz1 == 3 ? TRIANGLES :
        sz1 == 4 ? QUADS : POLYGON);
      material.draw(r);

      for (j = 0; j < sz1; ++j) {
        vertex = faces[i][j];
        v.set(coords[vertex[0]]);
        v.mult(transform);

        vt.set(texCoords[vertex[1]]);
        vt.mult(material);

        // If normal is not called, Processing
        // will auto-calculate normals.
        vn.set(normals[vertex[2]]);
        vn.mult(wr);
        r.normal(vn.x, vn.y, vn.z);
        r.vertex(v.x, v.y, v.z, vt.x, vt.y);
      }
      r.endShape(CLOSE);
    }
    r.popStyle();
    return this;
  }
}
