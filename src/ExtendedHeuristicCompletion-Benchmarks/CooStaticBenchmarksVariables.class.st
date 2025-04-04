"
`CoStaticBenchmarksVariables` is a subclass of `CoStaticBenchmarks`  focuses on benchmarking variable name (Class Name) completions. It measures the effectiveness of completion algorithms in predicting variable names based on given prefixes. The class includes methods for extracting variable name prefixes, fetching top-ranked completion candidates, and tracking execution performance through various metrics.""


## Typical Usage:


### First way (We recommand to use this one :):


```smalltalk
global := CoStaticBenchmarksVariables runAllOnClass: CompletionSorter package.

global := CoStaticBenchmarksVariables runAllOnPackage: 'NECompletion'.

""To add the which templates of heurisitcs you want to use""

global := CoStaticBenchmarksVariables runAllOnPackage: 'NECompletion' heuristics: [ :b | CoStaticBenchmarksVariables defaultHeuristics: b ].

global := CoStaticBenchmarksVariables runAllOnPackage: 'NECompletion' heuristics: [ :b | CoStaticBenchmarksVariables customHeuristics: b ].

```

### Second way:


```smalltalk
global := CoStaticBenchmarksVariables new
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
staticHeuristics := CoStaticBenchmarksVariables new
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
benchA := CoStaticBenchmarksVariables new
    scope: (CoBenchmarkPackage on: CompletionSorter package);
    builder: (CoGlobalSorterResultSetBuilder new
        sorterClass: AlphabeticSorter;
        yourself);
    run.


benchB := CoStaticBenchmarksVariables new
    scope: (CoBenchmarkPackage on: SpAbstractValidation package);
    builder: (CoGlobalSorterResultSetBuilder new
        sorterClass: AlphabeticSorter;
        yourself);
    run.


comparison := benchA diff: benchB.
```
"
Class {
	#name : 'CooStaticBenchmarksVariables',
	#superclass : 'CooStaticBenchmarks',
	#category : 'ExtendedHeuristicCompletion-Benchmarks',
	#package : 'ExtendedHeuristicCompletion-Benchmarks'
}

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> benchCallsite: aVariable atPosition: aPosition [

	| oldName |
	oldName := aVariable name.
	2 to: (self maxPrefixSizeFor: aVariable) do: [ :index |
		| prefix startTime startMemory completion candidates completionIndex |
		startTime := self startTimeMeasurement.
		startMemory := self startMemoryMeasurement.

		prefix := self extractPrefixFrom: oldName at: index.
		aVariable name: prefix.
		
		completion := self
			              buildCompletionFor: aVariable
			              atPosition: aPosition.

		candidates := self
			              fetchTopCandidatesFrom: completion
			              usingPrefix: prefix.
		completionIndex := self
			                   findCompletionIndexFor: oldName
			                   inCandidates: candidates.

		self
			trackCompletionResultsFor: oldName
			atIndex: completionIndex
			withPrefix: prefix.

		self logMemoryUsageSince: startMemory forPrefixSize: prefix size.
		self logExecutionTimeSince: startTime forPrefixSize: prefix size ].
	
		aVariable name: oldName 

]

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> buildCompletionFor: aVariableNode atPosition: aPosition [

	^ builder
		  node: aVariableNode;
		  completionContext: (CoBenchmarkVariableContext new
				   callsite: aVariableNode;
				   position: aPosition;
				   yourself);
		  buildCompletion
]

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> extractPrefixFrom: variable at: index [

	^ variable copyFrom: 1 to: index
]

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> fetchTopCandidatesFrom: completion usingPrefix: prefix [

	completion replaceFilterWith:
		(CoCaseSensitiveBeginsWithFilter filterString: prefix).
	^ completion first: 10
]

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> findCompletionIndexFor: variableName inCandidates: candidates [
	^ (candidates collect: [ :each | each contents ]) 
			indexOf: variableName
]

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> logExecutionTimeSince: startTime forPrefixSize: prefixSize [

	| executionTime |
	executionTime := Time millisecondClockValue - startTime.
	self logTime: executionTime forPrefix: prefixSize
]

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> logMemoryUsageSince: startMemory forPrefixSize: prefixSize [

	| memoryUsed |
	memoryUsed := self currentMemoryUsage - startMemory.
	self logMemory: memoryUsed forPrefix: prefixSize
]

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> maxPrefixSizeFor: aVariable [

	^ aVariable name size min: 8
]

{ #category : 'running' }
CooStaticBenchmarksVariables >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			(node isVariable and: [ node name first isUppercase ]) 
					ifTrue: [ self benchCallsite: node atPosition: node start ] ] ]
]

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> startMemoryMeasurement [

	^ self currentMemoryUsage
]

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> startTimeMeasurement [

	^ Time millisecondClockValue
]

{ #category : 'benchmarks' }
CooStaticBenchmarksVariables >> trackCompletionResultsFor: receiver atIndex: completionIndex withPrefix: prefix [

	| previousResultsPerIndexPerPrefixSize |
	previousResultsPerIndexPerPrefixSize := completionBenchs
		                                        at: completionIndex
		                                        at: prefix size
		                                        ifAbsent: [
			                                        {
				                                        0.
				                                        Set new } ].
	previousResultsPerIndexPerPrefixSize second add: receiver.
	completionBenchs at: completionIndex at: prefix size put: {
			(previousResultsPerIndexPerPrefixSize first + 1).
			previousResultsPerIndexPerPrefixSize second }
]

{ #category : 'enumerating' }
CooStaticBenchmarksVariables >> valuesDo: aFullBlockClosure [ 
	self shouldBeImplemented.
]
