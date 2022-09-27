class Feeding {
  final int? id;
  final String name;
  final String description;
  final double durationSeconds;

  Feeding(
    this.name,
    this.description,
    this.durationSeconds, [this.id]
  );

  Feeding.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        durationSeconds = json['durationSeconds'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'durationSeconds': durationSeconds,
      };
}
