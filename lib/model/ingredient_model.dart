import 'package:equatable/equatable.dart';

class IngredientModel extends Equatable{
  final name;
  final amount;

  IngredientModel({this.name, this.amount});

  Map<String, String> toJson() => {"name": name, "amount": amount};

  factory IngredientModel.fromMap(Map<String, dynamic> snapshot) =>
      IngredientModel(name: snapshot["name"], amount: snapshot["amount"]);

  @override
  List<Object> get props => [name, amount];
}
