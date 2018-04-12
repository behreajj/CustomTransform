abstract class Material extends TransformSource {
  boolean noFill = false;

  color ambient = 0xff000000;
  color emissive = 0xff000000;
  color fill = 0xffffffff;
  color specular = 0xff000000;
  color stroke = 0xff000000;

  float shininess = 1.0;
  float strokeWeight = 0.0;

  Material() {
    super();
  }

  Material(Coord position, float angle, Vector axis, 
    Dimension scale) {
    super(position, angle, axis, scale);
  }

  Material(Coord position, Quaternion rotation, Dimension scale) {
    super(position, rotation, scale);
  }

  // To be called between push- and popStyle.
  Material drawStyle(PGraphics3D r) {
    r.strokeWeight(strokeWeight);
    r.stroke(stroke);
    r.shininess(shininess);
    r.ambient(ambient);
    r.emissive(emissive);
    r.specular(specular);
    return this;
  }

  // To be called within beginShape.
  Material draw(PGraphics3D r) {
    if (noFill) {
      r.noFill();
    } else {
      r.fill(fill);
    }
    return this;
  }
}
