interface Easing < T extends Transformable < T > > {
  T apply(T a, T b, Float t, T out);
  T apply(T[] arr, Float t, T out);
  T applyUnclamped(T a, T b, float t, T out);
}

abstract class EasingSource < T extends Transformable < T > >
  implements Easing < T >, 
  TriFunction < T[], Float, T, T >, 
  QuadFunction < T, T, Float, T, T > {

  T apply(T a, T b, Float t, T out) {
    if (t <= 0.0) {
      return out.set(a);
    }
    if (t >= 1.0) {
      return out.set(b);
    }
    return applyUnclamped(a, b, t, out);
  }

  T apply(T[] arr, Float t, T out) {
    int sz = arr.length;
    if (sz == 1 || t <= 0.0) { 
      return out.set(arr[0]);
    }
    int j = sz - 1;
    if (t >= 1.0) { 
      return out.set(arr[j]);
    }
    float sclt = t * j;
    int i = int(sclt);
    // For safety, i + 1 could be min(i + 1, j).
    return applyUnclamped(arr[i], arr[i + 1], sclt - i, out);
  }

  abstract T applyUnclamped(T a, T b, float t, T out);
}
