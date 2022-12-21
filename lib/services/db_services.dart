import 'dart:convert';

import 'package:http/http.dart' as http;
import '../const/api_const.dart';
import 'db_base.dart';

class DBService implements DBBase {
  @override
  Future allCourses() async {
    final response = await http.get(
      Uri.parse(companyUrl + '/admin/quizapp/courses'),
      headers: {'Accept': 'application/json', 'Cookie': loginCookie},
    );
    return json.decode(response.body);
  }

  @override
  Future getCourseSubject(int id) async {
    try{
    final response = await http.get(
      Uri.parse(companyUrl + '/admin/quizapp/course_subject/$id'),
      headers: {'Accept': 'application/json', 'Cookie': loginCookie},
    );
    return List<Map>.from(json.decode(response.body));
    }catch(e){
      return e;
    }
  }

  @override
  Future getCourseSubjectQuestion(int id) async {
    print(id);
    final response = await http.get(
      Uri.parse(companyUrl + '/admin/create_quiz_app_test/test_api/$id'),
      headers: {'Accept': 'application/json', 'Cookie': loginCookie},
    );
    var question=json.decode(response.body);

    return question[0];
  }

}