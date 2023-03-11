import 'package:flutter/material.dart';

@immutable
class Breakpoint {
  final double start;
  final double end;
  final String? name;
  final dynamic? data;

  const Breakpoint(
      {required this.start, required this.end, this.name, this.data});

  Breakpoint copyWith({
    double? start,
    double? end,
    String? name,
    dynamic data,
  }) =>
      Breakpoint(
        start: start ?? this.start,
        end: end ?? this.end,
        name: name ?? this.name,
        data: data ?? this.data,
      );

  @override
  String toString() => 'Breakpoint(start: $start, end: $end, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Breakpoint &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end &&
          name == other.name;

  @override
  int get hashCode => start.hashCode * end.hashCode * name.hashCode;
}
