// in order
enum Category {
  fruitsVegetables,
  bread,
  milkCheese,
  meatFish,
  spicesCanned,
  convenienceProductFrozen,
  cereals,
  sweetsSnacks,
  beverages,
  household,
  other
}

Category categoryFromString(String value) {
  return Category.values
      .firstWhere((e) => e.toString() == value, orElse: () => Category.other);
}
