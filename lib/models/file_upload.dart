class FileUpload {
  final String name;
  final String path;
  final DateTime timestamp;

  FileUpload({
    required this.name,
    required this.path,
    required this.timestamp,
  });

  String get formattedDate =>
      '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}';
  String get displayName =>
      name.endsWith('.csv') ? name.substring(0, name.length - 4) : name;

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
        'timestamp': timestamp.toIso8601String(),
      };

  factory FileUpload.fromJson(Map<String, dynamic> json) => FileUpload(
        name: json['name'],
        path: json['path'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
