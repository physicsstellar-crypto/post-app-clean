import 'package:flutter_posts_app/features/posts/domain/entities/post.dart';

class postmodel extends Post {
   postmodel({
    required int id,
     required String title,
      required String body
   }) :super(id: id, title: title, body: body);


  factory postmodel.fromjson(Map<String, dynamic>json) {

    return postmodel(
      id: json['id'],
       title: json['title'],
        body: json['body'],
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
       'title': title,
        'body': body
    };
  }
}
