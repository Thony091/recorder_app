
import 'dart:convert';

import 'package:recorder_app/infrastructure/models/user/reminder_model_response.dart';

UserDataFirestoreResponse userDataFirestoreResponseFromJson(String str) => UserDataFirestoreResponse.fromJson(json.decode(str));

String userDataFirestoreResponseToJson(UserDataFirestoreResponse data) => json.encode(data.toJson());

class UserDataFirestoreResponse {
    final List<ReminderModelResponse> reminders;

    UserDataFirestoreResponse({
        required this.reminders,
    });

    factory UserDataFirestoreResponse.fromJson(Map<String, dynamic> json) => UserDataFirestoreResponse(
        reminders: List<ReminderModelResponse>.from(json["reminders"].map((x) => ReminderModelResponse.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "reminders": List<dynamic>.from(reminders.map((x) => x.toJson())),
    };
}
