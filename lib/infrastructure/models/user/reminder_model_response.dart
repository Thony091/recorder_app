
class ReminderModelResponse {
    final int id;
    final String title;
    final String description;
    final String time;
    final String frequency;
    final String status;

    ReminderModelResponse({
        required this.id,
        required this.title,
        required this.description,
        required this.time,
        required this.frequency,
        required this.status,
    });

    factory ReminderModelResponse.fromJson(Map<String, dynamic> json) => ReminderModelResponse(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        time: json["time"],
        frequency: json["frequency"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "time": time,
        "frequency": frequency,
        "status": status,
    };
}
