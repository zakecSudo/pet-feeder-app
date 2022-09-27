class Connection {
  final bool active;

  Connection({
    required this.active,
  });

  Connection.fromJson(Map<String, dynamic> json)
      : active = json['active'];

  Map<String, dynamic> toJson() => {
    'active': active,
  };
}