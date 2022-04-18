import 'package:go_list/service/input_to_item_parser.dart';
import 'package:test/test.dart';

void main() {
  group("Should parse amount:", () {
    Map<String, String?> inputsToExpected = {
      "efwefwg": null,
      "1Liter wefwg": "1Liter",
      "1 Liter wefwg": "1 Liter",
      "1 fwefew": "1",
      "1 dose fwefew": "1 dose",
      "2 dosen fwefew": "2 dosen",
      "fwef2geweg": null,
      "efwef2literwegwg": null,
      "2literwrgwg": null,
      "kuchen 2 Stück": "2 Stück",
      "kuchen 2": "2",
      "2.5 liter wasser": "2.5 liter",
      "2,5 liter wasser": "2,5 liter",
      "mehl typ 630": null,
      "mehl Typ 630": null
    };
    inputsToExpected.forEach((input, expected) {
      test("$input -> $expected", () {
        expect(InputToItemParser.parseAmount(input), expected);
      });
    });
  });

  test("Should find correct icon", (){
    expect(InputToItemParser.findMatchingIconForName("apfelschorle"), "bottle");
  });
}
