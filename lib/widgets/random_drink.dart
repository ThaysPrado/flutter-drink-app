import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:drink_app/models/drink.dart';
import 'package:drink_app/resources/repository.dart';

class DrinkRandom extends StatefulWidget {
  _DrinkRandomState createState() => _DrinkRandomState();
}

class _DrinkRandomState extends State<DrinkRandom> {

  String title = '';
  String imgUrl = '';
  String instructions = '';

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _getDrinkDetails() async {
    Repository().getDrinkRandom().then((Drink drink) {
      this.setState(() => {
        this.title = drink.strDrink,
        this.imgUrl = drink.strDrinkThumb,
        this.instructions = drink.strInstructions,
      });
    });
    return;
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _getDrinkDetails();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _getDrinkDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: new SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(),
        child: new Column(
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
      controller: _refreshController,
      onRefresh: _onRefresh,
      ),
    );
  }
}