import 'package:flutter_test/flutter_test.dart';
import 'package:alfabet/data/alphabets/armenian_alphabet.dart';
import 'package:alfabet/data/alphabets/greek_alphabet.dart';
import 'package:alfabet/data/alphabets/georgian_alphabet.dart';
import 'package:alfabet/data/alphabets/hindi_alphabet.dart';

void main() {
  test('Georgian alphabet has 33 letters', () {
    expect(georgianAlphabet.length, 33);
  });

  test('Hindi alphabet has 44 letters', () {
    expect(hindiAlphabet.length, 44);
  });

  test('Armenian alphabet has 39 letters', () {
    expect(armenianAlphabet.length, 39);
  });

  test('Greek alphabet has 24 letters', () {
    expect(greekAlphabet.length, 24);
  });
}

