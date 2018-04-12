abstract class DimEasing extends EasingSource < Dimension > {
  abstract Dimension applyUnclamped(Dimension a, 
    Dimension b, float t, Dimension out);
}

class DimLerp extends DimEasing {
  Dimension applyUnclamped(Dimension a, Dimension b, float t, 
    Dimension out) {
    float u = 1.0 - t;
    out.set(u * a.w + t * b.w, 
      u * a.h + t * b.h, 
      u * a.d + t * b.d);
    return out;
  }
}

class DimSmootherStep extends DimLerp {
  Dimension evalUnclamped(Dimension a, Dimension b, float t, 
    Dimension out) {
    return super.applyUnclamped(a, b, t * t * t * (t *
      (t * 6.0 - 15.0) + 10.0), out);
  }
}
