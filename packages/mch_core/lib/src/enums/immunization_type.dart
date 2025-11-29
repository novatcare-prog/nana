import 'package:freezed_annotation/freezed_annotation.dart';

/// Immunization schedule from MCH Handbook Page 33-34
enum ImmunizationType {
  @JsonValue('BCG')
  bcg('BCG'),
  
  @JsonValue('bOPV')
  bopv('bOPV'),
  
  @JsonValue('IPV')
  ipv('IPV'),
  
  @JsonValue('Pentavalent')
  pentavalent('Pentavalent'),
  
  @JsonValue('PCV10')
  pcv10('PCV10'),
  
  @JsonValue('Rotavirus')
  rotavirus('Rotavirus'),
  
  @JsonValue('Measles-Rubella')
  measlesRubella('Measles-Rubella'),
  
  @JsonValue('Yellow Fever')
  yellowFever('Yellow Fever');

  const ImmunizationType(this.label);
  final String label;
}