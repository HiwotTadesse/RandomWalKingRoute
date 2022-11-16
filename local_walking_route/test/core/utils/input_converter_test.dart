import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_walking_route/core/utils/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      const str = '15';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, const Right(15));
    });

    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      const str = 'abc';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      const str = '-15';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
