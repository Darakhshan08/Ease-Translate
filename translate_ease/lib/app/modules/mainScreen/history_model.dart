class History {

  final int id;
  final String message;
  final String message_language;
  final String translation_language;
  final String translation;
  late final int isFavorite;
  final String side;
  String? createdAt;
  String? updatedAt;

  History(
      {
      required this.id,
      required this.message,
      required this.message_language,
      required this.translation_language,
      required this.translation,
      required this.isFavorite,
      required this.side,
      this.createdAt,
      this.updatedAt
      });

 

  
  factory History.fromSqfliteDatabase(Map<String, dynamic> map) => History(
        id: map['id']?.toInt() ?? 0,
        message: map['message']??'',
        message_language: map['message_language']??'',
        translation_language: map['translation_language']??'',
        translation: map['translation']??'',
        isFavorite: map['isFavorite']?.toInt() ?? 0,
        side: map['side']??'',
        createdAt: map['createdAt']
      );

}
