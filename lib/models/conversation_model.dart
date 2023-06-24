class ConversationMessageModel {
  final int id;
  final int conversationId;
  final String role;
  final String message;
  final int replyId;
  final int vote;
  final String ctime;

  const ConversationMessageModel({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.message,
    required this.replyId,
    required this.vote,
    required this.ctime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'role': role,
      "message": message,
      "replyId": replyId,
      "vote": vote,
      "ctime": ctime
    };
  }
}

class ConversationModel {
  int id;
  String title;
  String prompt;
  String desc;
  int icon;
  int rank;
  String modelName;
  int lastTime;

  ConversationModel({
    required this.id,
    required this.title,
    required this.prompt,
    required this.desc,
    required this.icon,
    required this.rank,
    required this.modelName,
    required this.lastTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "prompt": prompt,
      "desc": desc,
      "icon": icon,
      "rank": rank,
      "modelName": modelName,
      "lastTime": lastTime
    };
  }

  ConversationModel copy() {
    return ConversationModel(
      id: id,
      title: title,
      desc: desc,
      icon: icon,
      prompt: prompt,
      modelName: modelName,
      rank: rank,
      lastTime: lastTime,
    );
  }
}
