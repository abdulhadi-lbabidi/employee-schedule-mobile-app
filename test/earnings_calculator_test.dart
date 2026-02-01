import 'package:flutter_test/flutter_test.dart';
// سنقوم بمحاكاة الكلاس الموجود في الملف الأصلي لاختباره
class PricingConfig {
  static const double BASIC_HOURS = 8.0;
  static const double BASIC_HOURS_RATE = 8.0;
  static const double OVERTIME_RATE = 1.0;
}

class EarningsCalculator {
  static Map<String, double> calculateEarnings({required double totalHours}) {
    double basic = totalHours <= PricingConfig.BASIC_HOURS 
        ? (totalHours / PricingConfig.BASIC_HOURS) * PricingConfig.BASIC_HOURS_RATE 
        : PricingConfig.BASIC_HOURS_RATE;
    
    double overtime = totalHours > PricingConfig.BASIC_HOURS 
        ? (totalHours - PricingConfig.BASIC_HOURS) * PricingConfig.OVERTIME_RATE 
        : 0.0;
        
    return {
      'basicEarnings': double.parse(basic.toStringAsFixed(2)),
      'overtimeEarnings': double.parse(overtime.toStringAsFixed(2)),
      'totalEarnings': double.parse((basic + overtime).toStringAsFixed(2)),
    };
  }
}

void main() {
  group('EarningsCalculator Tests', () {
    test('يجب أن يحسب الراتب الأساسي فقط إذا كانت الساعات 8 أو أقل', () {
      final result = EarningsCalculator.calculateEarnings(totalHours: 5.0);
      expect(result['basicEarnings'], 5.0);
      expect(result['overtimeEarnings'], 0.0);
      expect(result['totalEarnings'], 5.0);
    });

    test('يجب أن يحسب الإضافي إذا تجاوزت الساعات 8', () {
      final result = EarningsCalculator.calculateEarnings(totalHours: 10.0);
      expect(result['basicEarnings'], 8.0);
      expect(result['overtimeEarnings'], 2.0);
      expect(result['totalEarnings'], 10.0);
    });

    test('يجب أن يعطي صفر إذا كانت الساعات صفر', () {
      final result = EarningsCalculator.calculateEarnings(totalHours: 0.0);
      expect(result['totalEarnings'], 0.0);
    });
  });
}
