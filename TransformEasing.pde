class TransformEasing extends EasingSource < TransformSource > {
  TupleEasing tEasing;
  QuatEasing rEasing;
  DimEasing sEasing;

  TransformEasing() {
    this(new TupleLerp(), new QuatSlerp(), new DimLerp());
  }

  TransformEasing(TupleEasing tEasing, QuatEasing rEasing, 
    DimEasing sEasing) {
    set(tEasing, rEasing, sEasing);
  }

  TransformSource applyUnclamped(TransformSource a, TransformSource b, 
    float t, TransformSource out) {
    tEasing.applyUnclamped(a.position, b.position, t, 
      out.position);
    sEasing.applyUnclamped(a.scale, b.scale, t, out.scale);
    rEasing.applyUnclamped(a.rotation, b.rotation, t, out.rotation);
    return out;
  }

  TransformEasing set(TupleEasing tEasing, QuatEasing rEasing, 
    DimEasing sEasing) {
    this.tEasing = tEasing;
    this.rEasing = rEasing;
    this.sEasing = sEasing;
    return this;
  }
}
