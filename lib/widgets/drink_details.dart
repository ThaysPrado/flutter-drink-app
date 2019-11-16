import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drink_app/models/drink.dart';
import 'package:drink_app/resources/repository.dart';

class DrinkDetails extends StatefulWidget {
  final String id;
  final String drinkName;
  DrinkDetails({Key key, @required this.id, this.drinkName}): super(key: key);
  _DrinkDetailsState createState() => _DrinkDetailsState();
}

class _DrinkDetailsState extends State<DrinkDetails> {

  Future<Drink> _getDrinkDetails() async {
    return Repository().getDrinkDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.drinkName}'),
      ),
      body: FutureBuilder<Drink>(
        future: _getDrinkDetails(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: new ClipRRect(
                    borderRadius: new BorderRadius.circular(8.0),
                    child: new CachedNetworkImage(
                      imageUrl: snapshot.data.strDrinkThumb
                    ),
                  ),
                ),
                flex: 3,
              ),
              Expanded(
                child: new SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: new Text(
                      snapshot.data.strInstructions,
                      textAlign: TextAlign.justify,
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                flex: 4,
              ),
            ],
          );
        },
      ),
    );
  }
}