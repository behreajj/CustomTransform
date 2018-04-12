import java.util.Comparator;
import java.util.Arrays;
import java.util.Calendar;

@FunctionalInterface
  interface TriFunction < T, U, V, R > {
  R apply(T t, U u, V v);
}

@FunctionalInterface
  interface QuadFunction < T, U, V, W, R > {
  R apply(T t, U u, V v, W w);
}

interface Transformable < T > extends Comparable < T > {
  int compareTo(T t);
  boolean approx(T t);
  T reset();
  T set(T t);
}

// http://floating-point-gui.de/errors/comparison/
boolean approximates(float a, float b, float tolerance) {
  if (a == b) {
    return true;
  }

  final float diff = abs(a - b);
  if (a == 0 || b == 0 || diff < Float.MIN_NORMAL) {
    return diff < tolerance * Float.MIN_NORMAL;
  }

  final float absA = abs(a);
  final float absB = abs(b);
  return diff / min(absA + absB, Float.MAX_VALUE) < tolerance;
}

float floorMod(float a, float b) {
  return a - b * floor(a / b);
}
