import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Some App',
      home: DrinkApp(),
      routes: <String, WidgetBuilder> {
        '/screen1': (BuildContext context) => new DrinkApp(),
        '/screen2': (BuildContext context) => new ListDrinks(),
        '/randomDrink': (BuildContext context) => new DrinkRandom(),
      }
    );
  }
}

class DrinkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Drinks';

    //final typesArr = ['Alcoholic', 'Non_Alcoholic', 'Ordinary_Drink', 'Cocktail', 'Random'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Map<String,dynamic>>[
        {
          'title':'Alcoholic',
          'search': 'a=Alcoholic',
          'image': 'assets/alcoholic.jpg'
        },
        {
          'title':'Non Alcoholic',
          'search': 'a=Non_Alcoholic',
          'image': 'assets/nalcoholic.jpg'
        },
        {
          'title':'Ordinary Drink',
          'search': 'c=Ordinary_Drink',
          'image': 'assets/ordinary.jpg'
        },
        {
          'title':'Cocktail',
          'search': 'c=Cocktail',
          'image': 'assets/cocktail.jpg'
        },
        {
          'title':'Random',
          'image': 'assets/placeholder.jpg'
        },
      ].map((Map<String,dynamic> item) {
        return Center(
          child: GestureDetector(
            onTap: () {
              if (item['title'] == 'Random') {
                Navigator.of(context).pushNamed('/randomDrink');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListDrinks(search: item['search'], title: item['title']),
                  ),
                );
              }
            },
            child: Text(item['title'], style: Theme.of(context).textTheme.headline,),
          ),
        );
      }).toList()
      ),
    );
  }
}

class DrinkOption {

  String strDrink;
  String strDrinkThumb;
  String idDrink;

  DrinkOption({
    this.strDrink,
    this.strDrinkThumb,
    this.idDrink,
  });

  factory DrinkOption.fromJson(Map<String, dynamic> json) {
    return DrinkOption(
      strDrink: json['strDrink'],
      strDrinkThumb: json['strDrinkThumb'],
      idDrink: json['idDrink'],
    );
  }

}

class ListDrinks extends StatefulWidget {
  final String search;
  final String title;
  ListDrinks({Key key, @required this.search, this.title}): super(key: key);
  _ListDrinksState createState() => _ListDrinksState();
}

class _ListDrinksState extends State<ListDrinks> {

  Future<List<DrinkOption>> _getDrinkOptions() async {

    String url = 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?${widget.search}';

    Response response = await get(url);

    if (response.statusCode == 200) {
      final items = json.decode(response.body)['drinks'];
      List<DrinkOption> listOfUsers = items.map<DrinkOption>((json) {
        return DrinkOption.fromJson(json);
      }).toList();

      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }

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
                    MaterialPageRoute(
                      builder: (context) => DrinkDetails(id: drink.idDrink, drinkName: drink.strDrink,),
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

class Drink {

  String strDrink;
  String strDrinkThumb;
  String idDrink;
  String strInstructions;

  Drink({
    this.strDrink,
    this.strDrinkThumb,
    this.idDrink,
    this.strInstructions,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      strDrink: json['drinks'][0]['strDrink'],
      strDrinkThumb: json['drinks'][0]['strDrinkThumb'],
      idDrink: json['drinks'][0]['idDrink'],
      strInstructions: json['drinks'][0]['strInstructions'],
    );
  }

}

class DrinkDetails extends StatefulWidget {
  final String id;
  final String drinkName;
  DrinkDetails({Key key, @required this.id, this.drinkName}): super(key: key);
  _DrinkDetailsState createState() => _DrinkDetailsState();
}

class _DrinkDetailsState extends State<DrinkDetails> {

  Future<Drink> _getDrinkDetails() async {

    String url = 'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${widget.id}';

    Response response = await get(url);

    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      Drink drinkDetails = Drink.fromJson(items);
      return drinkDetails;
    } else {
      throw Exception('Failed to load internet');
    }

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

class DrinkRandom extends StatefulWidget {
  _DrinkRandomState createState() => _DrinkRandomState();
}

class _DrinkRandomState extends State<DrinkRandom> {

  String title = '';
  String imgUrl = '';
  String instructions = '';

  Future getDrinkDetails() async {

    String url = 'https://www.thecocktaildb.com/api/json/v1/1/random.php';

    Response response = await get(url);

    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      Drink drink = Drink.fromJson(items);
      this.setState(() => {
        this.title = drink.strDrink,
        this.imgUrl = drink.strDrinkThumb,
        this.instructions = drink.strInstructions,
      });
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  void initState() {
    super.initState();
    getDrinkDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: new ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: new CachedNetworkImage(
                  imageUrl: imgUrl
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
                  instructions,
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
      ),
    );
  }
}