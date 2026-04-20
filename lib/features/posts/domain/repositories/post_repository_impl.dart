import 'package:dartz/dartz.dart';
import 'package:flutter_posts_app/core/error/exception.dart';
import 'package:flutter_posts_app/core/error/failures.dart';
import 'package:flutter_posts_app/core/error/network/network_info.dart';
import 'package:flutter_posts_app/features/posts/data/datasources/Post_Local_data_source.dart';
import 'package:flutter_posts_app/features/posts/data/datasources/Post_remote_data_source.dart';
import 'package:flutter_posts_app/features/posts/data/models/post_model.dart';
import 'package:flutter_posts_app/features/posts/domain/entities/post.dart';
import 'package:flutter_posts_app/features/posts/domain/repositories/posts_repository.dart';

typedef DeleteOrUpdateOrAddPost = Future <Unit> Function();
class PostsRepositoryImpl implements PostsRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl({required this.remoteDataSource,
   required this.localDataSource,
    required this.networkInfo});

    @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {

    if( await networkInfo.isConnected){
   try {
    final remotePosts = await remoteDataSource.getAllPosts();
    localDataSource.cachePosts(remotePosts);
    return Right(remotePosts);
   } on ServerException {
     return Left(ServerFailure());
   }
    }else{
      try {
        final localPosts = localDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return left(EmptyCacheFailure());   
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final postModel = postmodel(
    id: post.id,
     title: post.title,
      body: post.body,
      );

 return await _getMessage (() {
  return remoteDataSource.addPost(postModel);
 });
}

  @override
  Future<Either<Failure, Unit>> deletePost(int id) async {
     return await _getMessage (() {
  return remoteDataSource.deletePost(postId);
 });

  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final postModel = postmodel(
    id: post.id,
     title: post.title,
      body: post.body,
      );

 return await _getMessage (() {
  return remoteDataSource.updatePost(postModel);
 });
}

}
  
Future<Either<Failure, Unit>> _getMessage (
  DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
   if (await networkInfo.isConnected) {
    try {
      await deleteOrUpdateOrAddPost();
     return Right(unit);
    } on ServerException {
       return Left(ServerFailure());

    }
  }else{
    return Left(offlineFailure());

  }
}


 