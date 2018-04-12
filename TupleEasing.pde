abstract class TupleEasing extends EasingSource < Tuple > {
  abstract Tuple applyUnclamped(Tuple a, Tuple b, float t, Tuple out);
}

class TupleLerp extends TupleEasing {
  Tuple applyUnclamped(Tuple a, Tuple b, float t, Tuple out) {
    float u = 1.0 - t;
    out.set(u * a.x + t * b.x, 
      u * a.y + t * b.y, 
      u * a.z + t * b.z);
    return out;
  }
}

class TupleEaseIn extends TupleLerp {
  float exp = 1.675;

  TupleEaseIn() {
  }

  TupleEaseIn(float exponent) { 
    exp = exponent;
  }

  Tuple applyUnclamped(Tuple a, Tuple b, float t, Tuple out) {
    return super.applyUnclamped(a, b, pow(t, exp), out);
  }
}

class TupleEaseOut extends TupleLerp {
  float exp = 1.675;

  TupleEaseOut() {
  }

  TupleEaseOut(float exponent) { 
    exp = exponent;
  }

  Tuple applyUnclamped(Tuple a, Tuple b, float t, Tuple out) {
    return super.applyUnclamped(a, b, 
      1.0 - pow(1.0 - t, exp), out);
  }
}
