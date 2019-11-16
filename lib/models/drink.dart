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