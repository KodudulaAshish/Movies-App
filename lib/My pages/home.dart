import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movies',
          style: GoogleFonts.mavenPro(),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const SafeArea(child: MoviesLayout()),
    );
  }
}

Future getMovies(String type, List<MovieCard> myMovies) async {
  const urlBase1 = 'https://api.themoviedb.org/3/movie/';
  const urlBase2 =
      '?api_key=38b8d2bcefa0333cdf8237e6be700817&language=en-US&page=1';

  var response = await http.get(Uri.parse(urlBase1 + type + urlBase2));
  if (response.statusCode == 200) {
    var rawList = response.body;
    var movieList = jsonDecode(rawList)['results'];
    for (var movie in movieList) {
      var newCard = MovieCard(
          imageURL: movie['poster_path'],
          title: movie['title'],
          rating: movie['vote_average']);
      myMovies.add(newCard);
      debugPrint(myMovies.length.toString());
    }
  }
}

class MovieCard {
  final String imageURL;
  final String title;
  final double rating;
  MovieCard(
      {Key? key,
      required this.imageURL,
      required this.title,
      required this.rating});
}

class MoviesLayout extends StatelessWidget {
  const MoviesLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Now Playing',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                )),
            NowPlayingMovies(),
            Text('Popular Movies',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                )),
            PopularMovies(),
            Text('Top Rated',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                )),
            TopRated(),
            Text('Up Coming',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                )),
            UpComingMovies(),
          ],
        ),
      ),
    );
  }
}

class PopularMovies extends StatelessWidget {
  final List<MovieCard> myMovies = [];
  PopularMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMovies('popular', myMovies),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              height: 330,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myMovies.length,
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(color: Colors.red, width: 2),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${myMovies[index].imageURL}',
                          height: 250,
                        ),
                      ),
                      Text(myMovies[index].title,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Try again, some error occured'),
            );
          }
        });
  }
}

class TopRated extends StatelessWidget {
  final List<MovieCard> myMovies = [];
  TopRated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMovies('top_rated', myMovies),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              height: 330,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myMovies.length,
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${myMovies[index].imageURL}',
                          height: 250,
                        ),
                      ),
                      Text(myMovies[index].title,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Try again, some error occured'),
            );
          }
        });
  }
}

class UpComingMovies extends StatelessWidget {
  final List<MovieCard> myMovies = [];
  UpComingMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMovies('upcoming', myMovies),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              height: 330,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myMovies.length,
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${myMovies[index].imageURL}',
                          height: 250,
                        ),
                      ),
                      Text(myMovies[index].title,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Try again, some error occured'),
            );
          }
        });
  }
}

class NowPlayingMovies extends StatelessWidget {
  final List<MovieCard> myMovies = [];
  NowPlayingMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMovies('now_playing', myMovies),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              height: 330,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myMovies.length,
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${myMovies[index].imageURL}',
                          height: 250,
                        ),
                      ),
                      Text(myMovies[index].title,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Try again, some error occurred'),
            );
          }
        });
  }
}
