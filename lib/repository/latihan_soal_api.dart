import 'dart:io';

import 'package:dio/dio.dart';
import 'package:final_project/constant/api_url.dart';
import 'package:final_project/helpers/user_email.dart';
import 'package:final_project/models/network_response.dart';

class LatihanSoalApi {
  Dio dioApi() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      headers: {
        "x-api-key": ApiUrl.apiKey,
        HttpHeaders.contentTypeHeader: "application/json",
      },
      responseType: ResponseType.json,
    );
    final dio = Dio(options);
    return dio;
  }

  Future<NetworkResponse> _getRequest({endpoint, param}) async {
    try {
      final dio = dioApi();
      final result = await dio.get(endpoint, queryParameters: param);
      return NetworkResponse.success(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponse.error(data: null, message: "response timeout");
      }
      return NetworkResponse.error(data: null, message: "response error dio");
    } catch (e) {
      return NetworkResponse.error(data: null, message: " other error");
    }
  }

  Future<NetworkResponse> _postRequest({endpoint, body}) async {
    try {
      final dio = dioApi();
      final result = await dio.post(endpoint, data: body);
      return NetworkResponse.success(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponse.error(data: null, message: "response timeout");
      }
      return NetworkResponse.error(data: null, message: "response error dio");
    } catch (e) {
      return NetworkResponse.error(data: null, message: " other error");
    }
  }

// pemanggilan appi get mapel
  Future<NetworkResponse> getMapel() async {
    final result = await _getRequest(
      endpoint: ApiUrl.latihanMapel,
      param: {
        "major_name": "IPA",
        "user_email": UserEmail.getUserEmail(),
      },
    );
    return result;
  }

  // pemanggilan appi get paket soal
  Future<NetworkResponse> getPaketSoal(id) async {
    final result = await _getRequest(
      endpoint: ApiUrl.latihanPaketSoal,
      param: {
        "course_id": id,
        "user_email": UserEmail.getUserEmail(),
      },
    );
    return result;
  }

  // pemanggilan appi get mapel
  Future<NetworkResponse> getBanner() async {
    final result = await _getRequest(
      endpoint: ApiUrl.banner,
      // param: {
      //   "limit": "IPA",
      // },
    );
    return result;
  }

  // mengambil soal berdasarkan id
  Future<NetworkResponse> postQuestionList(id) async {
    final result = await _postRequest(
      endpoint: ApiUrl.latihanKerjakanSoal,
      body: {
        "exercise_id": id,
        "user_email": UserEmail.getUserEmail(),
      },
    );
    return result;
  }

  // mengambil jawaban user
  Future<NetworkResponse> postStudentAnswer(payload) async {
    final result = await _postRequest(
      endpoint: ApiUrl.latihanSubmitJawaban,
      body: payload,
    );
    return result;
  }
}
