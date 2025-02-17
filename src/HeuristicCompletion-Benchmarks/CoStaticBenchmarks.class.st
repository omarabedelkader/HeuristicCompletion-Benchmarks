"
`CoStaticBenchmarks`, is designed to run completion benchmarks over a given **scope** (typically a class or package). It explores **completion suggestions** by trying out various prefix sizes (from 2 to 8 characters) and recording:

1. **Accuracy** (whether the correct selector is found among the top 10 suggestions and at which index).
2. **Timing** (the total and average time taken to compute suggestions for each prefix size).

Below is a short overview of the main responsibilities and methods:

## Main Responsibilities

1. **Setup and Running (`run`, `runFor:`)**
   - `run` iterates through all methods in the given scope, parsing them and finding message callsites to benchmark.
   - `runFor:` is a convenience class method to instantiate and immediately run benchmarks for a given class.

2. **Benchmarking a Callsite (`benchCallsite:atPosition:`)**
   - For each callsite, it loops from a prefix length of 2 to 8 characters (or fewer if the selector is shorter).
   - It records whether the original selector was found among the top 10 completion candidates and at which index.
   - It also tracks the time it took to produce the suggestions, accumulating them in `completionTimes`.

3. **Measuring Accuracy (`accuracyForCompletionIndex:withPrefixSize:`)**
   - Determines how often the correct selector is found within specific top-index ranges (e.g., 1st, 2nd, 3rd) for a given prefix size.
   - This is computed by dividing the number of successful finds by the total number of attempts.

4. **Measuring Time (`logTime:forPrefix:`, `totalTimeForPrefix:`)**
   - Each benchmark run logs the execution time in `completionTimes`.
   - Methods such as `totalTimeForPrefix:` and `averageTimeForPrefix:` allow for aggregating and presenting these timings.

5. **Inspection and Presentation (`inspectionResults`, `timeResults`)**
   - Includes methods decorated with `<inspectorPresentationOrder:>` to present **accuracy results** in a table (via `SpTablePresenter`).
   - Presents **timing results** in a similar way, showing total and average execution times per prefix size.

## Key Data Structures

- **`completionBenchs`**: A nested dictionary storing the count of how many times a selector was found at a certain prefix size and position (index in the top-10 list).
- **`completionTimes`**: A dictionary storing the total and count of all execution times, keyed by prefix size.

## Typical Usage

Here is an example of how you might run benchmarks on a given package or class:

```smalltalk
global := CoStaticBenchmarks new
    scope: (CoBenchmarkPackage on: SpAbstractAdapter package);
    builder: (CoGlobalSorterResultSetBuilder new
        sorterClass: AlphabeticSorter;
        yourself);
    run.

""Get the total accuracy of finding the right result among the first 3 results when typing 2 characters.""
(global accuracyForCompletionIndex: (1 to: 3) withPrefixSize: 2) asFloat.
```

And similarly:

```smalltalk
staticHeuristics := CoStaticBenchmarks new
    scope: (CoBenchmarkPackage on: SpAbstractAdapter package);
    builder: CoASTHeuristicsResultSetBuilder new;
    run.

""Get the total accuracy of finding the right result among the first 3 when typing 2 characters.""
(staticHeuristics accuracyForCompletionIndex: (1 to: 3) withPrefixSize: 2) asFloat.
```

To show all the Benchmarks use:

```smalltalk
global := CoStaticBenchmarks runAllOnPackage: SpAbstractAdapter package 
```

To extract the table in latex code to a specific sorter :

```smalltalk
latexString := (global at: #AlphabeticSorter) latexInspectionResults.
latexString := (global at: #AlphabeticSorter) latexTimeResults.
latexString := (global at: #AlphabeticSorter) latexMRResults.

```

To see how well completions do on 5-character selectors:

```smalltalk

accuracyPerSelectorLength: 5

```

Using these benchmarks, you can measure:

- **Which prefix sizes produce the best completion accuracy.**
- **How quickly the suggestions are generated** (i.e., performance considerations).
- **Overall completion performance** for different sets of heuristics or sorters.

"
Class {
	#name : 'CoStaticBenchmarks',
	#superclass : 'Object',
	#instVars : [
		'scope',
		'completionBenchs',
		'builder',
		'completionTimes',
		'memoryUsages'
	],
	#category : 'HeuristicCompletion-Benchmarks',
	#package : 'HeuristicCompletion-Benchmarks'
}

{ #category : 'running' }
CoStaticBenchmarks class >> runAllOnPackage: aPackage [
    "Runs the CoStaticBenchmarks for every sorter class in sorterClasses,
    all using the given package as the scope. 
    Answers a Dictionary from sorter class symbols to the resulting CoStaticBenchmarks instance 
    so you can inspect or retrieve results later."
    
    | results |
    results := Dictionary new.
    
    self sorterClasses do: [ :sorterSymbol |
        | sorterClass benchmark |
        
        "Retrieve the actual class object for the symbol"
        sorterClass := Smalltalk at: sorterSymbol ifAbsent: [ 
            self error: (String streamContents: [ :s | 
    				s nextPutAll: 'Sorter class '.
    				s nextPutAll: sorterSymbol asString.
    				s nextPutAll: ' not found in Smalltalk image.'
			])
        ].

        "Create and run a new benchmark for that sorter"
        benchmark := self new
            scope: (CoBenchmarkPackage on: aPackage);
            builder: (CoGlobalSorterResultSetBuilder new
                sorterClass: sorterClass;
                yourself);
            yourself.

        benchmark run.

        "Store the instance so we can retrieve/inspect it later"
        results at: sorterSymbol put: benchmark
    ].

    ^ results
]

{ #category : 'running' }
CoStaticBenchmarks class >> runFor: aClass [

	^ self new
		scope: aClass;
		run
]

{ #category : 'running' }
CoStaticBenchmarks class >> sorterClasses [

    "Answers an array of the symbols of all sorter classes to be run."
    ^ #( AlphabeticSorter ReverseAlphabeticSorter NoSorter SizeSorter )
]

{ #category : 'metrics' }
CoStaticBenchmarks >> accuracyForCompletionIndex: completionIndexRange withPrefixSize: prefixSize [

	| totalEntries |
	totalEntries := self totalEntriesPerPrefixSize: prefixSize.
	totalEntries = 0 ifTrue: [ ^ 0 ].
	^ (completionIndexRange sum: [ :index |
		(completionBenchs at: index at: prefixSize ifAbsent: [ {0} ]) first
	]) / totalEntries
]

{ #category : 'inspector' }
CoStaticBenchmarks >> accuracyInspectionResults [

	<inspectorPresentationOrder: 0 title: 'Accuracy'>
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

{ #category : 'metrics' }
CoStaticBenchmarks >> accuracyPerSelectorLength: selectorLength [ 

    | relevantCallsites correctCount totalCount |
    relevantCallsites := 0.
    correctCount := 0.
    totalCount := 0.
    completionBenchs keysAndValuesDo: [ :rank :prefixDict |
        prefixDict keysAndValuesDo: [ :pSize :info |
            | count usedSelectors |
            count := info first. 
            usedSelectors := info second.
            usedSelectors do: [ :sel |
                (sel size = selectorLength) ifTrue: [
                    relevantCallsites := relevantCallsites + 1.
                    rank ~= 0 
                        ifTrue: [ correctCount := correctCount + 1 ]. 
                ].
            ].
            totalCount := totalCount + count
        ]
    ].
    relevantCallsites = 0 ifTrue: [ ^ 0 ].
    ^ correctCount asFloat / relevantCallsites
]

{ #category : 'metrics' }
CoStaticBenchmarks >> averageMemoryForPrefix: prefixSize [ 

    | stats |
    stats := memoryUsages at: prefixSize ifAbsent: [ #( 0 0 ) ].
    stats second = 0
        ifTrue: [ ^ 0 ]
        ifFalse: [ ^ stats first / stats second ]

]

{ #category : 'metrics' }
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
        | prefix
          startTime endTime executionTime
          startMemory endMemory memoryUsed
          completion candidates completionIndex 
          previousResultsPerIndexPerPrefixSize |

        "1) Start timing"
        startTime := Time millisecondClockValue.

        "2) Start memory usage (adjust to your dialect's API)"
        startMemory := self currentMemoryUsage.

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

        "Existing logic to track accuracy..."
        previousResultsPerIndexPerPrefixSize :=
            completionBenchs
                at: completionIndex
                at: prefix size
                ifAbsent: [ { 0 . Set new } ].
        previousResultsPerIndexPerPrefixSize second add: originalSelector.
        completionBenchs
            at: completionIndex
            at: prefix size
            put: { previousResultsPerIndexPerPrefixSize first + 1 .
                   previousResultsPerIndexPerPrefixSize second }.

        "3) Stop memory usage"
        endMemory := self currentMemoryUsage.  "Adjust to your dialect's API"
        memoryUsed := endMemory - startMemory.
        self logMemory: memoryUsed forPrefix: prefix size.

        "4) Stop timing and record it"
        endTime := Time millisecondClockValue.
        executionTime := endTime - startTime.
        self logTime: executionTime forPrefix: prefix size.
    ].
    aMessageNode selector: originalSelector
]

{ #category : 'accessing' }
CoStaticBenchmarks >> builder [

	^ builder
]

{ #category : 'accessing' }
CoStaticBenchmarks >> builder: aCompletionBuilder [

	builder := aCompletionBuilder
]

{ #category : 'accessing' }
CoStaticBenchmarks >> completionBenchs [

	^ completionBenchs
]

{ #category : 'accessing' }
CoStaticBenchmarks >> completionBenchs: anObject [

	completionBenchs := anObject
]

{ #category : 'benchmarks' }
CoStaticBenchmarks >> completionIndexes [

	^ { 1 to: 1.
	  2 to: 2.
	  3 to: 3.
	  4 to: 10.
	  0 to: 0.
	}
]

{ #category : 'accessing' }
CoStaticBenchmarks >> completionTimes [

	^ completionTimes
]

{ #category : 'accessing' }
CoStaticBenchmarks >> completionTimes: anObject [

	completionTimes := anObject
]

{ #category : 'metrics' }
CoStaticBenchmarks >> currentMemoryUsage [

    ^ Smalltalk vm memorySize
]

{ #category : 'benchmarks' }
CoStaticBenchmarks >> gradeForPrefixSize: prefixSize [

	^ self accuracyForCompletionIndex: (2 to: 8) withPrefixSize: prefixSize
]

{ #category : 'initialization' }
CoStaticBenchmarks >> initialize [

	super initialize.
	completionBenchs := Dictionary new.
	builder := CoASTHeuristicsResultSetBuilder new.
	completionTimes := Dictionary new. 
	memoryUsages := Dictionary new.
]

{ #category : 'printing' }
CoStaticBenchmarks >> latexInspectionResults [

    "Generate and return a LaTeX table representation of the data shown in #inspectionResults (accuracy table)."

    | prefixSizes completionIndexRanges |
    ^ String streamContents: [:s |

        prefixSizes := self prefixSizes.
        completionIndexRanges := self completionIndexes.  

        s nextPutAll: '\begin{table}[ht]'; cr.
        s nextPutAll: '\centering'; cr.
        s nextPutAll: '\begin{tabular}{|l'.

        prefixSizes size timesRepeat: [ s nextPutAll: '|c' ].
        s nextPutAll: '|}'; cr.
        s nextPutAll: '\hline'; cr.

        s nextPutAll: 'Prefix'.
        prefixSizes do: [:pSize |
            s nextPutAll: ' & '.
            s nextPutAll: pSize asString
        ].
        s nextPutAll: '\\ \hline'; cr.

        completionIndexRanges do: [:range |
            | label accuracyPercentage |
            label := (range size = 1
                ifTrue: [
                    #('fail' '1st' '2nd' '3rd')
                        at: (range first + 1)
                        ifAbsent: [ range first asString ]
                ]
                ifFalse: [
                    (range first asString), '-', (range last asString)
                ]).
            s nextPutAll: label.

            prefixSizes do: [:pSize |
                accuracyPercentage := (self accuracyForCompletionIndex: range withPrefixSize: pSize) * 100.
                s nextPutAll: ' & '.
                s nextPutAll: (accuracyPercentage printShowingDecimalPlaces: 2)
            ].

            s nextPutAll: '\\ \hline'; cr.
        ].
        s nextPutAll: '\end{tabular}'; cr.
        s nextPutAll: '\caption{Completion Accuracy Results}'; cr.
        s nextPutAll: '\end{table}'; cr.
    ]
]

{ #category : 'printing' }
CoStaticBenchmarks >> latexMMRResults [

    | prefixSizes |
    prefixSizes := self prefixSizes.
    ^ String streamContents: [:s |
        s nextPutAll: '\begin{table}[ht]'; cr.
        s nextPutAll: '\centering'; cr.
        s nextPutAll: '\begin{tabular}{|c|c|}'; cr.
        s nextPutAll: '\hline'; cr.
        s nextPutAll: 'Prefix & MRR \\ \hline'; cr.
        prefixSizes do: [:pSize |
            | val |
            val := (self mmrForPrefixSize: pSize) printShowingDecimalPlaces: 4.
            s nextPutAll: pSize asString; nextPutAll: ' & '.
            s nextPutAll: val; nextPutAll: ' \\ \hline'; cr.
        ].
        s nextPutAll: '\end{tabular}'; cr.
        s nextPutAll: '\caption{Mean Reciprocal Rank by prefix size}'; cr.
        s nextPutAll: '\end{table}'; cr.
    ].

]

{ #category : 'printing' }
CoStaticBenchmarks >> latexTimeResults [

    ^ String streamContents: [:s |
        | prefixArray |
        prefixArray := self prefixSizes.
        s nextPutAll: '\begin{table}[ht]'; cr.
        s nextPutAll: '\centering'; cr.
        s nextPutAll: '\begin{tabular}{|c|c|c|c|}'; cr.
        s nextPutAll: '\hline'; cr.
        s nextPutAll: 'Prefix & Total (ms) & Count & Average (ms)\\ \hline'; cr.

        prefixArray do: [:pSize |
            | total count average |
            total := self totalTimeForPrefix: pSize.
            count := (completionTimes at: pSize ifAbsent: [ #(0 0) ]) second.
            average := self averageTimeForPrefix: pSize.
            s
                nextPutAll: pSize asString; nextPutAll: ' & ';
                print: total; nextPutAll: ' & ';
                print: count; nextPutAll: ' & ';
                print: (average roundTo: 0.01); 
                nextPutAll: '\\ \hline'; cr
        ].
        s nextPutAll: '\end{tabular}'; cr.
        s nextPutAll: '\caption{Completion Time Results}'; cr.
        s nextPutAll: '\end{table}'; cr.
    ]
]

{ #category : 'metrics' }
CoStaticBenchmarks >> logMemory: usage forPrefix: prefixSize [ 

    | stats |
    stats := memoryUsages at: prefixSize ifAbsent: [ #( 0 0 ) ].
    memoryUsages
        at: prefixSize
        put: { stats first + usage. stats second + 1 }.
]

{ #category : 'metrics' }
CoStaticBenchmarks >> logTime: executionTime forPrefix: prefixSize [

    | times |
    times := completionTimes
        at: prefixSize
        ifAbsent: [ #( 0 0 )  ].
    completionTimes
        at: prefixSize
        put: { times first + executionTime.  times second + 1 }.
]

{ #category : 'inspector' }
CoStaticBenchmarks >> memoryInspectionResults [

    <inspectorPresentationOrder: 3 title: 'Memory Usage'>
    | table |
    table := SpTablePresenter new
        items: self prefixSizes;
        addColumn: (
            SpStringTableColumn
                title: 'Prefix'
                evaluated: [ :prefixSize | prefixSize asString ]
        );
        addColumn: (
            SpStringTableColumn
                title: 'Total (bytes)'
                evaluated: [ :prefixSize |
                    (self totalMemoryForPrefix: prefixSize) asString ]
        );
        addColumn: (
            SpStringTableColumn
                title: 'Total (MB)'
                evaluated: [ :prefixSize |
                    ((self totalMemoryForPrefix: prefixSize) / 1024 / 1024 round: 2; printShowingDecimalPlaces:2) asString ]
        );       
        yourself.
    ^ table
]

{ #category : 'accessing' }
CoStaticBenchmarks >> memoryUsages [

	^ memoryUsages
]

{ #category : 'accessing' }
CoStaticBenchmarks >> memoryUsages: anObject [

	memoryUsages := anObject
]

{ #category : 'metrics' }
CoStaticBenchmarks >> mmr [

    "Return the overall Mean Reciprocal Rank across all prefix sizes  (2 through 8) in a single number."
    | totalAll sumAll |
    sumAll := 0.0.
    totalAll := 0.
    (2 to: 8) do: [ :prefixSize |
        | prefixCount |
        prefixCount := self totalEntriesPerPrefixSize: prefixSize.
        totalAll := totalAll + prefixCount.
        sumAll := sumAll + (prefixCount * (self mmrForPrefixSize: prefixSize))
    ].
    totalAll = 0 ifTrue: [ ^ 0 ].
    ^ sumAll / totalAll
]

{ #category : 'metrics' }
CoStaticBenchmarks >> mmrForPrefixSize: prefixSize [

    "Return the Mean Reciprocal Rank (MRR) for the given prefix size.
     MRR = average of 1/rank for each callsite, where 'rank' is the 
     position in the top-10 completions. If the correct method is not 
     in the top 10, its reciprocal rank contribution is 0."

    | total sumOfReciprocalRanks |
    total := self totalEntriesPerPrefixSize: prefixSize.
    total = 0 ifTrue: [ ^ 0 ].

    sumOfReciprocalRanks := 0.0.

    1 to: 10 do: [ :rank |
        | entry rankCount |
        entry := (completionBenchs
                    at: rank
                    ifAbsent: [ Dictionary new ])
                  at: prefixSize
                  ifAbsent: [ #(0 #()) ].

        rankCount := entry first.
        sumOfReciprocalRanks := sumOfReciprocalRanks + (rankCount * (1 / rank))
    ].

    ^ sumOfReciprocalRanks / total
]

{ #category : 'inspector' }
CoStaticBenchmarks >> mmrInspectionResults [

    <inspectorPresentationOrder: 4 title: 'MMR Results'>
    | table |
    table := SpTablePresenter new
        items: self prefixSizes;
        addColumn: (
            SpStringTableColumn
                title: 'Prefix'
                evaluated: [ :prefixSize | prefixSize asString ]
        );
        addColumn: (
            SpStringTableColumn
                title: 'Mean Reciprocal Rank'
                evaluated: [ :prefixSize | 
                    | valueAsString |
                    valueAsString := (self mmrForPrefixSize: prefixSize) printShowingDecimalPlaces: 2.
                    valueAsString
                ]
        );
        yourself.

    ^ table
]

{ #category : 'metrics' }
CoStaticBenchmarks >> ndcgForPrefixSize: prefixSize [

    "Compute Normalized Discounted Cumulative Gain for each prefix size."
    | total relevantCount idealDcg actualDcg |
    total := self totalEntriesPerPrefixSize: prefixSize.
    total isNumber ifFalse: [ ^ 0 ].
    total = 0 ifTrue: [ ^ 0 ].

    actualDcg := 0.0.
    1 to: 10 do: [ :rank |
        | entry rankCount rel factor |
        (completionBenchs respondsTo: #at:ifAbsent:) ifFalse: [ ^ 0 ].
        entry := (completionBenchs 
                    at: rank 
                    ifAbsent: [ Dictionary new ]) 
                  at: prefixSize 
                  ifAbsent: [ #(0 #()) ].

        (entry isArray and: [ entry size > 0 ]) ifFalse: [ ^ 0 ].

        rankCount := entry first.
        rankCount isNumber ifFalse: [ ^ 0 ].

        rel := 1.  
        factor := (2 raisedTo: rel) - 1.
        actualDcg := actualDcg + (rankCount * (factor / ((rank + 1) log: 2))).
    ].

    idealDcg := 0.0.
    relevantCount := total. 

    1 to: (relevantCount min: 10) do: [ :r |
        idealDcg := idealDcg 
            + ( (2 raisedTo: 1) - 1 ) / ((r + 1) log: 2). 
    ].
    idealDcg = 0  
        ifTrue: [ ^ 0 ]  
        ifFalse: [ ^ (actualDcg / idealDcg) ].
]

{ #category : 'inspector' }
CoStaticBenchmarks >> ndcgInspectionResults [ 

    <inspectorPresentationOrder: 5 title: 'NDCG Results'>
    | table |
    table := SpTablePresenter new
        items: self prefixSizes; 
        addColumn: (SpStringTableColumn
            title: 'Prefix'
            evaluated: [ :prefixSize | prefixSize asString ]);
        addColumn: (SpStringTableColumn
            title: 'NDCG'
            evaluated: [ :prefixSize |
                (self ndcgForPrefixSize: prefixSize) printShowingDecimalPlaces: 2
            ]);
        yourself.
    ^ table
]

{ #category : 'benchmarks' }
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

{ #category : 'metrics' }
CoStaticBenchmarks >> rankDistributionForPrefixSize: prefixSize [ 

    "Returns an Array of length 10, where each element is  how many times we found the correct item at rank i for this prefix size."
    | distribution |
    distribution := (1 to: 10) collect: [ :rank |
        ( (completionBenchs at: rank ifAbsent: [ Dictionary new ])
            at: prefixSize ifAbsent: [ #(0 #()) ]) first
    ].
    ^ distribution

]

{ #category : 'inspector' }
CoStaticBenchmarks >> rankDistributionInspectionResults [

    <inspectorPresentationOrder: 6 title: 'Rank Distribution'>
    | table |
    table := SpTablePresenter new
        items: self prefixSizes;  "2..8"
        addColumn: (SpStringTableColumn
            title: 'Prefix'
            evaluated: [ :prefixSize | prefixSize asString ]
        ).
        1 to: 10 do: [ :rank |
            table addColumn: (SpStringTableColumn
                title: 'Rank ', rank asString
                evaluated: [ :prefixSize |
                    (self rankDistributionForPrefixSize: prefixSize) at: rank
                ]
            )
        ].
    ^ table

]

{ #category : 'metrics' }
CoStaticBenchmarks >> recallAtK: k withPrefixSize: prefixSize [

    "Return the fraction (0..1) of callsites whose correct selector appears in the top k for the given prefix size."
    "If k > 10, we'll just take the top-10 maximum, since we only store up to 10 anyway."
    | effectiveK |
    effectiveK := k min: 10.

    ^ self
        accuracyForCompletionIndex: (1 to: effectiveK)
        withPrefixSize: prefixSize
]

{ #category : 'inspector' }
CoStaticBenchmarks >> recallInspectionResults [

    <inspectorPresentationOrder: 7 title: 'Recall@K Results'>
    | table kValues |
    kValues := #(1 3 5 10).
    table := SpTablePresenter new
        addColumn: (
            SpStringTableColumn
                title: 'K'
                evaluated: [ :k | k asString ]
        );
        yourself.
    self prefixSizes do: [ :prefixSize |
        table addColumn: (
            SpStringTableColumn
                title: 'Prefix ', prefixSize asString
                evaluated: [ :k |
                    ((self recallAtK: k withPrefixSize: prefixSize)
                        * 100
                        roundTo: 0.01) asString, '%' ]
        )
    ].
    table items: kValues.
    ^ table

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
CoStaticBenchmarks >> scope [

	^ scope
]

{ #category : 'accessing' }
CoStaticBenchmarks >> scope: aClass [

	scope := aClass
]

{ #category : 'benchmarks' }
CoStaticBenchmarks >> score [

	^ ((1 to: 7) sum: [ :i | (self gradeForPrefixSize: i + 1) / i ]) * 100 / ((1 to: 7) sum: [ :index | 1/index ])
]

{ #category : 'inspector' }
CoStaticBenchmarks >> timeInspectionResults [

    <inspectorPresentationOrder: 1 title: 'Time Results'>
    | table |
    table := SpTablePresenter new
        items: self prefixSizes;
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
                title: 'Count'
                evaluated: [ :prefixSize |
                    (completionTimes at: prefixSize ifAbsent: [ #( 0 0 ) ]) second asString ]
        );
        addColumn: (
            SpStringTableColumn
                title: 'Average (ms)'
                evaluated: [ :prefixSize | 
                    (self averageTimeForPrefix: prefixSize) 
                       asFloat round: 1;
                       printShowingDecimalPlaces: 2.
                ]
        );
        yourself.

    ^ table
]

{ #category : 'benchmarks' }
CoStaticBenchmarks >> totalEntriesPerPrefixSize: aPrefixSize [

	^ completionBenchs sum: [ :benchsPerPrefix | (benchsPerPrefix at: aPrefixSize ifAbsent: [ {0} ]) first ]
]

{ #category : 'metrics' }
CoStaticBenchmarks >> totalMemoryForPrefix: prefixSize [ 
	
	"the accumulated total memory usage in bytes"
   | stats |
   stats := memoryUsages at: prefixSize ifAbsent: [ #( 0 0 ) ].
   ^ stats first  
]

{ #category : 'metrics' }
CoStaticBenchmarks >> totalTime [

    "Sum over all prefix sizes"
    ^ completionTimes values
        inject: 0
        into: [ :sum :timeArray | sum + timeArray first ]
]

{ #category : 'metrics' }
CoStaticBenchmarks >> totalTimeForPrefix: prefixSize [

    | times |
    times := completionTimes at: prefixSize ifAbsent: [ #( 0 0 ) ].
    ^ times first
]

{ #category : 'inspector' }
CoStaticBenchmarks >> totalTimeInspectionResults [

	<inspectorPresentationOrder: 2 title: 'Total Time'>
	^ self totalTime asPresenter
]
