
class Mesh {
  String name = "Mesh";

  int[][][] faces;
  Coord[] coords;
  Coord[] texCoords;
  Normal[] normals;

  Mesh() {
  }

  Mesh(int[][][] faces, Coord[] coords, 
    Coord[] texCoords, Normal[] normals) {
    referTo(name, faces, coords, texCoords, normals);
  }

  Mesh copyFrom(Mesh m) {
    return copyFrom(m.name, m.faces, m.coords, m.texCoords, m.normals);
  }

  Mesh copyFrom(String name, int[][][] faces, Coord[] coords, 
    Coord[] texCoords, Normal[] normals) {
    this.name = name;

    int sz = faces.length;
    this.faces = new int[sz][][];
    for (int i = 0, j, k; i < sz; ++i) {
      int sz1 = faces[i].length;
      this.faces[i] = new int[sz1][];
      for (j = 0; j < sz1; ++j) {
        int sz2 = faces[i][j].length;
        this.faces[i][j] = new int[sz2];
        for (k = 0; k < sz2; ++k) {
          this.faces[i][j][k] = faces[i][j][k];
        }
      }
    }

    sz = coords.length;
    this.coords = new Coord[sz];
    for (int i = 0; i < sz; ++i) {
      this.coords[i] = new Coord();
      this.coords[i].set(coords[i]);
    }

    sz = texCoords.length;
    this.texCoords = new Coord[sz];
    for (int i = 0; i < sz; ++i) {
      this.texCoords[i] = new Coord();
      this.texCoords[i].set(texCoords[i]);
    }

    sz = normals.length;
    this.normals = new Normal[sz];
    for (int i = 0; i < sz; ++i) {
      this.normals[i] = new Normal();
      this.normals[i].set(normals[i]);
    }

    return this;
  }

  Mesh fromObj(String filepath, Transform coordSystem, 
    Transform texCoordSystem) {
    fromObj(filepath);

    int sz = coords.length;
    for (int i = 0; i < sz; ++i) {
      coords[i].mult(coordSystem);
    }

    sz = texCoords.length;
    for (int i = 0; i < sz; ++i) {
      texCoords[i].mult(texCoordSystem);
    }

    sz = normals.length;
    for (int i = 0; i < sz; ++i) {
      normals[i].mult(coordSystem);
    }
    return this;
  }

  Mesh fromObj(String filepath) {
    String[] lines = loadStrings(filepath);
    String[] tokens;
    String[] facetokens;

    ArrayList < Coord > coords = new ArrayList < Coord > ();
    ArrayList < Coord > texCoords = new ArrayList < Coord > ();
    ArrayList < Normal > normals = new ArrayList < Normal > ();
    ArrayList < int[][] > faces = new ArrayList < int[][] > ();

    for (int i = 0, sz = lines.length, j; i < sz; ++i) {

      // Split line by spaces.
      tokens = lines[i].split("\\s+");

      // Skip empty lines.
      if (tokens.length > 0) {

        if (tokens[0].equals("o")) {

          // Assign name.
          name = tokens[1];
        } else if (tokens[0].equals("v")) {

          // Coordinate.
          Coord read = new Coord(
            float(tokens[1]), float(tokens[2]), float(tokens[3]));
          coords.add(read);
        } else if (tokens[0].equals("vt")) {

          // Texture coordinate.
          Coord read = new Coord(float(tokens[1]), float(tokens[2]));
          texCoords.add(read);
        } else if (tokens[0].equals("vn")) {

          // Normal.
          Normal read = new Normal(
            float(tokens[1]), float(tokens[2]), float(tokens[3]));
          normals.add(read);
        } else if (tokens[0].equals("f")) {

          // Face.
          int count = tokens.length;

          // tokens length includes "f", and so is 1 longer.
          int[][] indices = new int[count - 1][3];

          // Simplified version. Assumes (incorrectly) that face
          // will always be formatted as "v/vt/vn".
          for (j = 1; j < count; ++j) {
            facetokens = tokens[j].split("/");

            // Indices in .obj file start at 1, not 0.
            indices[j - 1][0] = int(facetokens[0]) - 1;
            indices[j - 1][1] = int(facetokens[1]) - 1;
            indices[j - 1][2] = int(facetokens[2]) - 1;
          }
          faces.add(indices);
        }
      }
    }

    // Convert to fixed-sized array.
    this.faces = faces.toArray(new int[faces.size()][][]);
    this.coords = coords.toArray(new Coord[coords.size()]);
    this.texCoords = texCoords.toArray(new Coord[texCoords.size()]);
    this.normals = normals.toArray(new Normal[normals.size()]);
    return this;
  }

  Face getFace(int i) {
    return getFace(i, new Face());
  }

  Face getFace(int i, Face out) {
    int sz = faces[i].length;
    Vertex[] vertices = new Vertex[sz];
    for (int j = 0; j < sz; ++j) {
      vertices[j] = getVertex(i, j, new Vertex());
    }
    return out.referTo(vertices);
  }

  Face[] getFaces() {
    int sz0 = faces.length;
    Face[] result = new Face[sz0];
    for (int i = 0, j, sz1; i < sz0; ++i) {
      sz1 = faces[i].length;
      Vertex[] verts = new Vertex[sz1];
      for (j = 0; j < sz1; ++j) {
        verts[j] = getVertex(i, j, new Vertex());
      }
      result[i] = new Face(verts);
    }
    return result;
  }

  Face[] getFaces(Comparator < Face > sortingMethod) {
    Face[] result = getFaces();
    Arrays.sort(result, sortingMethod);
    return result;
  }

  Vertex getVertex(int i, int j) {
    return getVertex(i, j, new Vertex());
  }

  Vertex getVertex(int i, int j, Vertex out) {
    return out.referTo(
      coords[faces[i][j][0]], 
      texCoords[faces[i][j][1]], 
      normals[faces[i][j][2]]);
  }

  Vertex[] getVertices() {
    ArrayList < Vertex > result = new ArrayList < Vertex > ();
    Vertex v;
    for (int i = 0, sz0 = faces.length, j, sz1; i < sz0; ++i) {
      for (j = 0, sz1 = faces[i].length; j < sz1; ++j) {
        v = getVertex(i, j, new Vertex());
        if (!result.contains(v)) {
          result.add(v);
        }
      }
    }
    return result.toArray(new Vertex[result.size()]);
  }

  Vertex[] getVertices(Comparator < Vertex > sortingMethod) {
    Vertex[] result = getVertices();
    Arrays.sort(result, sortingMethod);
    return result;
  }

  Mesh referTo(Mesh m) {
    return referTo(m.name, m.faces, m.coords, m.texCoords, m.normals);
  }

  Mesh referTo(String name, int[][][] faces, Coord[] coords, 
    Coord[] texCoords, Normal[] normals) {
    this.name = name;
    this.faces = faces;
    this.coords = coords;
    this.texCoords = texCoords;
    this.normals = normals;
    return this;
  }

  void toObj(String filename) {
    saveStrings(filename, toObjStrings());
    println(filename, "saved", Calendar.getInstance().getTime());
  }

  String[] toObjStrings() {
    int coordsLen = coords.length;
    int texCoordsLen = texCoords.length;
    int normalsLen = normals.length;
    int facesLen = faces.length;
    String[] result = new String[2 + 
      coordsLen + texCoordsLen + normalsLen + facesLen];

    result[0] = String.format("# v: %d, vt: %d, vn: %d, f: %d", 
      coordsLen, texCoordsLen, normalsLen, facesLen);
    result[1] = "o " + name;

    // Write coordinates.
    int offset = 2;
    for (int i = 0; i < coordsLen; ++i) {
      result[offset + i] = String.format("v %.6f %.6f %.6f", 
        coords[i].x, coords[i].y, coords[i].z);
    }

    // Write texture coordinates.
    offset += coordsLen;
    for (int i = 0; i < texCoordsLen; ++i) {
      result[offset + i] = String.format("vt %.6f %.6f", 
        texCoords[i].x, texCoords[i].y);
    }

    // Write normals.
    offset += texCoordsLen;
    for (int i = 0; i < normalsLen; ++i) {
      result[offset + i] = String.format("vn %.6f %.6f %.6f", 
        normals[i].x, normals[i].y, normals[i].z);
    }

    // Write face indices.
    StringBuilder sb;
    String faceFmt = "%d/%d/%d ";
    offset += normalsLen;
    for (int i = 0, j, vcount; i < facesLen; ++i) {
      sb = new StringBuilder("f ");
      for (j = 0, vcount = faces[i].length; j < vcount; ++j) {

        // Indices in .obj file start at 1, not 0.
        sb.append(String.format(faceFmt, 
          faces[i][j][0] + 1, faces[i][j][1] + 1, faces[i][j][2] + 1));
      }
      result[offset + i] = sb.toString();
    }
    return result;
  }
}
