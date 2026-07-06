import 'package:dio/dio.dart';

import '../models/recipe_model.dart';
import 'api_constants.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<RecipeResponse> fetchRecipes() async {
    try {
      final response = await _dio.get(
        ApiConstants.recipes,
        queryParameters: {'limit': 0},
      );
      if (response.statusCode == 200 && response.data != null) {
        return RecipeResponse.fromJson(response.data as Map<String, dynamic>);
      }
      throw ApiException(
        'Failed to load recipes (status ${response.statusCode}).',
      );
    } on DioException catch (e) {
      throw ApiException(_messageForDioException(e));
    }
  }

  String _messageForDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The connection timed out. Please check your internet and try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network and try again.';
      case DioExceptionType.badResponse:
        return 'Server error (${e.response?.statusCode}). Please try again later.';
      case DioExceptionType.cancel:
        return 'The request was cancelled.';
      default:
        return 'Something went wrong while fetching recipes. Please try again.';
    }
  }
}
