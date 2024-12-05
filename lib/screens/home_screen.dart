import 'package:flutter/material.dart';
import 'package:movies_flutter/providers/movie_provider.dart';
import 'package:movies_flutter/search/search_delegate.dart';
import 'package:movies_flutter/widgets/card_swiper.dart';
import 'package:movies_flutter/widgets/movie_slider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MovieProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Peliculas"),
        elevation: 10.0,
        actions: [
          IconButton(
              onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
              icon: const Icon(Icons.search_outlined)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.onNowMovie),
            MovieSlider(
              movies: moviesProvider.popularMovie,
              title: 'Populares',
              onNextPage: () {
                moviesProvider.getPopularMovies();
              },
            ),
          ],
        ),
      ),
    );
  }
}
