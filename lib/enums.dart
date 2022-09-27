enum ConnectionStatus { connected, offline, error }

enum Day {
  monday(displayText: "Mon"),
  tuesday(displayText: "Tue"),
  wednesday(displayText: "Wed"),
  thursday(displayText: "Thu"),
  friday(displayText: "Fri"),
  saturday(displayText: "Sat"),
  sunday(displayText: "Sun");

  const Day({
    required this.displayText,
  });

  final String displayText;

  String toJson() => name;
  static Day fromJson(String json) => values.byName(json);
}
