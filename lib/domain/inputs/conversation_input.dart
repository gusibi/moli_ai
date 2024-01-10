class ConversationListInput {
  int pageSize;
  int pageNum;

  ConversationListInput({
    required this.pageSize,
    required this.pageNum,
  });

  Map<String, dynamic> toMap() {
    return {
      "pageSize": pageSize,
      "pageNum": pageNum,
    };
  }

  ConversationListInput copy() {
    return ConversationListInput(
      pageNum: pageNum,
      pageSize: pageSize,
    );
  }
}
