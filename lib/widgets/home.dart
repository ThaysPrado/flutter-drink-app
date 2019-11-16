import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:drink_app/widgets/random_drink.dart';
import 'package:drink_app/widgets/list_drinks.dart';

class DrinkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Drinks';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        primary: false,
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
          'image': 'assets/random.jpg'
        },
      ].map((Map<String,dynamic> item) {
        return Center(
          child: GestureDetector(
            onTap: () {
              if (item['title'] == 'Random') {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.rightToLeft, child: DrinkRandom()),
                );
              } else {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.rightToLeft, child: ListDrinks(search: item['search'], title: item['title'])),
                );
              }
            },
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Image.asset(item['image'],
                    height: 120,
                    width: 120
                  ),
                  clipBehavior: Clip.antiAlias,
                ),
                Text(item['title'],  style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),),
              ],
            ),
          ),
        );
      }).toList()
      ),
    );
  }
}