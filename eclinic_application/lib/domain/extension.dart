import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DateToString on DateTime {
  convertToWord() {
    return DateFormat('MMM yyyy').format(this);
  }

  convertToWordMonth() {
    return month < 10 ? '0$month' : month;
  }

  convertToWordYears() {
    return DateFormat('yyyy').format(this);
  }
}

extension ChangedForString on String {
  arabicEquatable() {
    return replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ا')
        .replaceAll('ة', 'ه');
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension RefToString on DocumentReference? {
  String toStringNameDepartement() {
    return this?.path.split('/').last ?? 'IS';
  }
}

extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> removeNullValues() {
    return Map<K, V>.fromEntries(entries.where((e) => e.value != null));
  }
}

extension StringEmtyToNull on String {
  String? toNullIfEmplty() {
    return isEmpty ? null : this;
  }
}

extension SortBySemesterAndYear on List<Map<String, dynamic>?> {
  sortBySemesterAndYear() {
    sort((a, b) {
      final yearA = _getYear(a!['semestername']!);
      final yearB = _getYear(b!['semestername']!);
      if (yearA != yearB) {
        return yearA.compareTo(yearB);
      } else {
        final semesterA = _getSemester(a['semestername']!);
        final semesterB = _getSemester(b['semestername']!);
        return semesterA.compareTo(semesterB);
      }
    });

    sort((a, b) {
      final yearA = _getYear(a!['semestername']!, yerAfter: false);
      final yearB = _getYear(b!['semestername']!, yerAfter: false);
      //if (yearA != yearB) {
      return yearA.compareTo(yearB);
      //} else {
      //  final semesterA = _getSemester(a['semestername']!);
      //  final semesterB = _getSemester(b['semestername']!);
      //  return semesterA.compareTo(semesterB);
      //}
    });

    sort((a, b) {
      final yearA = _getYear(a!['semestername']!, yerAfter: false);
      final yearB = _getYear(b!['semestername']!, yerAfter: false);
      //if (yearA != yearB) {
      return yearA.compareTo(yearB);
      //} else {
      //  final semesterA = _getSemester(a['semestername']!);
      //  final semesterB = _getSemester(b['semestername']!);
      //  return semesterA.compareTo(semesterB);
      //}
    });

    sort((a, b) {
      final endDateA = a!['endDate']?.date();
      final endDateB = b!['endDate']?.date();
      if (endDateA != null && endDateB != null) {
        return endDateA.compareTo(endDateB);
      } else {
        //  final semesterA = _getSemester(a['semestername']!);
        //  final semesterB = _getSemester(b['semestername']!);
        final fYearA = _getYear(a['semestername']!);
        final lYearA = _getYear(a['semestername']!, yerAfter: false);
        final fYearB = _getYear(b['semestername']!);
        final lYearB = _getYear(b['semestername']!, yerAfter: false);
        if (fYearB == fYearA && lYearB == lYearA) {
          final semesterA = _getSemester(a['semestername']!);
          final semesterB = _getSemester(b['semestername']!);
          return semesterB.compareTo(semesterA);
        } else {
          return -1;
        }
      }
    });

    //print(this) ;
  }

  int _getSemester(String nameSemester) {
    switch (nameSemester.substring(0, 3)) {
      case '1st':
        return 1;
      case '2nd':
        return 2;
      case '3rd':
        return 3;
      default:
        throw ArgumentError('Invalid semester name: $nameSemester');
    }
  }

  int _getYear(String nameSemester, {bool yerAfter = true}) {
    final yearString = nameSemester.substring(4);
    final parts = yearString.split('/');
    if (parts.length != 2) {
      throw ArgumentError('Invalid year string: $yearString');
    }
    final year = int.tryParse(parts[0]);
    final yearAfter = int.tryParse(parts[1]);
    final suffix = parts[1];
    if (yearAfter == null || suffix.length != 4) {
      throw ArgumentError('Invalid year string: $yearString');
    }
    return yerAfter ? yearAfter : year!;
  }
}
