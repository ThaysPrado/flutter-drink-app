import 'package:drink_app/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:drink_app/models/drink_option.dart';
import 'package:drink_app/widgets/drink_details.dart';

class ListDrinks extends StatefulWidget {
  final String search;
  final String title;
  ListDrinks({Key key, @required this.search, this.title}): super(key: key);
  _ListDrinksState createState() => _ListDrinksState();
}

class _ListDrinksState extends State<ListDrinks> {

  Future<List<DrinkOption>> _getDrinkOptions() async {
    return Repository().getDrinkOptions(widget.search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: FutureBuilder<List<DrinkOption>>(
        future: _getDrinkOptions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data.map((drink) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(drink.strDrinkThumb),
                  ),
                  title: Text(drink.strDrink),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: DrinkDetails(id: drink.idDrink, drinkName: drink.strDrink,),
                      ),
                    );
                },
                ))
            .toList(),
          );
        },
      ),
    );
  }
}