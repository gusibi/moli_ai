class ChatInfoOutput {
  int id;
  String title;
  String convType;
  String prompt;
  String desc;
  int icon;
  int rank;
  String modelName;
  String? config;
  int lastTime;
  int memeoryCount;

  ChatInfoOutput(
      {required this.id,
      required this.title,
      required this.prompt,
      required this.convType,
      required this.desc,
      required this.icon,
      required this.rank,
      required this.modelName,
      this.config,
      required this.lastTime,
      this.memeoryCount = 6});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "prompt": prompt,
      "convType": convType,
      "desc": desc,
      "icon": icon,
      "rank": rank,
      "modelName": modelName,
      "config": config,
      "lastTime": lastTime
    };
  }

  ChatInfoOutput copy() {
    return ChatInfoOutput(
      id: id,
      title: title,
      convType: convType,
      desc: desc,
      icon: icon,
      prompt: prompt,
      modelName: modelName,
      config: config,
      rank: rank,
      lastTime: lastTime,
    );
  }
}
