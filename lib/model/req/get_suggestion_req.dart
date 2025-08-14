class GetSuggestionReq {
  final String client;
  final String ds;
  final String q;

  GetSuggestionReq({
    required this.client,
    required this.ds,
    required this.q,
  });

  Map<String, dynamic> toMap() {
    return {
      'client': client,
      'ds': ds,
      'q': q
    };
  }
}
