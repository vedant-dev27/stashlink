class ListModel {
  const ListModel({
    required this.title,
    required this.url,
    this.thumbnail,
  });

  final String title;
  final String url;
  final String? thumbnail;
}
