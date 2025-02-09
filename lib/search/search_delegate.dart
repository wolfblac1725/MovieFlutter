import 'package:flutter/material.dart';
import 'package:movies_flutter/models/Models.dart';
import 'package:movies_flutter/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {

  @override
  String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () => query = '',
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context,null);
        },
        icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('buildResults');
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(Icons.movie_creation_outlined,color: Colors.black38,size: 100,),
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      _emptyContainer();
    }
    final moviesProvider = Provider.of<MovieProvider>(context,listen: false);
    moviesProvider.getSearchMovie(query);

    return StreamBuilder(
      stream: moviesProvider.queryStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();
        final movies = snapshot.data!;
        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) => _SuggestionItem(movie: movies[index])
        );
      },
    );
  }
}
class _SuggestionItem extends StatelessWidget {
  final Movie movie;
  const _SuggestionItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap:(){
        Navigator.pushNamed(context, 'details',arguments: movie);
      }
    );
  }
}


