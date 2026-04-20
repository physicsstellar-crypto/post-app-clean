import 'package:dartz/dartz.dart';
import 'package:flutter_posts_app/core/error/failures.dart';
import 'package:flutter_posts_app/features/posts/domain/repositories/posts_repository.dart';

import '../entities/post.dart';

class getAllPostsUsercase{
  final PostsRepository repository;

  getAllPostsUsercase(this.repository);

  Future<Either<Failure, List<Post>>> call() async{
    return await repository.getAllPosts();
  }
}