/// HIV Test Results from MCH Handbook Page 7
enum HivTestResult {
  reactive('Reactive'),
  nonReactive('Non-Reactive'),
  notTested('Not Tested'),
  inconclusive('Inconclusive');

  const HivTestResult(this.label);
  final String label;
}