# HeuristicCompletion-Benchmarks

HeuristicCompletion-Benchmarks measures the accuracy and other metrics of code completion suggestions by testing various prefix lengths on method calls within a given scope.


# Loading package:

```smalltalk

Metacello new
  githubUser: 'omarabedelkader' project: 'HeuristicCompletion-Benchmarks' commitish: 'main' path: 'src';
  baseline: 'ExtendedHeuristicCompletion';
  load

```
