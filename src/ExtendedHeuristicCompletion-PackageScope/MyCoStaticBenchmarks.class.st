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
	#superclass : 'CooStaticBenchmarks',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Benchmark',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
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
						                         CoRepositoryPackageScopedGlobalVariableFetcher);
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

	^ self new runForPackage: aPackage
]

{ #category : 'benchmarking' }
MyCoStaticBenchmarks class >> runForPackage: aPackage withBuilder: aBuilder [

	^ self new runForPackage: aPackage
]

{ #category : 'benchmarks' }
MyCoStaticBenchmarks >> benchCallsite: aVariable atPosition: aPosition [

	| oldName |
	oldName := aVariable name.
	2 to: (self maxPrefixSizeFor: aVariable) do: [ :index |
		| prefix startTime startMemory completion candidates completionIndex |
		startTime := self startTimeMeasurement.
		startMemory := self startMemoryMeasurement.

		prefix := self extractPrefixFrom: aVariable at: index.
		aVariable name: prefix.

		completion := self
			              buildCompletionFor: aVariable
			              atPosition: aPosition.

		candidates := self
			              fetchTopCandidatesFrom: completion
			              usingPrefix: prefix.
		completionIndex := self
			                   findCompletionIndexFor: aVariable
			                   inCandidates: candidates.

		self
			trackCompletionResultsFor: aVariable
			atIndex: completionIndex
			withPrefix: prefix.

		self logMemoryUsageSince: startMemory forPrefixSize: prefix size.
		self logExecutionTimeSince: startTime forPrefixSize: prefix size ].
	
		aVariable name: oldName 

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
	"self new run"
	
	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			(node isMessage and: [ node isVariable and: [ node name first isUppercase ]])
				ifTrue: [ self benchCallsite: node atPosition: node keywordsIntervals first ] ] ]
]

{ #category : 'benchmarking' }
MyCoStaticBenchmarks >> runForPackage: aPackage [

	| benchmark b |
	b := CoASTHeuristicsResultSetBuilder new.
	b variablesHeuristic: (b newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: CoGlobalVariablesHeuristic new;
			 build).

	benchmark := self
		             scope: (CoBenchmarkPackage on: aPackage);
		             builder: b;
		             yourself.
	benchmark run.
	^ benchmark
]
