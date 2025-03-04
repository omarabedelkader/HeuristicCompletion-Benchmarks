"
```

| benchA benchB difference |
benchA := MyCoStaticBenchmarks benchNeCompletion.
benchB := MyCoStaticBenchmarks benchNeCompletionWithPackageScope.

comparison := benchA diff: benchB.


```
"
Class {
	#name : 'MyCoStaticBenchmarks',
	#superclass : 'CoStaticBenchmarks',
	#category : 'HeuristicCompletion-Cocot-Benchmark',
	#package : 'HeuristicCompletion-Cocot',
	#tag : 'Benchmark'
}

{ #category : 'benchmarking' }
MyCoStaticBenchmarks class >> NeCompletion [
	"self benchNeCompletion"

	<script>
	(self runForPackage:
		  (PackageOrganizer default packageNamed: 'NECompletion')) inspect. 
	(self runCustomForPackage:
		  (PackageOrganizer default packageNamed: 'NECompletion')) inspect. 
		
]

{ #category : 'benchmarking' }
MyCoStaticBenchmarks class >> benchNeCompletion [
	"self benchNeCompletion"

	<script>
	^ (self
		  runForPackage:
			  (PackageOrganizer default packageNamed: 'NECompletion'))
		  inspect
]

{ #category : 'benchmarking' }
MyCoStaticBenchmarks class >> benchNeCompletionWithPackageScope [
	"self benchNeCompletionWithPackageScope"

	<script>
	^ (self runCustomForPackage:
		  (PackageOrganizer default packageNamed: 'NECompletion')) inspect
]

{ #category : 'benchmarking' }
MyCoStaticBenchmarks class >> runCustomForPackage: aPackage [

	| benchmark builder |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic:
						(builder newHeuristicBuilder
			                        add: CoLocalScopeVariablesHeuristic new;
			                        add: CoWorkspaceVariablesHeuristic new;
			                        add:
				                        CoInstanceAccessibleVariablesHeuristic new;
			                        add:
				                        (CoGlobalVariablesHeuristic new
					                         globalVariableFetcherClass:
						                         CoPackageScopedGlobalVariableFetcher);
			                        build).
	
	benchmark := self new
		             scope: (CoBenchmarkPackage on: aPackage);
		             builder: builder;
		             yourself.
	benchmark run.
	^ benchmark
]

{ #category : 'benchmarking' }
MyCoStaticBenchmarks class >> runForPackage: aPackage [

	| benchmark builder |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: CoGlobalVariablesHeuristic new;
			 build).

	benchmark := self new
		             scope: (CoBenchmarkPackage on: aPackage);
		             builder: builder;
		             yourself.
	benchmark run.
	^ benchmark
]

{ #category : 'benchmarks' }
MyCoStaticBenchmarks >> benchCallsite: aMessageNode atPosition: aPosition [

	| receiver |
	receiver := aMessageNode receiver.

	2 to: (aMessageNode receiver name size min: 8) do: [ :index |
		| prefix startTime endTime executionTime completion candidates completionIndex previousResultsPerIndexPerPrefixSize |
		"Start timing"
		startTime := Time millisecondClockValue.

		prefix := receiver name copyFrom: 1 to: index.
		aMessageNode receiver: (OCVariableNode named: prefix).

	
		completion := builder
			              node: aMessageNode receiver;
			              completionContext: (CoBenchmarkContext new
					               callsite: aMessageNode;
					               position: aPosition;
					               yourself);
			              buildCompletion.

		completion replaceFilterWith:
			(CoCaseSensitiveBeginsWithFilter filterString: prefix).
		candidates := completion first: 10.

		completionIndex := (candidates collect: [ :each | each contents ])
			                   indexOf: receiver name.

		"Existing logic: update completionBenchs dictionary"
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
				previousResultsPerIndexPerPrefixSize second }.

		"Stop timing and record it"
		endTime := Time millisecondClockValue.
		executionTime := endTime - startTime.
		self logTime: executionTime forPrefix: prefix size ].

	"Restore the original selector"
	aMessageNode receiver: receiver
]

{ #category : 'benchmarking' }
MyCoStaticBenchmarks >> diff: anotherBenchmark [

    | tableDataSelf tableDataOther tableDataDifference |
    "Generate accuracy tables for self"
    tableDataSelf := self completionIndexes collect: [ :completionIndexRange |
        | label rowData |
        
        "Compute the Prefix column value"
        label := '% '.
        label := label , (completionIndexRange size = 1
            ifTrue: [ { 'fail'. '1st'. '2nd'. '3rd' } at: (completionIndexRange first + 1) ]
            ifFalse: [ completionIndexRange first asString , '-' , completionIndexRange last asString ]).
    
        "Compute the accuracy values for each prefix size"
        rowData := self prefixSizes collect: [ :prefixSize |
            (self accuracyForCompletionIndex: completionIndexRange withPrefixSize: prefixSize) * 100
                printShowingDecimalPlaces: 2
        ].
    
        "Combine Prefix column and computed values"
        { label } , rowData.
    ].
    
    "Generate accuracy tables for anotherBenchmark"
    tableDataOther := anotherBenchmark completionIndexes collect: [ :completionIndexRange |
        | label rowData |
        
        "Compute the Prefix column value"
        label := '% '.
        label := label , (completionIndexRange size = 1
            ifTrue: [ { 'fail'. '1st'. '2nd'. '3rd' } at: (completionIndexRange first + 1) ]
            ifFalse: [ completionIndexRange first asString , '-' , completionIndexRange last asString ]).
    
        "Compute the accuracy values for each prefix size"
        rowData := anotherBenchmark prefixSizes collect: [ :prefixSize |
            (anotherBenchmark accuracyForCompletionIndex: completionIndexRange withPrefixSize: prefixSize) * 100
                printShowingDecimalPlaces: 2
        ].
    
        "Combine Prefix column and computed values"
        { label } , rowData.
    ].
    
    "Calculate the difference between the two tables"
    tableDataDifference := (1 to: tableDataSelf size) collect: [ :index |
        | label diffRowData |
    
        label := (tableDataSelf at: index) first. "Keep the prefix label"
        diffRowData := ((tableDataSelf at: index) allButFirst) withIndexCollect: [ :value :i |
            | valueA valueB difference |
    
            valueA := value asNumber ifNil: [ 0 ].
            valueB := ((tableDataOther at: index) at: (i + 1)) asNumber ifNil: [ 0 ].
            difference := valueA - valueB.
            
            difference printShowingDecimalPlaces: 2
        ].
    
        { label } , diffRowData.
    ].
    
    "Return a dictionary with both tables and the computed difference"
    ^ { 'BenchmarkA' -> tableDataSelf. 'BenchmarkB' -> tableDataOther. 'Difference' -> tableDataDifference }.


]

{ #category : 'benchmarking' }
MyCoStaticBenchmarks >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			(node isMessage and: [ node receiver isVariable and: [ node receiver name first isUppercase ]])
				ifTrue: [ self benchCallsite: node atPosition: node keywordsIntervals first ] ] ]
]
