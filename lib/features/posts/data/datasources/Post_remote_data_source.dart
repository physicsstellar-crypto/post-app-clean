import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_posts_app/core/error/exception.dart';
import 'package:flutter_posts_app/features/posts/data/models/post_model.dart';
import 'package:http/http.dart' as http;

abstract class PostRemoteDataSource {
  Future<List<postmodel>> getAllPosts();
  Future<Unit> deletePost(int postId);
  Future<Unit>updatePost(postmodel postModel);
  Future<Unit>addPost(postmodel postModel);

}
const BASE_URL = "https://jsonplaceholder.typicode.com";

 class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSourceImpl({required this.client});
 @override
  Future<List<postmodel>> getAllPosts() async {
    final response = await client.get(
      Uri.parse(BASE_URL + "/posts/"),
      headers: {"Content-Type": "application/json"},
    );
    if(response.statusCode == 200) {
      final List decodeJson = json.decode(response.body) as List;
      final List <postmodel> postmodels = decodeJson
      .map<postmodel>((jsonpostmodel) => postmodel.fromjson(jsonpostmodel))
      .toList();

    return postmodels;
    }else{
      throw ServerException();
  }
}

@override
  Future<Unit> addPost(postmodel postModel) async {
    final body = {
      "title": postModel.title,
      "body" : postModel.body,
    };

    final respone = 
    await client.post(Uri.parse(BASE_URL + "/posts/"), body: body);
  if (respone.statusCode == 201) {
    return Future.value(unit);
  }else{
    throw ServerException();
  }
}

 
 
  @override
  Future<Unit> deletePost(int postId) async {
    final response = await client.delete
    (Uri.parse(BASE_URL+"/post/${postId.toString()}"),
    headers: {"Content-Type": "application/json"},
    );
    if(response.statusCode == 200) {
      return Future.value(unit);
    }else{
      throw ServerException();
    }
  
  }
  
 
 
  @override
  Future<Unit> updatePost(postmodel postModel) async {
    final postId = postModel.id.toString();
    final body = {
      "title" : postModel.title,
      "body" : postModel.body,
    };
    final response = await client.patch(
      Uri.parse(BASE_URL + "/posts/$postId"),
    );

    if(response.statusCode == 200) {
      return Future.value(unit);
    }else {
      throw ServerException();

    
    }

  
  }
  
 }