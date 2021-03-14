import 'dart:math' as Math;

class MapController {
  double calculatePolygonArea(List coordinates) {
    double area = 0;

    if (coordinates.length > 2) {
      for (var i = 0; i < coordinates.length - 1; i++) {
        var p1 = coordinates[i];
        var p2 = coordinates[i + 1];
        area += convertToRadian(p2.longitude - p1.longitude) *
            (2 +
                Math.sin(convertToRadian(p1.latitude)) +
                Math.sin(convertToRadian(p2.latitude)));
      }

      area = area * 6378137 * 6378137 / 2;
    }

    return area.abs() * 0.000247105; //sq meters to Acres
  }

  double convertToRadian(double input) {
    return input * Math.pi / 180;
  }
}
