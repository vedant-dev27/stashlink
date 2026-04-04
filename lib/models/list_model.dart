class ListModel {
  const ListModel({
    required this.title,
    required this.url,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
    title: json['title'] as String,
    url: json['url'] as String,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
  };

  final String title;
  final String url;
}
