class KrResponse {
  final String krAnswer;
  final String krAnswerType;
  final String krHash;
  final String krHashAlgorithm;

  KrResponse({
    required this.krAnswer,
    required this.krAnswerType,
    required this.krHash,
    required this.krHashAlgorithm
  });

  KrResponse.fromJson(Map<String, dynamic> json):
    krAnswer = json['kr-answer'],
    krAnswerType = json['kr-answer-type'],
    krHash = json['kr-hash'],
    krHashAlgorithm = json['kr-hash-algorithm'];

  Map<String, dynamic> toJson() => {
    'kr-answer': krAnswer,
    'kr-answer-type': krAnswerType,
    'kr-hash': krHash,
    'kr-hash-algorithm': krHashAlgorithm
  };
}
