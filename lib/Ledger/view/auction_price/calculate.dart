import 'package:xml/xml.dart' as xml;

Map<String, List<double>> speciesPrices = {};

void parseApiResponse(String response, String species) {
  final document = xml.XmlDocument.parse(response);
  final items = document.findAllElements('item');

  List<double> prices = [];
  for (var item in items) {
    final priceText = item.findElements('csmtAmount').single.text;
    final price = double.tryParse(priceText) ?? 0.0;
    prices.add(price);
  }
  speciesPrices[species] = prices;
}

void calculateAndDisplayStatistics() {
  speciesPrices.forEach((species, prices) {
    if (prices.isEmpty) return;

    final average = prices.reduce((a, b) => a + b) / prices.length;
    final max = prices.reduce((a, b) => a > b ? a : b);
    final min = prices.reduce((a, b) => a < b ? a : b);

    print('Species: $species');
    print('Average Price: $average');
    print('Max Price: $max');
    print('Min Price: $min');
  });
}
