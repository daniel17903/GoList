import 'package:go_list/service/items/category.dart';
import 'package:go_list/service/items/icon_mapping.dart';

const String defaultIconAsset = "default";
const Category defaultCategory = Category.other;


final List<IconMapping> iconMappings = [
  IconMapping(
      assetFileName: "apple",
      matchingNames: ["apfel", "äpfel", "aepfel"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "banana",
      matchingNames: ["banane"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "bottle",
      matchingNames: [
        "flasche",
        "wasser",
        "bier",
        "wein",
        "cola",
        "fanta",
        "eistee",
        "limo",
        "limonade",
        "sprite",
        "apfelschorle",
        "öl",
        "oel",
        "essig",
        "sojasoße",
        "sojasosse",
        "soja sosse",
        "soja soße"
      ],
      category: Category.beverages),
  IconMapping(
      assetFileName: "box",
      matchingNames: [
        "box",
        "spülmaschinen tabs",
        "spülmaschinen-tabs",
        "spülmaschinen salz",
        "spülmaschinen-salz"
      ],
      category: Category.household),
  IconMapping(
      assetFileName: "flour",
      matchingNames: ["mehl"],
      category: Category.cereals),
  IconMapping(
      assetFileName: "bread",
      matchingNames: ["brot", "brötchen", "laugenstange", "brezel"],
      category: Category.bread),
  IconMapping(
      assetFileName: "can",
      matchingNames: ["bohnen", "dose"],
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "carrot",
      matchingNames: ["karotte", "pastinake", "rübe", "ruebe"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "corn",
      matchingNames: ["samen", "körner"],
      category: Category.cereals),
  IconMapping(
      assetFileName: "cup",
      matchingNames: [
        "becher",
        "yoghurt",
        "quark",
        "saure sahne",
        "schlagsahne"
      ],
      category: Category.milkCheese),
  IconMapping(
      assetFileName: "glas",
      matchingNames: ["glas", "marmelade", "gläser", "honig"],
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "leek",
      matchingNames: ["lauch", "porree"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "peanut",
      matchingNames: ["nuss", "nüsse"],
      category: Category.cereals),
  IconMapping(
      assetFileName: "round_fruit",
      matchingNames: ["tomate", "orange", "mandarine", "mango"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "dead_cow",
      matchingNames: ["fleisch", "hackfleisch", "wurst", "steak", "würste"],
      category: Category.meatFish),
  IconMapping(
      assetFileName: "cookie",
      matchingNames: ["keks", "kekse", "süssigkeiten"],
      category: Category.sweetsSnacks),
  IconMapping(
      assetFileName: "pepper",
      matchingNames: ["paprika"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "onion",
      matchingNames: ["zwiebel"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "pear",
      matchingNames: ["birne"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "cabbage",
      matchingNames: ["kohl", "wirsing"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "eggplant",
      matchingNames: ["aubergine"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "salad",
      matchingNames: ["salat", "rucola", "spinat"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "chocolate",
      matchingNames: ["schokolade"],
      category: Category.sweetsSnacks),
  IconMapping(
      assetFileName: "ice",
      matchingNames: ["eis", "magnum"],
      category: Category.sweetsSnacks),
  IconMapping(
      assetFileName: "berries",
      matchingNames: [
        "beeren",
        "himbeeren",
        "johannisbeeren",
        "heidelbeeren",
        "blaubeeren"
      ],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "strawberry",
      matchingNames: ["erdbeere"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "block",
      matchingNames: ["tofu", "butter", "margarine", "käse", "kaese"],
      category: Category.milkCheese),
  IconMapping(
      assetFileName: "burger",
      matchingNames: ["burger"],
      category: Category.convenienceProductFrozen),
  IconMapping(
      assetFileName: "herbs",
      matchingNames: [
        "kräuter",
        "petersilie",
        "basilikum",
        "koriander",
        "dill"
      ],
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "pizza_cake",
      matchingNames: ["pizza", "kuchen", "torte", "flammkuchen"],
      category: Category.convenienceProductFrozen),
  IconMapping(
      assetFileName: "yeast",
      matchingNames: ["hefe"],
      category: Category.milkCheese),
  IconMapping(
      assetFileName: "package",
      matchingNames: [
        "backpulver",
        "natron",
        "vanillezucker",
        "trockenhefe",
        "agar-agar",
        "agar agar"
      ],
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "pasta",
      matchingNames: ["nudeln", "spaghetti", "pasta"],
      category: Category.cereals),
  IconMapping(
      assetFileName: "lemon",
      matchingNames: ["zitrone"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "potatos",
      matchingNames: ["kartoffel"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "garlic",
      matchingNames: ["knoblauch"],
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "spice",
      matchingNames: [
        "salz",
        "pfeffer",
        "gewürz",
        "gewuerz",
        "curry",
        "kurkuma",
        "zimt",
        "kümmel",
        "kuemmel"
      ],
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "rice",
      matchingNames: ["reis"],
      category: Category.cereals),
  IconMapping(
      assetFileName: "paper_towel",
      matchingNames: ["küchenrolle", "kuechenrolle", "zewa"],
      category: Category.household),
  IconMapping(
      assetFileName: "toilet_paper",
      matchingNames: [
        "klopapier",
        "klo papier",
        "toilettenpapier",
        "toiletten papier"
      ],
      category: Category.household)
];
