class Face {
  Vertex[] vertices;

  Face() {
  }

  Face(Vertex[] verts) {
    referTo(verts);
  }

  String toString() {
    StringBuilder sb = new StringBuilder();
    for (int i = 0, sz = vertices.length; i < sz; ++i) {
      sb.append(vertices[i].toString());
      sb.append("\n");
    }
    return sb.toString();
  }

  Face copyFrom(Face face) {
    return copyFrom(face.vertices);
  }

  Face copyFrom(Vertex[] verts) {
    int sz = verts.length;
    vertices = new Vertex[sz];
    for (int i = 0; i < sz; ++i) {
      vertices[i] = new Vertex();
      vertices[i].copyFrom(verts[i]);
    }
    return this;
  }

  Face referTo(Face face) {
    return referTo(face.vertices);
  }

  Face referTo(Vertex[] verts) {
    vertices = verts;
    return this;
  }
}
