class Achievement {
  final String label;
  final String type;
  final int steps;
  final int value;

  const Achievement(
      {required this.label,
      required this.type,
      required this.steps,
      required this.value});

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
        label: json['label'] as String,
        type: json['type'] as String,
        steps: json['steps'] as int,
        value: json['value'] as int);
  }
}
