import 'package:flutter_test/flutter_test.dart';
import 'package:alfabet/logic/replacer.dart';
import 'package:alfabet/data/alphabets/georgian.dart';
import 'package:alfabet/data/alphabets/hindi.dart';
import 'package:alfabet/data/alphabets/georgian_letter_options.dart';

void main() {
  test('Uppercase Р transforms to Georgian რ', () {
    expect(transformText('Р', russianToGeorgianMap), 'რ');
  });

  test('Extended Cyrillic letters are replaced', () {
    const inputUpper = 'ЁЙЪЫЬЭЮЯ';
    const inputLower = 'ёйъыьэюя';
    final resultUpper = transformText(inputUpper, russianToGeorgianMap);
    final resultLower = transformText(inputLower, russianToGeorgianMap);
    expect(resultUpper, 'იოიიეიუია');
    expect(resultLower, 'იოიიეიუია');
  });

  test('Selected characters replace both cases', () {
    const input = 'АаБб';
    final result = transformWithSelected(
      input,
      russianToGeorgianMap,
      {'ა', 'ბ'},
    );
    expect(result, 'ააბბ');
  });

  test('Digraph TS is replaced when selected', () {
    const input = 'ТС тс';
    final result = transformWithSelected(
      input,
      russianToGeorgianMap,
      {'წ'},
    );
    expect(result, 'წ წ');
  });

  test('Digraph DJ overrides single letters when selected', () {
    const input = 'джоуль';
    final onlySingles = transformWithSelected(
      input,
      russianToGeorgianMap,
      {'დ', 'ჟ'},
    );
    final withDigraph = transformWithSelected(
      input,
      russianToGeorgianMap,
      {'დ', 'ჟ', 'ჯ'},
    );
    expect(onlySingles, 'დჟоуль');
    expect(withDigraph, 'ჯоуль');
  });

  test('Uppercase Р transforms to Hindi र', () {
    expect(transformText('Р', russianToHindiMap), 'र');
  });

  test('Digraph RI overrides single letters when selected', () {
    const input = 'рис';
    final onlySingles = transformWithSelected(
      input,
      russianToHindiMap,
      {'र', 'इ'},
    );
    final withDigraph = transformWithSelected(
      input,
      russianToHindiMap,
      {'र', 'इ', 'ऋ'},
    );
    expect(onlySingles, 'रइस');
    expect(withDigraph, 'ऋс');
  });

  test('Letter options use selected replacement', () {
    const input = 'кк';
    final defaultRes = transformWithSelected(
      input,
      russianToGeorgianMap,
      {'ყ'},
      georgianLetterOptions,
    );
    final altRes = transformWithSelected(
      input,
      russianToGeorgianMap,
      {'კ'},
      georgianLetterOptions,
    );
    expect(defaultRes, 'ყყ');
    expect(altRes, 'კკ');
  });
}
