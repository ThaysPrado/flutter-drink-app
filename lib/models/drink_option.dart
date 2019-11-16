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