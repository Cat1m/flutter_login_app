import 'api_key_generator.dart';
import 'package:chopper/chopper.dart';

part 'api_service.chopper.dart';

@ChopperApi(baseUrl: 'https://his.dev.honghunghospital.com.vn/')
abstract class ApiService extends ChopperService {
  @Post(path: 'dkkb/login')
  Future<Response> login(@Body() Map<String, dynamic> body);

  static ApiService create() {
    final client = ChopperClient(
      services: [_$ApiService()],
      converter: const FormUrlEncodedConverter(),
      interceptors: [
        HeadersInterceptor({
          'token': ApiKeyGenerator.getAPIKey(),
        }),
      ],
    );
    return _$ApiService(client);
  }
}
