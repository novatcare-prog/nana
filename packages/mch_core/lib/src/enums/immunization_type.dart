/// Immunization schedule from MCH Handbook Page 33-34
enum ImmunizationType {
  bcg('BCG'),
  bopv('bOPV'),
  ipv('IPV'),
  pentavalent('Pentavalent'),
  pcv10('PCV10'),
  rotavirus('Rotavirus'),
  measlesRubella('Measles-Rubella'),
  yellowFever('Yellow Fever');

  const ImmunizationType(this.label);
  final String label;
}