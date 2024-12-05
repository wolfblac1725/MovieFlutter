import 'package:flutter/material.dart';
import 'package:movies_flutter/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;
  const MovieSlider({super.key, required this.movies, required this.onNextPage, this.title});


  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController _scrollController = ScrollController();
  void _notification() {
     if( _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500){
       widget.onNextPage();
     }

  }
  @override
  void initState() {
    _scrollController.addListener(_notification);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 290,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                  widget.title ?? "Populares",
                  style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
              )
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
                itemCount: widget.movies.length,
                itemBuilder: ( _, int index) => _MoviePoster(movie: widget.movies[index],)
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  const _MoviePoster({Key? key,required this.movie}):super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'silder-${movie.id}';
    return  Container(
      width: 130,
      height: 244,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          )
        ],
      )
    );
  }
}
