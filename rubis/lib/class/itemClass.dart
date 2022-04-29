// ignore_for_file: file_names

class Item {
  Map<String, String> item = {};
  Map<String, Map<String, List<String>>> itemInput = {};
  Map<String, String> itemInputType = {};

  Item(
    this.item,
    this.itemInput,
    this.itemInputType,
  );
}
