import 'package:dartz/dartz.dart';
import 'package:flutter_posts_app/core/error/failures.dart';
import 'package:flutter_posts_app/features/posts/domain/entities/post.dart';
import 'package:flutter_posts_app/features/posts/domain/repositories/posts_repository.dart';

class UpdatePostUsecase {
  final PostsRepository repository;

  UpdatePostUsecase(this.repository);

  Future<Either<Failure, Unit>> call (Post post) async {
    return await repository.updatePost(post);
  }
}