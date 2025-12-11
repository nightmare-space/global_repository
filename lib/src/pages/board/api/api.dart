import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'models.dart';

part 'api.g.dart';

@RestApi(baseUrl: 'http://127.0.0.1:8000/api/v1/board', parser: Parser.JsonSerializable)
abstract class API {
  factory API(Dio dio, {String baseUrl}) = _API;
  // curl --location 'http://127.0.0.1:8000/api/v1/board/items?skip=0&limit=100'
  @GET('/items')
  Future<BoardItems> getBoardItems({
    @Query('skip') int skip = 0,
    @Query('limit') int limit = 1000,
  });

  // curl --location 'http://127.0.0.1:8000/api/v1/board/items/2431/like' \
// --header 'Content-Type: application/json' \
// --data '{
//     "user_identifier": "string"
// }'

  @POST('/items/{id}/like')
  Future<void> likeBoardItem(
    @Path('id') int id,
    @Body() Map<String, String?> body,
  );
}
