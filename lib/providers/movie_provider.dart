import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_flutter/helpers/debouncer.dart';
import 'package:movies_flutter/models/models.dart';
import 'package:movies_flutter/models/search_movie_response.dart';

class MovieProvider  extends ChangeNotifier {

  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '24b0da260f7f7479fe88810b509b6b8f';
  final String _language = 'es-ES';

  List<Movie> onNowMovie = [];
  List<Movie> popularMovie = [];

  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;

  final debouncer =
  Debouncer(
    duration: Duration(milliseconds: 500)
  );
  final StreamController<List<Movie>> _queryStreamController = StreamController.broadcast();
  Stream<List<Movie>> get queryStream => this._queryStreamController.stream;

   MovieProvider() {
     getOnDisplayMovies();
     getPopularMovies();
   }
  Future<String> _getJsonDataSinPage(String endPoint) async {
    var url =
    Uri.https(_baseUrl, endPoint, {
      'api_key': _apiKey,
      'language': _language,
    });
    final response = await http.get(url);
    return response.body;
  }
   Future<String> _getJsonData(String endPoint, [int page = 1]) async {
     var url =
     Uri.https(_baseUrl, endPoint, {
       'api_key': _apiKey,
       'language': _language,
       'page': page.toString()
     });
     final response = await http.get(url);
     return response.body;
   }
   getOnDisplayMovies() async {
     final jsonData = await _getJsonData('3/movie/now_playing');
     final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

     onNowMovie = nowPlayingResponse.results;
     notifyListeners();
   }
   getPopularMovies() async {
     _popularPage++;
     final jsonData = await _getJsonData('3/movie/popular',_popularPage);
     final popularResponse = PopularResponse.fromJson(jsonData);
     popularMovie.addAll(popularResponse.results);
     notifyListeners();
   }

   Future<List<Cast>> getMovieCast (int movie_id) async {
     if(movieCast.containsKey(movie_id))
       return movieCast[movie_id]!;

       final jsonData = await _getJsonDataSinPage('3/movie/$movie_id/credits');
       final creditsResponse = CreditsResponse.fromJson(jsonData);
       movieCast[movie_id] = creditsResponse.cast;
       return creditsResponse.cast;
   }

  Future<List<Movie>> getSearchMovie(String query) async {
     var url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
     });
     final response = await http.get(url);
     final searchMovieResponse = SearchMovieResponse.fromJson(response.body);
     return searchMovieResponse.results;
   }

   void getByQuery(String search) {
      debouncer.value = '';
      debouncer.onValue = (value) async {
        final results = await this.getSearchMovie(value);
        this._queryStreamController.add(results);
      };
      final timer = Timer.periodic(Duration(milliseconds: 300), (_){
        debouncer.value = search;
      });
      Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
   }

}