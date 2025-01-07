"
I run a series of completion benchmarks over a static scope.
I take all existing callsites in a scope (a class, a package) and run the completion with different prefixes (2 to 8), asking for 10 results.
Then I check if the selector at that callsite is in those elements, and in what position.
I accumulate the results in a table per index in the results and prefix size.

I have an inspector extension to show the results in a table.

Examples:

```
global := CoStaticBenchmarks new
	scope: (CoBenchmarkPackage on: SpAbstractAdapter package);
	builder: (CoGlobalSorterResultSetBuilder new
		sorterClass: AlphabeticSorter;
		yourself);
	run.

""Get the total accuracy of finding the right result among the first three when typing 2 characters.""
(global accuracyForCompletionIndex: (1 to: 3) withPrefixSize: 2) asFloat. 
```

```
staticHeuristics := CoStaticBenchmarks new
	scope: (CoBenchmarkPackage on: SpAbstractAdapter package);
	builder: CoASTHeuristicsResultSetBuilder new;
	run.

""Get the total accuracy of finding the right result among the first three when typing 2 characters.""
(staticHeuristics accuracyForCompletionIndex: (1 to: 3) withPrefixSize: 2) asFloat. 
```
"
Class {
	#name : 'CoStaticBenchmarks',
	#superclass : 'Object',
	#instVars : [
		'scope',
		'completionBenchs',
		'builder',
		'completionTimes'
	],
	#category : 'HeuristicCompletion-Model-Benchmarks',
	#package : 'HeuristicCompletion-Model-Benchmarks'
}

{ #category : 'running' }
CoStaticBenchmarks class >> runFor: aClass [

	^ self new
		scope: aClass;
		run
]

{ #category : 'inspector' }
CoStaticBenchmarks >> accuracyForCompletionIndex: completionIndexRange withPrefixSize: prefixSize [

	| totalEntries |
	totalEntries := self totalEntriesPerPrefixSize: prefixSize.
	totalEntries = 0 ifTrue: [ ^ 0 ].

	^ (completionIndexRange sum: [ :index |
		(completionBenchs at: index at: prefixSize ifAbsent: [ {0} ]) first
	]) / totalEntries
]

{ #category : 'inspector' }
CoStaticBenchmarks >> averageTimeForPrefix: prefixSize [

    | times |
    times := completionTimes at: prefixSize ifAbsent: [ #( 0 0 ) ].
    times second = 0
        ifTrue: [ ^ 0 ]
        ifFalse: [ ^ times first / times second ]
]

{ #category : 'benchmarks' }
CoStaticBenchmarks >> benchCallsite: aMessageNode atPosition: aPosition [
 
    | originalSelector |
    originalSelector := aMessageNode selector.

    2 to: (aMessageNode selector size min: 8) do: [ :index | 
        | prefix startTime endTime executionTime 
          completion candidates completionIndex 
          previousResultsPerIndexPerPrefixSize |

        "Start timing"
        startTime := Time millisecondClockValue.

        prefix := originalSelector copyFrom: 1 to: index.
        aMessageNode selector: prefix.

        completion := builder
            node: aMessageNode;
            completionContext: (CoBenchmarkContext new
                callsite: aMessageNode;
                position: aPosition;
                yourself);
            buildCompletion.

        completion replaceFilterWith: (CoCaseSensitiveBeginsWithFilter filterString: prefix).
        candidates := completion first: 10.

        completionIndex := (candidates collect: [ :each | each contents ]) indexOf: originalSelector.

        "Existing logic: update completionBenchs dictionary"
        previousResultsPerIndexPerPrefixSize := completionBenchs
            at: completionIndex
            at: prefix size
            ifAbsent: [ { 0 . Set new } ].
        previousResultsPerIndexPerPrefixSize second add: originalSelector.
        completionBenchs
            at: completionIndex
            at: prefix size
            put: { previousResultsPerIndexPerPrefixSize first + 1 . previousResultsPerIndexPerPrefixSize second }.

        "Stop timing and record it"
        endTime := Time millisecondClockValue.
        executionTime := endTime - startTime.
        self logTime: executionTime forPrefix: prefix size
    ].

    "Restore the original selector"
    aMessageNode selector: originalSelector
]

{ #category : 'accessing' }
CoStaticBenchmarks >> builder: aCompletionBuilder [

	builder := aCompletionBuilder
]

{ #category : 'inspector' }
CoStaticBenchmarks >> completionIndexes [

	^ { 1 to: 1.
	  2 to: 2.
	  3 to: 3.
	  4 to: 10.
	  0 to: 0.
	}
]

{ #category : 'scoring' }
CoStaticBenchmarks >> gradeForPrefixSize: prefixSize [

	^ self accuracyForCompletionIndex: (2 to: 8) withPrefixSize: prefixSize
]

{ #category : 'initialization' }
CoStaticBenchmarks >> initialize [

	super initialize.
	completionBenchs := Dictionary new.
	builder := CoASTHeuristicsResultSetBuilder new.
	completionTimes := Dictionary new.   "Initialize the timing dictionary"	
]

{ #category : 'inspector' }
CoStaticBenchmarks >> inspectionResults [

	<inspectorPresentationOrder: 0 title: 'Results'>
	| table |
	table := SpTablePresenter new
		         items: self completionIndexes;
		         addColumn: (SpCompositeTableColumn new
				          title: 'Prefix';
				          addColumn:
					          (SpStringTableColumn evaluated: [ :completionIndexRange |
							           | label |
							           label := '% '.
							           label := label , (completionIndexRange size = 1
									                     ifTrue: [
										                     { 'fail'. '1st'. '2nd'. '3rd' } at:
												                     completionIndexRange first + 1 ]
									                     ifFalse: [
										                     completionIndexRange first asString
										                     , '-'
										                     , completionIndexRange last asString ]).
							           label ]);
				          yourself).
	self prefixSizes do: [ :prefixSize |
		table addColumn: (SpStringTableColumn
				 title: prefixSize asString
				 evaluated: [ :completionIndexRange |
					 | float |
					 float := self
						          accuracyForCompletionIndex: completionIndexRange
						          withPrefixSize: prefixSize.
					 float * 100 printShowingDecimalPlaces: 2 ]) ].
	^ table
]

{ #category : 'inspector' }
CoStaticBenchmarks >> logTime: executionTime forPrefix: prefixSize [

    | times |
    times := completionTimes
        at: prefixSize
        ifAbsent: [ #( 0 0 )  ].  "Default is { totalTime = 0 . count = 0 }"
    completionTimes
        at: prefixSize
        put: { times first + executionTime.  times second + 1 }.
]

{ #category : 'inspector' }
CoStaticBenchmarks >> prefixSizes [

	^ 2 to: 8
]

{ #category : 'printing' }
CoStaticBenchmarks >> printOn: aStream [

	aStream
		print: builder;
		nextPutAll: '(';
		print: scope;
		nextPutAll: ')'
]

{ #category : 'running' }
CoStaticBenchmarks >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			node isMessage ifTrue: [
				self benchCallsite: node atPosition: node keywordsIntervals first ]
		]
	]
]

{ #category : 'accessing' }
CoStaticBenchmarks >> scope: aClass [

	scope := aClass
]

{ #category : 'scoring' }
CoStaticBenchmarks >> score [

	^ ((1 to: 7) sum: [ :i | (self gradeForPrefixSize: i + 1) / i ]) * 100 / ((1 to: 7) sum: [ :index | 1/index ])
]

{ #category : 'running' }
CoStaticBenchmarks >> timeResults [

    <inspectorPresentationOrder: 1 title: 'Time Results'>
    | table |
    table := SpTablePresenter new
        items: self prefixSizes;  "2..8"
        addColumn: (
            SpStringTableColumn
                title: 'Prefix'
                evaluated: [ :prefixSize | prefixSize asString ]
        );
        addColumn: (
            SpStringTableColumn
                title: 'Total (ms)'
                evaluated: [ :prefixSize | (self totalTimeForPrefix: prefixSize) asString ]
        );
        addColumn: (
            SpStringTableColumn
                title: 'Average (ms)'
                evaluated: [ :prefixSize | 
                    (self averageTimeForPrefix: prefixSize) 
                        roundTo: 0.1;  "some rounding if desired"
                        asString 
                ]
        );
        yourself.

    ^ table
]

{ #category : 'running' }
CoStaticBenchmarks >> totalEntriesPerPrefixSize: aPrefixSize [

	^ completionBenchs sum: [ :benchsPerPrefix | (benchsPerPrefix at: aPrefixSize ifAbsent: [ {0} ]) first ]
]

{ #category : 'running' }
CoStaticBenchmarks >> totalTime [

    "Sum over all prefix sizes"
    ^ completionTimes values
        inject: 0
        into: [ :sum :timeArray | sum + timeArray first ]
]

{ #category : 'running' }
CoStaticBenchmarks >> totalTimeForPrefix: prefixSize [

    | times |
    times := completionTimes at: prefixSize ifAbsent: [ #( 0 0 ) ].
    ^ times first  "the accumulated total time in ms"
]

{ #category : 'running' }
CoStaticBenchmarks >> totalTimeSummary [

    <inspectorPresentationOrder: 2 title: 'Total Time (ms)'>
    ^ self totalTime
]
