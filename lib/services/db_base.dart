abstract class DBBase {
  Future<dynamic> allCourses(); //Bütün Dersler

  Future<dynamic> getCourseSubject(int id); //Derslerin konuları

  Future<dynamic> getCourseSubjectQuestion(int id); //Konularının tüm sorunları
}