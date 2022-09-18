// #docregion import
import 'package:vector_math/vector_math.dart';
// #enddocregion import

void test() {
  Vector3 x = Vector3.zero();
  Vector4 y = Vector4.all(4.0);
  x.zyx = y.xzz;
}
