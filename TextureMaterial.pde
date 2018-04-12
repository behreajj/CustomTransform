class TextureMaterial extends Material {

  // Options: NORMAL, IMAGE
  // NORMAL is strongly recommended.
  int textureMode = NORMAL;

  // Options: CLAMP, REPEAT.
  // If texture smoothing is on, then artifacts will appear
  // on the edges of the sprite. Padding can be added to the
  // source images as a workaround.
  int textureWrap = REPEAT;
  
  PImage texture;

  TextureMaterial(PImage texture) {
    super();
    this.texture = texture;
  }

  TextureMaterial(PImage texture, int textureMode, int textureWrap) {
    super();
    this.texture = texture;
    this.textureMode = textureMode;
    this.textureWrap = textureWrap;
  }

  TextureMaterial(Coord position, float angle, Vector axis, 
    Dimension scale, PImage texture, int textureMode, int textureWrap) {
    super(position, angle, axis, scale);
    this.texture = texture;
    this.textureMode = textureMode;
    this.textureWrap = textureWrap;
  }

  TextureMaterial(Coord position, Quaternion rotation, Dimension scale, 
    PImage texture, int textureMode, int textureWrap) {
    super(position, rotation, scale);
    this.texture = texture;
    this.textureMode = textureMode;
    this.textureWrap = textureWrap;
  }

  TextureMaterial drawStyle(PGraphics3D r) {
    super.drawStyle(r);
    r.textureMode(textureMode);
    r.textureWrap(textureWrap);
    return this;
  }

  TextureMaterial draw(PGraphics3D r) {
    if (noFill) {
      r.noFill();
    } else {
      r.tint(fill);
      r.texture(texture);
    }
    return this;
  }

  TextureMaterial set(Coord position, 
    float angle, Vector axis, Dimension scale, PImage texture, 
    int textureMode, int textureWrap) {
    super.set(position, angle, axis, scale);
    this.texture = texture;
    this.textureMode = textureMode;
    this.textureWrap = textureWrap;
    return this;
  }

  TextureMaterial set(Coord position, Quaternion rotation, 
    Dimension scale, PImage texture, int textureMode, int textureWrap) {
    super.set(position, rotation, scale);
    this.texture = texture;
    this.textureMode = textureMode;
    this.textureWrap = textureWrap;
    return this;
  }
}
