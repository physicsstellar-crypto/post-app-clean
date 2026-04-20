import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_posts_app/core/error/exception.dart';
import 'package:flutter_posts_app/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  Future <List<postmodel>> getAllPosts ();
  Future<Unit> cachePosts(List<postmodel> postmodels);

  getCachedPosts() {}

}
const CACHED_POSTS = "CACHED_POSTS";

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<Unit> cachePosts(List<postmodel> postmodels) {
    List postModelstoJson = postmodels
    .map<Map<String,dynamic>>((postModel) =>postModel.toJson())
    .toList();
    sharedPreferences.setString("CACHED_POSTS", json.encode(postModelstoJson));
    return Future.value(unit);

  
  }

  @override
  Future<List<postmodel>> getCachedPosts() {
    final jsonString = sharedPreferences.getString(CACHED_POSTS);
    if(jsonString !=null) {
      List decodeJsonData = json.decode(jsonString);
      List<postmodel> jsontopostmodels = decodeJsonData
      .map<postmodel>((jsonpostmodel) =>postmodel.fromjson(jsonpostmodel))
      .toList();
      return Future.value(jsontopostmodels);
    }else{
      throw EmptyCacheException();

    }
   
  }
  
  @override
  Future<List<postmodel>> getAllPosts() {
     final jsonString = sharedPreferences.getString(CACHED_POSTS);
    if(jsonString !=null) {
      List decodeJsonData = json.decode(jsonString);
      List<postmodel> jsontopostmodels = decodeJsonData
      .map<postmodel>((jsonpostmodel) =>postmodel.fromjson(jsonpostmodel))
      .toList();
      return Future.value(jsontopostmodels);
    }else{
      throw EmptyCacheException();

    }
   
  }
}