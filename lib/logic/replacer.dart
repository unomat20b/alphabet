String transformText(String input, Map<String, String> map,
    [Map<String, List<String>>? options]) {
  return transformWithSelected(input, map, map.values.toSet(), options);
}

String transformWithSelected(
  String input,
  Map<String, String> map,
  Set<String> selected,
  [Map<String, List<String>>? options,
]) {
  final optionMap = options ?? <String, List<String>>{};

  // Map each option letter back to its group key
  final letterToGroup = <String, String>{};
  for (final entry in optionMap.entries) {
    for (final opt in entry.value) {
      letterToGroup[opt] = entry.key;
    }
  }

  // Determine which option is chosen for each group
  final selectedForGroup = <String, String>{};
  for (final entry in optionMap.entries) {
    for (final opt in entry.value) {
      if (selected.contains(opt)) {
        selectedForGroup[entry.key] = opt;
        break;
      }
    }
  }
  final entries = map.entries.toList()
    ..sort((a, b) => b.key.length.compareTo(a.key.length));

  final buffer = StringBuffer();
  int i = 0;
  while (i < input.length) {
    bool matched = false;
    for (final entry in entries) {
      final rus = entry.key;
      final geo = entry.value;
      final group = letterToGroup[geo];
      final mappedGeo =
          group != null && selectedForGroup.containsKey(group)
              ? selectedForGroup[group]!
              : geo;

      if (!selected.contains(mappedGeo)) continue;

      if (i + rus.length <= input.length &&
          input.substring(i, i + rus.length).toLowerCase() ==
              rus.toLowerCase()) {
        buffer.write(mappedGeo);
        i += rus.length;
        matched = true;
        break;
      }
    }

    if (!matched) {
      buffer.write(input[i]);
      i += 1;
    }
  }

  return buffer.toString();
}
