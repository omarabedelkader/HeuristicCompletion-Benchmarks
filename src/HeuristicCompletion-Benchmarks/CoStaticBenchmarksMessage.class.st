"
`CoStaticBenchmarksMessage` is a subclass of `CoStaticBenchmarks` specializes in benchmarking method message completions. It evaluates the performance of completion algorithms by tracking the accuracy of suggestions, execution time, and memory consumption based on method selector prefixes. The class provides methods for generating completions, extracting prefixes, ranking results, and logging performance metrics.""


## Typical Usage:




### First way (We recommand to use this one :):


```smalltalk
global := CoStaticBenchmarksMessage runAllOnClass: SpAbstractAdapter package.

global := CoStaticBenchmarksMessage runAllOnPackage: 'NECompletion'.

""To add the which templates of heurisitcs you want to use""

global := CoStaticBenchmarksMessage runAllOnPackage: 'NECompletion' heuristics: [ :b | CoStaticBenchmarksMessage defaultHeuristics: b ].

global := CoStaticBenchmarksMessage runAllOnPackage: 'NECompletion' heuristics: [ :b | CoStaticBenchmarksMessage customHeuristics: b ].

```

### Second way:


```smalltalk
global := CoStaticBenchmarksMessage new
    scope: (CoBenchmarkPackage on: SpAbstractAdapter package);
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
    scope: (CoBenchmarkPackage on: SpAbstractAdapter package);
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
	#name : 'CoStaticBenchmarksMessage',
	#superclass : 'CoStaticBenchmarks',
	#category : 'HeuristicCompletion-Benchmarks',
	#package : 'HeuristicCompletion-Benchmarks'
}

{ #category : 'running' }
CoStaticBenchmarksMessage class >> customHeuristics: aBuilder [

	aBuilder messageHeuristic: (aBuilder newHeuristicBuilder
			 add: CoSessionMessagesHeuristic new;
			 build)
]

{ #category : 'running' }
CoStaticBenchmarksMessage class >> defaultHeuristics: aBuilder [
	
	aBuilder messageHeuristic: (aBuilder newHeuristicBuilder
			 		add: CoSelfMessageHeuristic new;
		add: CoSuperMessageHeuristic new;
		add: CoTypedReceiverMessageHeuristic new;
		add: CoInitializeInferencedMessageHeuristic new;
		add: CoLiteralMessageHeuristic new;
		add: CoGlobalVariableMessageHeuristic new;
		add: CoVariableWithTypeNameMessageHeuristic new;
		"add: CoVariableValueMessageHeuristic new;"
		add: CoUnknownMessageHeuristic new;
			 build)
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> benchCallsite: aMessageNode atPosition: aPosition [

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
		Transcript cr; show: '--- Benchmarking Callsite for Target: ', originalSelector ; cr.
		Transcript show: 'Prefix: ''', prefix, ''' (size: ', index printString, ')';
			show: '  ->  Completion Index: ', completionIndex printString;
			show: '  ->  Found? ', (completionIndex > 0) asString; cr.
		Transcript show: 'Top Candidates: ', (candidates collect: #contents) printString; cr.

		self trackCompletionResultsFor: originalSelector atIndex: completionIndex withPrefix: prefix.
		self logExecutionTimeSince: startTime forPrefixSize: prefix size.
		self logMemoryUsageSince: startMemory forPrefixSize: prefix size.

		"Log Accuracy, MRR, NDCG, Rank Distribution, and Recall@K"
		Transcript show: 'Accuracy: ', (self accuracyForCompletionIndex: (1 to: 3) withPrefixSize: prefix size) printString; cr.
		Transcript show: 'Mean Reciprocal Rank (MRR): ', (self mmrForPrefixSize: prefix size) printString; cr.
		Transcript show: 'Normalized Discounted Cumulative Gain (NDCG): ', (self ndcgForPrefixSize: prefix size) printString; cr.
		Transcript show: 'Rank Distribution: ', (self rankDistributionForPrefixSize: prefix size) printString; cr.
		Transcript show: 'Recall@3: ', (self recallAtK: 3 withPrefixSize: prefix size) printString; cr.
		Transcript show: 'Recall@5: ', (self recallAtK: 5 withPrefixSize: prefix size) printString; cr.
		Transcript show: 'Recall@10: ', (self recallAtK: 10 withPrefixSize: prefix size) printString; cr.
		self
			trackCompletionResultsFor: originalSelector
			atIndex: completionIndex
			withPrefix: prefix.

		self logMemoryUsageSince: startMemory forPrefixSize: prefix size.
		self logExecutionTimeSince: startTime forPrefixSize: prefix size ].

	aMessageNode selector: originalSelector
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> buildCompletionFor: aMessageNode atPosition: aPosition [

	^ builder
		  node: aMessageNode;
		  completionContext: (CoBenchmarkContext new
				   callsite: aMessageNode;
				   position: aPosition;
				   yourself);
		  buildCompletion
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> extractPrefixFrom: selector at: index [

	^ selector copyFrom: 1 to: index
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> fetchTopCandidatesFrom: completion usingPrefix: prefix [

	completion replaceFilterWith:
		(CoCaseSensitiveBeginsWithFilter filterString: prefix).
	^ completion first: 10
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> findCompletionIndexFor: originalSelector inCandidates: candidates [

	^ (candidates collect: [ :each | each contents ]) indexOf:
		  originalSelector
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> logExecutionTimeSince: startTime forPrefixSize: prefixSize [

	| executionTime |
	executionTime := Time millisecondClockValue - startTime.
	self logTime: executionTime forPrefix: prefixSize
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> logMemoryUsageSince: startMemory forPrefixSize: prefixSize [

	| memoryUsed |
	memoryUsed := self currentMemoryUsage - startMemory.
	self logMemory: memoryUsed forPrefix: prefixSize
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> maxPrefixSizeFor: selector [

	^ selector size min: 8
]

{ #category : 'running' }
CoStaticBenchmarksMessage >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			node isMessage ifTrue: [
				self benchCallsite: node atPosition: node keywordsIntervals first ] ] ]
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> startMemoryMeasurement [

	^ self currentMemoryUsage
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> startTimeMeasurement [

	^ Time millisecondClockValue
]

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> trackCompletionResultsFor: originalSelector atIndex: completionIndex withPrefix: prefix [

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
