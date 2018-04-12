abstract class QuatEasing extends EasingSource < Quaternion > {
  abstract Quaternion applyUnclamped(Quaternion a, Quaternion b, 
    float t, Quaternion out);
}

class QuatNlerp extends QuatEasing {
  Quaternion applyUnclamped(Quaternion a, Quaternion b, 
    float t, Quaternion out) {
    float u = 1.0 - t;
    return out.set(u * a.x + t * b.x, 
      u * a.y + t * b.y, 
      u * a.z + t * b.z, 
      u * a.w + t * b.w).normalize();
  }
}

class QuatSlerp extends QuatEasing {
  Quaternion applyUnclamped(Quaternion a, Quaternion b, 
    float t, Quaternion out) {
    // Dot product = cos(t).
    float cos = a.dot(b);

    // Prefer the shortest distance by flipping
    // the destination's sign if cos(t) is negative.
    if (cos < 0.0) {
      out.set(-b.x, -b.y, -b.z, -b.w);
      cos = -cos;
    } else {
      out.set(b);
    }

    // If cosine is out of bounds, return the origin.
    if (cos >= 1.0) {
      return out.set(a).normalize();
    }

    float sin = sqrt(1.0 - cos * cos);
    if (abs(sin) < EPSILON) {
      return out.add(a).mult(0.5).normalize();
    }

    float theta = atan2(sin, cos);
    sin = 1.0 / sin;
    float u = sin((1.0 - t) * theta) * sin;
    float v = sin(t * theta) * sin;
    return out.set(u * a.x + v * b.x, 
      u * a.y + v * b.y, 
      u * a.z + v * b.z, 
      u * a.w + v * b.w).normalize();
  }
}
