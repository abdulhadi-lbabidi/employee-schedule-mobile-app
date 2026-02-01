import 'package:flutter_test/flutter_test.dart';
import 'package:untitled8/features/admin/data/repositories/audit_log_repository.dart';
import 'package:untitled8/features/admin/data/models/audit_log_model.dart';
import 'package:hive/hive.dart';

// محاكاة لـ Hive Box مصلحة لتوافق الإصدارات الحديثة
class FakeAuditBox<T> extends Iterable<T> implements Box<T> {
  final Map<dynamic, T> _data = {};

  @override Future<int> add(T value) async {
    int key = _data.length;
    _data[key] = value;
    return key;
  }

  @override T? get(key, {T? defaultValue}) => _data[key] ?? defaultValue;
  
  @override Iterable<T> get values => _data.values;

  @override Future<int> clear() async {
    int count = _data.length;
    _data.clear();
    return count;
  }

  @override bool get isEmpty => _data.isEmpty;
  @override int get length => _data.length;

  // تنفيذ الدوال المطلوبة لتجنب أخطاء الـ abstract
  @override Future<void> put(key, T value) async => _data[key] = value;
  @override Future<void> delete(key) async => _data.remove(key);
  @override bool get isOpen => true;
  @override String get name => 'fake_audit';
  @override String? get path => null;
  @override bool get lazy => false;
  @override Future<void> close() async {}
  @override Future<void> compact() async {}
  @override bool containsKey(key) => _data.containsKey(key);
  @override Future<void> deleteAll(Iterable keys) async => _data.removeWhere((k,v) => keys.contains(k));
  @override Future<void> deleteAt(int index) async => _data.remove(keyAt(index));
  @override Future<void> deleteFromDisk() async => _data.clear();
  @override Future<void> flush() async {}
  @override T? getAt(int index) => _data.values.elementAt(index);
  @override bool get isNotEmpty => _data.isNotEmpty;
  @override keyAt(int index) => _data.keys.elementAt(index);
  @override Iterable get keys => _data.keys;
  @override Future<void> putAll(Map entries) async => _data.addAll(Map<dynamic, T>.from(entries));
  @override Future<void> putAt(int index, T value) async => _data[keyAt(index)] = value;
  @override Iterable<T> valuesBetween({dynamic startKey, dynamic endKey}) => _data.values;
  @override Stream<BoxEvent> watch({key}) => throw UnimplementedError();
  @override Map<dynamic, T> toMap() => _data;
  @override Future<Iterable<int>> addAll(Iterable<T> values) async => [];
  @override Iterator<T> get iterator => _data.values.iterator;
}

void main() {
  late AuditLogRepository repository;
  late FakeAuditBox<AuditLogModel> mockBox;

  setUp(() {
    mockBox = FakeAuditBox<AuditLogModel>();
    repository = AuditLogRepository(mockBox);
  });

  group('Audit Log Repository Tests', () {
    test('يجب تسجيل نشاط جديد وحفظه في الذاكرة', () async {
      await repository.logAction(
        actionType: "حذف موظف",
        targetName: "خالد",
        details: "تم حذف الحساب نهائياً",
      );

      expect(mockBox.length, 1);
      expect(mockBox.values.first.targetName, "خالد");
    });

    test('يجب أن تكون النشاطات مرتبة من الأحدث للأقدم', () async {
      // نشاط قديم
      await repository.logAction(actionType: "1", targetName: "أ", details: "");
      await Future.delayed(Duration(milliseconds: 10)); // تأخير بسيط
      // نشاط جديد
      await repository.logAction(actionType: "2", targetName: "ب", details: "");

      final logs = repository.getLogs();
      
      expect(logs.first.actionType, "2"); // الأحدث في البداية
      expect(logs.last.actionType, "1");
    });

    test('يجب مسح كافة السجلات عند استدعاء clearLogs', () async {
      await repository.logAction(actionType: "تست", targetName: "تست", details: "");
      await repository.clearLogs();

      expect(repository.getLogs().isEmpty, true);
    });
  });
}
