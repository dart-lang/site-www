bool shutDownRequested() => true;
void processIncomingRequests() {}

class Candidate {
  int yearsExperience = 2;
  void interview() {}
}

void main() {
  while (true) {
    if (shutDownRequested()) break;
    processIncomingRequests();
  }

  var candidates = [new Candidate(), new Candidate(), new Candidate()];

  for (int i = 0; i < candidates.length; i++) {
    var candidate = candidates[i];
    if (candidate.yearsExperience < 5) {
      continue;
    }
    candidate.interview();
  }

  candidates.where((c) => c.yearsExperience >= 5).forEach((c) => c.interview());
}
