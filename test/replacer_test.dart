import 'package:flutter_test/flutter_test.dart';
import 'package:alfabet/logic/replacer.dart';
import 'package:alfabet/data/alphabets/georgian.dart';
import 'package:alfabet/data/alphabets/hindi.dart';
import 'package:alfabet/data/alphabets/georgian_letter_options.dart';
import 'package:alfabet/data/alphabets/hindi_letter_options.dart';
import 'package:alfabet/data/alphabets/armenian.dart';
import 'package:alfabet/data/alphabets/armenian_letter_options.dart';
import 'package:alfabet/data/alphabets/greek.dart';
import 'package:alfabet/data/alphabets/greek_letter_options.dart';
import 'package:alfabet/data/alphabets/english_to_greek.dart';

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
    // Остальные буквы тоже должны быть в selected — иначе replacer оставит кириллицу.
    final onlySingles = transformWithSelected(
      input,
      russianToHindiMap,
      {'र', 'इ', 'स'},
    );
    final withDigraph = transformWithSelected(
      input,
      russianToHindiMap,
      {'ऋ', 'स'},
    );
    expect(onlySingles, 'रइस');
    expect(withDigraph, 'ऋस');
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

  test('Greek: Russian а maps to α', () {
    expect(transformText('а', russianToGreekMap), 'α');
  });

  test('Transcription: Latin a via englishToGreekMap', () {
    expect(transformText('a', englishToGreekMap), 'α');
  });

  test('Greek: ο/ω via letter options', () {
    const input = 'оо';
    final omicron = transformWithSelected(
      input,
      russianToGreekMap,
      {'ο'},
      greekLetterOptions,
    );
    final omega = transformWithSelected(
      input,
      russianToGreekMap,
      {'ω'},
      greekLetterOptions,
    );
    expect(omicron, 'οο');
    expect(omega, 'ωω');
  });

  test('Armenian: Russian а maps to ա', () {
    expect(transformText('а', russianToArmenianMap), 'ա');
  });

  test('Armenian: т/тʼ via letter options', () {
    const input = 'тт';
    final plain = transformWithSelected(
      input,
      russianToArmenianMap,
      {'տ'},
      armenianLetterOptions,
    );
    final aspirated = transformWithSelected(
      input,
      russianToArmenianMap,
      {'թ'},
      armenianLetterOptions,
    );
    expect(plain, 'տտ');
    expect(aspirated, 'թթ');
  });

  test('Hindi: same Russian т maps to dental or retroflex via letter options', () {
    const input = 'тт';
    final dental = transformWithSelected(
      input,
      russianToHindiMap,
      {'त'},
      hindiLetterOptions,
    );
    final retroflex = transformWithSelected(
      input,
      russianToHindiMap,
      {'ट'},
      hindiLetterOptions,
    );
    expect(dental, 'तत');
    expect(retroflex, 'टट');
  });
}
