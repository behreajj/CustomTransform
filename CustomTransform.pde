int kfcount = 6;
PGraphics3D renderer;
Transform world;
Entity entity;
TransformEasing easing = new TransformEasing(
  new TupleEaseIn(), 
  new QuatSlerp(), 
  new DimSmootherStep());
Transform[] keyframes = new Transform[kfcount];
Vertex[] vertices, originals, deformed;

void setup() {
  size(512, 288, P2D);
  background(0xffffffff);

  // createGraphics returns the interface PGraphics,
  // which must be cast to the specific class.
  // (1920 x 1080) = (512 x 288) * 3.75
  renderer = (PGraphics3D)createGraphics(1920, 1080, P3D);
  renderer.smooth(8);

  // To simply future transforms, create a transform
  // the size of the sketch.
  Coord t = new Coord(renderer.width * 0.5, renderer.height * 0.5);
  Quaternion r = new Quaternion();
  Dimension s = new Dimension(min(t.x, t.y));
  Transform world = new Transform(t, r, s);

  // Load .obj file into mesh.
  Mesh mesh = new Mesh();
  mesh.fromObj("suzanne.obj");

  // Acquire vertices.
  // Use an anonymous comparator to sort them.
  vertices = mesh.getVertices(new Comparator < Vertex > () {
    public int compare(Vertex a, Vertex b) {
      return a.coord.y > b.coord.y ? 1 :
        a.coord.y < b.coord.y ? - 1 : 0;
    }
  }
  );

  // Loop through vertices and make two copies.
  // The deformed copy is multiplied by noise.
  int sz = vertices.length;
  originals = new Vertex[sz];
  deformed = new Vertex[sz];
  for (int i = 0; i < sz; ++i) {
    originals[i] = new Vertex();
    deformed[i] = new Vertex();

    originals[i].copyFrom(vertices[i]);
    deformed[i].copyFrom(vertices[i]);

    float noise = 0.25 + 0.75 *
      noise(System.currentTimeMillis(), i);
    deformed[i].coord.mult(noise);
  }

  // Load image, then supply it to material as texture.
  PImage txtr = loadImage("txtr7.png");
  TextureMaterial material = new TextureMaterial(txtr);
  material.scaleTo(3.0);

  // Create a transform, then make it a child of the world.
  Transform transform = new Transform();
  transform.parent = world;

  // Create a new entity.
  entity = new Entity(transform, material, mesh);

  // Initialize keyframes.
  for (int i = 0; i < kfcount; ++i) {
    t.set(random(-1.0, 1.0), random(-1.0, 1.0));
    r.random();
    s.set(random(0.25, 0.75));
    keyframes[i] = new Transform(t, r, s);
  }
}

void draw() {

  // Display frame rate in title. Show only one place
  // right of the decimal point.
  surface.setTitle(String.format("%.1f", frameRate));

  // Ease entity's transform between key frames.
  float t = mouseX / float(width);
  entity.material.fill = lerpColor(0xffff003f, 0xffff3f00, t);
  easing.apply(keyframes, t, entity.transform);

  // Ease vertices of mesh data.
  int sz = vertices.length;
  float imax = 1.0 / float(sz - 1);
  float u = 0.5 + 0.5 * cos(frameCount * 0.01);
  for (int i = 0; i < sz; ++i) {
    easing.tEasing.apply(originals[i].coord, deformed[i].coord, 
      (u + i * imax) % 1.0, vertices[i].coord);
  }

  // Draw renderer.
  renderer.beginDraw();
  renderer.background(0x10ffffff);
  renderer.directionalLight(
    255.0, 255.0, 255.0, 
    0.0, 0.8, -0.6);
  entity.draw(renderer);
  renderer.endDraw();
  renderer.flush();

  // Blit renderer onto sketch renderer.
  image(renderer, 0.0, 0.0, width, height);
}

void keyReleased(KeyEvent ke) {
  if (keyCode == 83) {
    entity.mesh.toObj(String.format("exports/%d.obj", 
      System.currentTimeMillis()));
  }

  if (keyCode == 65) {
    renderer.save(String.format("screenCaps/%d.png", 
      System.currentTimeMillis()));
  }
}

void mouseReleased(MouseEvent me) {
  if (mouseButton == LEFT) {
    randomizeKeyframes();
  } else if (mouseButton == RIGHT) {
  }
}

void randomizeKeyframes() {
  for (int i = 0; i < kfcount; ++i) {
    keyframes[i].set(
      new Coord(random(-1.0, 1.0), random(-1.0, 1.0)), 
      new Quaternion().random(), 
      new Dimension(random(0.25, 0.75)));
  }
}
