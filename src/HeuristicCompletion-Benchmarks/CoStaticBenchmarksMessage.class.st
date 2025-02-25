Class {
	#name : 'CoStaticBenchmarksMessage',
	#superclass : 'CoStaticBenchmarks',
	#category : 'HeuristicCompletion-Benchmarks',
	#package : 'HeuristicCompletion-Benchmarks'
}

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
