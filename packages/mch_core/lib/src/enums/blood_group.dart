/// Blood groups from MCH Handbook Page 7
enum BloodGroup {
  aPositive('A+'),
  aNegative('A-'),
  bPositive('B+'),
  bNegative('B-'),
  oPositive('O+'),
  oNegative('O-'),
  abPositive('AB+'),
  abNegative('AB-');

  const BloodGroup(this.label);
  final String label;
}