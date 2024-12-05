import 'package:flutter/material.dart';
import 'package:movies_flutter/models/movie.dart';
import 'package:movies_flutter/widgets/casting_cards.dart';


class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie: movie,),
          SliverList(
              delegate: SliverChildListDelegate([
                _PosterAndTitle(movie: movie),
                _Overview(movie: movie,),
                CastingCards(movie_id: movie.id,)
              ])
          )
        ],

      )
    );
  }
}
class _CustomAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomAppBar({Key? key,required this.movie}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFFE8DEF8),
      expandedHeight: 200,
      floating: false,
      pinned: true,
      iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            color: Colors.black12,
            child:
            Text(
                movie.title,
                style: const TextStyle(color: Colors.white,fontSize: 16),
                textAlign: TextAlign.center,
            )
        ),
        background:FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
      elevation: 10,
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  const _PosterAndTitle({Key? key,required this.movie}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final  textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image:  NetworkImage(movie.fullPosterImg),
                height: 150,
              ),
            ),
          ),
          const SizedBox(width: 20,),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 170),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  movie.originalTitle,
                  style: textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.star_outline,size: 15,color: Colors.grey,),
                    const SizedBox(width: 8),
                    Text(movie.voteAverage.toString(),style: textTheme.labelSmall)

                  ],
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}
class _Overview extends StatelessWidget {
  final Movie movie;
  const _Overview({Key? key,required this.movie}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(16),
      child: Text(
          movie.overview,
          textAlign: TextAlign.justify,
      ),
    );
  }
}


