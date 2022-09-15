import 'package:ca_example/data/api/user_api/user_api.dart';
import 'package:ca_example/data/models/user/album/album_model.dart';
import 'package:ca_example/data/models/user/album/thumbnail/thumbnail_model.dart';
import 'package:ca_example/data/models/user/photo/photo_model.dart';
import 'package:ca_example/data/models/user/post/post_model.dart';
import 'package:ca_example/data/models/user/user_model.dart';
import 'package:dio/dio.dart';

class UserService {
  final UserApi userApi = UserApi(Dio());

  Future<List<User>> getUsers() async {
    final List<User> listUsers = await userApi.getUsers();
    return listUsers;
  }

  Future<List<Post>> getUserPosts({required String userId}) async {
    final List<Post> listPosts = await userApi.getUserPosts(userId: userId);
    return listPosts;
  }

  Future<List<Album>> getUserAlbums({required String userId}) async {
    final List<Album> listAlbums = await userApi.getUserAlbums(userId: userId);
    return listAlbums;
  }

  Future<List<Photo>> getAlbumPhotos({required String albumId}) async {
    final List<Photo> listAlbums =
        await userApi.getAlbumPhotos(albumId: albumId);
    return listAlbums;
  }

  Future<List<Thumbnail>> getThumbnailList(
      {required List<Album> listAlbums}) async {
    List<Thumbnail> listTn = [];
    await Future.forEach(listAlbums, (Album album) async {
      List<Photo> listPhotos =
          await getAlbumPhotos(albumId: album.id.toString());
      listTn.add(
          Thumbnail(albumId: album.id, url: listPhotos.first.thumbnailUrl));
    });
    return listTn;
  }
}
