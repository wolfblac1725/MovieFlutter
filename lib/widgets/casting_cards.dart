import 'package:flutter/material.dart';
import 'package:movies_flutter/models/models.dart';
import 'package:movies_flutter/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movie_id;
  const CastingCards({Key? key,required this.movie_id}): super (key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MovieProvider>(context,listen: false);
    
    return FutureBuilder(
        future: moviesProvider.getMovieCast(movie_id),
        builder: (_,AsyncSnapshot<List<Cast>> snapshot) {
          if(!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              width: double.infinity / 4,
              height: 180,
              child: CircularProgressIndicator(),
            );
          }
          final cast = snapshot.data!;
          return Container(
              margin: const EdgeInsets.only(bottom: 30,left: 16,right: 16),
              width: double.infinity,
              height: 180,
              child: ListView.builder(
                itemCount: cast.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) => _CastCard(cast: cast[index],),
              )
          );
        }
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast cast;
  const _CastCard({Key? key,required this.cast}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.only(right: 16),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:  FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(cast.fullProfilePath),
                height: 140,
                width: 100,
                fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}

