import 'dart:ui';

import 'package:go_list/service/items/category.dart';
import 'package:go_list/service/items/icon_mapping.dart';

const String defaultIconAsset = "default";
const Category defaultCategory = Category.other;

final List<IconMapping> iconMappings = [
  IconMapping(
      assetFileName: "apple",
      matchingNames: {
        const Locale("de"): ["apfel", "äpfel", "aepfel", "obst"],
        const Locale("en"): ["apple", "fruit"],
        const Locale("es"): ["manzana", "fruta"]
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "banana",
      matchingNames: {
        const Locale("de"): ["banane"],
        const Locale("en"): ["banana"],
        const Locale("es"): ["banana", "plátano", "platano"]
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "bottle",
      matchingNames: {
        const Locale("de"): [
          "flasche",
          "wasser",
          "sprudel",
          "bier",
          "wein",
          "cola",
          "fanta",
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
          "soja soße",
          "pils",
          "hefeweizen"
        ],
        const Locale("en"): [
          "bottle",
          "water",
          "beer",
          "wine",
          "coke",
          "coca cola",
          "fanta",
          "lemonade",
          "sprite",
          "juice",
          "oil",
          "vinegar",
          "sauce"
        ],
        const Locale("es"): [
          "botella",
          "aqua",
          "cerveza",
          "vino",
          "coca",
          "fanta",
          "orangina",
          "limonada",
          "sprite",
          "vinagre",
          "aceite",
          "salsa"
        ]
      },
      category: Category.beverages),
  IconMapping(
      assetFileName: "box",
      matchingNames: {
        const Locale("de"): [
          "box",
          "spülmaschinen tabs",
          "spülmaschinen-tabs",
          "spülmaschinen salz",
          "spülmaschinen-salz",
          "müsli",
          "muesli"
        ],
        const Locale("en"): ["box", "cereal"],
        const Locale("es"): ["caja", "cereal"]
      },
      category: Category.household),
  IconMapping(
      assetFileName: "flour",
      matchingNames: {
        const Locale("de"): ["mehl"],
        const Locale("en"): ["flour"],
        const Locale("es"): ["harina"]
      },
      category: Category.cereals),
  IconMapping(
      assetFileName: "bread",
      matchingNames: {
        const Locale("de"): [
          "brot",
          "brötchen",
          "laugenstange",
          "brezel",
          "semmel"
        ],
        const Locale("en"): ["bread", "bun", "pretzel"],
        const Locale("es"): ["pan", "bollo"]
      },
      category: Category.bread),
  IconMapping(
      assetFileName: "can",
      matchingNames: {
        const Locale("de"): ["bohnen", "dose"],
        const Locale("en"): ["bean", "can"],
        const Locale("es"): ["lata", "frijol", "fréjol", "judía", "judia"]
      },
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "carrot",
      matchingNames: {
        const Locale("de"): [
          "karotte",
          "pastinake",
          "rübe",
          "ruebe",
          "rettich",
          "möhre",
          "gemüse",
          "gemuese"
        ],
        const Locale("en"): ["carrot", "parsnip", "vegetable"],
        const Locale("es"): [
          "zanahoria",
          "chirivía",
          "pastinaca",
          "rábano",
          "verdura"
        ]
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "corn",
      matchingNames: {
        const Locale("de"): ["samen", "körner", "linsen"],
        const Locale("en"): ["grain", "seed", "lenses"],
        const Locale("es"): ["semilla", "granos", "lentes"]
      },
      category: Category.cereals),
  IconMapping(
      assetFileName: "cup",
      matchingNames: {
        const Locale("de"): [
          "becher",
          "yoghurt",
          "joghurt",
          "quark",
          "saure sahne",
          "schlagsahne",
          "sahne"
        ],
        const Locale("en"): ["cup", "yogurt", "quark", "cream"],
        const Locale("es"): ["yogur", "cuarc", "queso fresco", "nata"]
      },
      category: Category.milkCheese),
  IconMapping(
      assetFileName: "glas",
      matchingNames: {
        const Locale("de"): [
          "glas",
          "marmelade",
          "gläser",
          "honig",
          "aufstrich",
          "sauerkraut",
          "schattenmorellen",
          "nutella"
        ],
        const Locale("en"): ["glass", "jar", "jam", "honey", "nutella"],
        const Locale("es"): [
          "vaso",
          "mermelada",
          "confitura",
          "chucrut",
          "miel",
          "nutella"
        ]
      },
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "leek",
      matchingNames: {
        const Locale("de"): ["lauch", "porree"],
        const Locale("en"): ["leek"],
        const Locale("es"): ["puerro"]
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "peanut",
      matchingNames: {
        const Locale("de"): ["nuss", "nüsse"],
        const Locale("en"): ["nut"],
        const Locale("es"): ["nuez", "avellana"]
      },
      category: Category.cereals),
  IconMapping(
      assetFileName: "almonds",
      matchingNames: {
        const Locale("de"): ["mandel"],
        const Locale("en"): ["almond"],
        const Locale("es"): ["almendra"]
      },
      category: Category.cereals),
  IconMapping(
      assetFileName: "round_fruit",
      matchingNames: {
        const Locale("de"): [
          "tomate",
          "orange",
          "mandarine",
          "mango",
          "nektarine",
          "pfirsich"
        ],
        const Locale("en"): [
          "tomato",
          "orange",
          "tangerine",
          "mango",
          "nectarine",
          "peach"
        ],
        const Locale("es"): [
          "tomate",
          "naranja",
          "mandarina",
          "mango",
          "nectarina",
          "melocotón",
          "melocoton",
          "durazno"
        ]
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "dead_cow",
      matchingNames: {
        const Locale("de"): ["fleisch", "hackfleisch", "steak", "rinder"],
        const Locale("en"): ["meat", "steak", "beef"],
        const Locale("es"): ["carne", "filete"]
      },
      category: Category.meatFish),
  IconMapping(
      assetFileName: "dead_pig",
      matchingNames: {
        const Locale("de"): [
          "wurst",
          "schinken",
          "speck",
          "bacon",
          "würstchen",
          "würste",
          "fleischkäs",
          "leberkäs",
          "salami",
          "lyoner",
          "wiener",
          "aufschnitt",
          "schweine"
        ],
        const Locale("en"): [
          "sausage",
          "ham",
          "bacon",
          "hot dog",
          "meatloaf",
          "salami",
          "lyon"
        ],
        const Locale("es"): [
          "salchichon",
          "salchichón",
          "salchicha",
          "jamón",
          "jamon",
          "bacon",
          "bacón",
          "salami",
          "serrano",
          "chorizo"
        ]
      },
      category: Category.meatFish),
  IconMapping(
      assetFileName: "dead_chicken",
      matchingNames: {
        const Locale("de"): ["hühnchen", "pute", "chicken", "hühner"],
        const Locale("en"): ["chicken", "turkey"],
        const Locale("es"): ["pollo", "pava"]
      },
      category: Category.meatFish),
  IconMapping(
      assetFileName: "fish",
      matchingNames: {
        const Locale("de"): [
          "fisch",
          "lachs",
          "forelle",
          "barsch",
          "hecht",
          "dorade",
          "hering",
          "kabeljau",
          "dorsch",
          "karpfen",
          "fischstäbchen"
        ],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.meatFish),
  IconMapping(
      assetFileName: "cookie",
      matchingNames: {
        const Locale("de"): ["keks", "kekse", "süssigkeiten"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.sweetsSnacks),
  IconMapping(
      assetFileName: "pepper",
      matchingNames: {
        const Locale("de"): ["paprika"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "onion",
      matchingNames: {
        const Locale("de"): ["zwiebel"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "pear",
      matchingNames: {
        const Locale("de"): ["birne"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "cabbage",
      matchingNames: {
        const Locale("de"): ["kohl", "wirsing"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "broccoli",
      matchingNames: {
        const Locale("de"): ["brokkoli", "broccoli", "brokoli"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "eggplant",
      matchingNames: {
        const Locale("de"): ["aubergine"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "salad",
      matchingNames: {
        const Locale("de"): [
          "salat",
          "rucola",
          "spinat",
          "mangold",
          "pak choi",
          "pak choy"
        ],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "chocolate",
      matchingNames: {
        const Locale("de"): ["schokolade"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.sweetsSnacks),
  IconMapping(
      assetFileName: "ice",
      matchingNames: {
        const Locale("de"): ["eis", "magnum"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.sweetsSnacks),
  IconMapping(
      assetFileName: "berries",
      matchingNames: {
        const Locale("de"): [
          "beeren",
          "himbeeren",
          "johannisbeeren",
          "heidelbeeren",
          "blaubeeren"
        ],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "strawberry",
      matchingNames: {
        const Locale("de"): ["erdbeere"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "block",
      matchingNames: {
        const Locale("de"): ["tofu", "butter", "margarine", "käse", "kaese"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.milkCheese),
  IconMapping(
      assetFileName: "burger",
      matchingNames: {
        const Locale("de"): ["burger"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.convenienceProductFrozen),
  IconMapping(
      assetFileName: "herbs",
      matchingNames: {
        const Locale("de"): [
          "kräuter",
          "petersilie",
          "basilikum",
          "koriander",
          "dill"
        ],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "pizza_cake",
      matchingNames: {
        const Locale("de"): ["pizza", "kuchen", "torte", "flammkuchen"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.convenienceProductFrozen),
  IconMapping(
      assetFileName: "yeast",
      matchingNames: {
        const Locale("de"): ["hefe"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.milkCheese),
  IconMapping(
      assetFileName: "package",
      matchingNames: {
        const Locale("de"): [
          "backpulver",
          "natron",
          "vanillezucker",
          "trockenhefe",
          "agar-agar",
          "agar agar"
        ],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "pasta",
      matchingNames: {
        const Locale("de"): ["nudeln", "spaghetti", "pasta"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.cereals),
  IconMapping(
      assetFileName: "lemon",
      matchingNames: {
        const Locale("de"): ["zitrone"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "potatos",
      matchingNames: {
        const Locale("de"): ["kartoffel"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "garlic",
      matchingNames: {
        const Locale("de"): ["knoblauch"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "spice",
      matchingNames: {
        const Locale("de"): [
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
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "rice",
      matchingNames: {
        const Locale("de"): ["reis"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.cereals),
  IconMapping(
      assetFileName: "paper_towel",
      matchingNames: {
        const Locale("de"): ["küchenrolle", "kuechenrolle", "zewa"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.household),
  IconMapping(
      assetFileName: "toilet_paper",
      matchingNames: {
        const Locale("de"): [
          "klopapier",
          "klo papier",
          "toilettenpapier",
          "toiletten papier"
        ],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.household),
  IconMapping(
      assetFileName: "baking_paper",
      matchingNames: {
        const Locale("de"): ["backpapier", "back papier", "frischhaltefolie"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.household),
  IconMapping(
      assetFileName: "mushroom",
      matchingNames: {
        const Locale("de"): ["pilz", "champignon"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "papaya",
      matchingNames: {
        const Locale("de"): ["papaya"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "rhubarb",
      matchingNames: {
        const Locale("de"): ["rhabarber"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "tetrapack",
      matchingNames: {
        const Locale("de"): [
          "milch",
          "saft",
          "haferdrink",
          "hafer drink",
          "soja drink",
          "sojadrink",
          "mandeldrink",
          "mandel drink",
          "reisdrink",
          "reis drink",
          "eistee"
        ],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.milkCheese),
  IconMapping(
      assetFileName: "egg",
      matchingNames: {
        const Locale("de"): ["eier"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.milkCheese),
  IconMapping(
      assetFileName: "coffee_beans",
      matchingNames: {
        const Locale("de"): ["kaffee", "espresso"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.beverages),
  IconMapping(
      assetFileName: "tea",
      matchingNames: {
        const Locale("de"): ["tee"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.beverages),
  IconMapping(
      assetFileName: "sugar",
      matchingNames: {
        const Locale("de"): ["zucker"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.spicesCanned),
  IconMapping(
      assetFileName: "cheese",
      matchingNames: {
        const Locale("de"): [
          "käse",
          "kaese",
          "mozarella",
          "parmesan",
          "gauda",
          "edamer",
          "feta",
          "emmentaler",
          "cheddar",
          "brie",
          "camembert",
          "appenzeller",
          "halloumi",
          "manchego",
          "tilsiter",
          "ricotta"
        ],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.milkCheese),
  IconMapping(
      assetFileName: "asparagus",
      matchingNames: {
        const Locale("de"): ["spargel"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "gnocchi",
      matchingNames: {
        const Locale("de"): ["gnocchi"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.cereals),
  IconMapping(
      assetFileName: "pumpkin",
      matchingNames: {
        const Locale("de"): ["kürbis", "kuerbis", "hokkaido"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "beetroot",
      matchingNames: {
        const Locale("de"): [
          "rote bete",
          "gelbe bete",
          "rote rübe",
          "gelbe rübe"
        ],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "radish",
      matchingNames: {
        const Locale("de"): ["radieschen", "radieserl"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "cucumber",
      matchingNames: {
        const Locale("de"): ["gurke"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "dates",
      matchingNames: {
        const Locale("de"): ["dattel"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "lime",
      matchingNames: {
        const Locale("de"): ["limette"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "paper_bag",
      matchingNames: {
        const Locale("de"): ["tüte", "tuete"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.household),
  IconMapping(
      assetFileName: "raisins",
      matchingNames: {
        const Locale("de"): ["rosine"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.cereals),
  IconMapping(
      assetFileName: "round_fruit_small",
      matchingNames: {
        const Locale("de"): [
          "pflaume",
          "aprikose",
          "zwetschge",
          "mirabelle",
          "marille"
        ],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables),
  IconMapping(
      assetFileName: "seeds",
      matchingNames: {
        const Locale("de"): ["kerne", "flocken"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.cereals),
  IconMapping(
      assetFileName: "sponge",
      matchingNames: {
        const Locale("de"): ["schwamm", "schwämme", "schwaemme"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.household),
  IconMapping(
      assetFileName: "zucchini",
      matchingNames: {
        const Locale("de"): ["zucchini", "zuchini"],
        const Locale("en"): [],
        const Locale("es"): []
      },
      category: Category.fruitsVegetables)
];
