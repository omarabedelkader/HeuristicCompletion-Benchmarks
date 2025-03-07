"
`CoStaticBenchmarksMessage` is a subclass of `CoStaticBenchmarks` specializes in benchmarking method message completions. It evaluates the performance of completion algorithms by tracking the accuracy of suggestions, execution time, and memory consumption based on method selector prefixes. The class provides methods for generating completions, extracting prefixes, ranking results, and logging performance metrics.""


## Typical Usage:




### First way (We recommand to use this one :):


```smalltalk
global := CoStaticBenchmarksMessage runAllOnClass: CompletionSorter package.

global := CoStaticBenchmarksMessage runAllOnPackage: 'NECompletion'.

""To add the which templates of heurisitcs you want to use""

global := CoStaticBenchmarksMessage runAllOnPackage: 'NECompletion' heuristics: [ :b | CoStaticBenchmarksMessage defaultHeuristics: b ].

global := CoStaticBenchmarksMessage runAllOnPackage: 'NECompletion' heuristics: [ :b | CoStaticBenchmarksMessage customHeuristics: b ].

```

### Second way:


```smalltalk
global := CoStaticBenchmarksMessage new
    scope: (CoBenchmarkPackage on: CompletionSorter package);
    builder: (CoGlobalSorterResultSetBuilder new
        sorterClass: AlphabeticSorter;
        yourself);
    run.

""Get the total accuracy of finding the right result among the first 3 results when typing 2 characters.""
(global accuracyForCompletionIndex: (1 to: 3) withPrefixSize: 2) asFloat.

""To see how well completions do on 5-character selectors""

global := accuracyPerSelectorLength: 5

```
### Second way:

```smalltalk
staticHeuristics := CoStaticBenchmarksMessage new
    scope: (CoBenchmarkPackage on: SpAbstractAdapter package);
    builder: CoASTHeuristicsResultSetBuilder new;
    run.

""Get the total accuracy of finding the right result among the first 3 when typing 2 characters.""
(staticHeuristics accuracyForCompletionIndex: (1 to: 3) withPrefixSize: 2) asFloat.
```


## Extracting the tables into Latex:

```smalltalk
latex := (global at: #SizeSorter) latexResultsFor: #mmr.
```

## Comparing the tables 

```smalltalk
benchA := CoStaticBenchmarksMessage new
    scope: (CoBenchmarkPackage on: CompletionSorter package);
    builder: (CoGlobalSorterResultSetBuilder new
        sorterClass: AlphabeticSorter;
        yourself);
    run.


benchB := CoStaticBenchmarksMessage new
    scope: (CoBenchmarkPackage on: SpAbstractValidation package);
    builder: (CoGlobalSorterResultSetBuilder new
        sorterClass: AlphabeticSorter;
        yourself);
    run.


comparison := benchA diff: benchB.
```
"
Class {
	#name : 'CooStaticBenchmarksMessage',
	#superclass : 'CooStaticBenchmarks',
	#category : 'HeuristicCompletion-OBenchmarks-Tests',
	#package : 'HeuristicCompletion-OBenchmarks-Tests'
}

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> benchCallsite: aMessageNode atPosition: aPosition [

	| originalSelector |
	originalSelector := aMessageNode selector.

	2 to: (self maxPrefixSizeFor: originalSelector) do: [ :index |
		| prefix startTime startMemory completion candidates completionIndex |
		startTime := self startTimeMeasurement.
		startMemory := self startMemoryMeasurement.

		prefix := self extractPrefixFrom: originalSelector at: index.
		aMessageNode selector: prefix.

		completion := self
			              buildCompletionFor: aMessageNode
			              atPosition: aPosition.

		candidates := self
			              fetchTopCandidatesFrom: completion
			              usingPrefix: prefix.
		completionIndex := self
			                   findCompletionIndexFor: originalSelector
			                   inCandidates: candidates.

		self
			trackCompletionResultsFor: originalSelector
			atIndex: completionIndex
			withPrefix: prefix.

		self logMemoryUsageSince: startMemory forPrefixSize: prefix size.
		self logExecutionTimeSince: startTime forPrefixSize: prefix size ].

	aMessageNode selector: originalSelector
]

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> buildCompletionFor: aMessageNode atPosition: aPosition [

	^ builder
		  node: aMessageNode;
		  completionContext: (CoBenchmarkContext new
				   callsite: aMessageNode;
				   position: aPosition;
				   yourself);
		  buildCompletion
]

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> extractPrefixFrom: selector at: index [

	^ selector copyFrom: 1 to: index
]

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> fetchTopCandidatesFrom: completion usingPrefix: prefix [

	completion replaceFilterWith:
		(CoCaseSensitiveBeginsWithFilter filterString: prefix).
	^ completion first: 10
]

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> findCompletionIndexFor: originalSelector inCandidates: candidates [

	^ (candidates collect: [ :each | each contents ]) indexOf:
		  originalSelector
]

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> logExecutionTimeSince: startTime forPrefixSize: prefixSize [

	| executionTime |
	executionTime := Time millisecondClockValue - startTime.
	self logTime: executionTime forPrefix: prefixSize
]

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> logMemoryUsageSince: startMemory forPrefixSize: prefixSize [

	| memoryUsed |
	memoryUsed := self currentMemoryUsage - startMemory.
	self logMemory: memoryUsed forPrefix: prefixSize
]

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> maxPrefixSizeFor: selector [

	^ selector size min: 8
]

{ #category : 'running' }
CooStaticBenchmarksMessage >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			node isMessage ifTrue: [
				self benchCallsite: node atPosition: node keywordsIntervals first ] ] ]
]

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> startMemoryMeasurement [

	^ self currentMemoryUsage
]

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> startTimeMeasurement [

	^ Time millisecondClockValue
]

{ #category : 'benchmarks' }
CooStaticBenchmarksMessage >> trackCompletionResultsFor: originalSelector atIndex: completionIndex withPrefix: prefix [

	| previousResultsPerIndexPerPrefixSize |
	previousResultsPerIndexPerPrefixSize := completionBenchs
		                                        at: completionIndex
		                                        at: prefix size
		                                        ifAbsent: [
			                                        {
				                                        0.
				                                        Set new } ].
	previousResultsPerIndexPerPrefixSize second add: originalSelector.
	completionBenchs at: completionIndex at: prefix size put: {
			(previousResultsPerIndexPerPrefixSize first + 1).
			previousResultsPerIndexPerPrefixSize second }
]
