class Place {
  final String xid;
  final String name;
  final String kinds;
  final double dist;
  bool isFavorite;

  Place({
    required this.xid,
    required this.name,
    required this.kinds,
    required this.dist,
    this.isFavorite = false,
  });
}