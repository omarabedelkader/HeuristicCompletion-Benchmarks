"
```

CooBenchRunner new
	package: SpPresenter package;
	baseline: #classNamesWithoutPackageScope;
	others: { #classNamesWithPackageScope };
	run.
	
```
"
Class {
	#name : 'CooBenchRunner',
	#superclass : 'Object',
	#instVars : [
		'package',
		'baseline',
		'others',
		'results'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks',
	#package : 'ExtendedHeuristicCompletion-Benchmarks'
}

{ #category : 'api' }
CooBenchRunner class >> allLatexResultsFor: aColOfPackageNames [
    "Run the comparison for each package named in aColOfPackageNames
    and return a LaTeX table with the results."

    | packages runs latex |
    packages := aColOfPackageNames collect: [ :p | PackageOrganizer default packageNamed: p ].
    runs := self runComparisonForPackages: packages.
    latex := self latexTableResultForABenchCollection: runs.
    ^ latex
]

{ #category : 'api' }
CooBenchRunner class >> allResultsFor: aColOfPackageNames [
	
	| packages runs string |
	packages := aColOfPackageNames collect: [ :p |  PackageOrganizer default packageNamed: p ].
	runs := self runComparisonForPackages: packages. 
	string := self stringResultForABenchCollection: runs. 
	^ {  runs . string }
]

{ #category : 'examples ' }
CooBenchRunner class >> comparing [

	<script> 

	CooBenchRunner new
		package: SpPresenter package;
		baseline: #classNamesWithoutPackageScope;
		others: { #classNamesWithRepositoryPackageScope };
		inspect; 
		run.
]

{ #category : 'examples ' }
CooBenchRunner class >> comparingRBTests [

	<script> 

	CooBenchRunner new
		package: (PackageOrganizer default packageNamed: 'Refactoring-Transformations-Tests');
		baseline: #classNamesWithoutPackageScope;
		others: { #classNamesWithRepositoryPackageScope };
		inspect; 
		run.
]

{ #category : 'examples ' }
CooBenchRunner class >> comparingRBTrans [

	<script> 

	CooBenchRunner new
		package: (PackageOrganizer default packageNamed: 'Refactoring-Transformations');
		baseline: #classNamesWithoutPackageScope;
		others: { #classNamesWithRepositoryPackageScope };
		inspect; 
		run.
]

{ #category : 'examples ' }
CooBenchRunner class >> comparingSpecTest [

	<script> 

	CooBenchRunner new
		package: (PackageOrganizer default packageNamed: 'Spec2-Tests');
		baseline: #classNamesWithoutPackageScope;
		others: { #classNamesWithRepositoryPackageScope };
		inspect; 
		run.
]

{ #category : 'iwst' }
CooBenchRunner class >> iwst1 [
	<script>
	^ (self allResultsFor: { 'NECompletion-Tests' }) inspect
]

{ #category : 'iwst' }
CooBenchRunner class >> iwst1test [

	<script>
	^ (self allResultsFor: { 'Refactoring-Transformations-Tests' })
		  inspect
]

{ #category : 'iwst' }
CooBenchRunner class >> iwst1test2 [

	<script>
	^ (self allResultsFor: { 'ExtendedHeuristicCompletion-Analyser' })
		  inspect 
]

{ #category : 'api' }
CooBenchRunner class >> latexTableResultForABenchCollection1: aCol [
    "Produce a LaTeX table showing the results from each benchmark in aCol."

    ^ String streamContents: [ :s |
        s nextPutAll: '\begin{tabular}{lll}'; cr.
        s nextPutAll: '\hline'; cr.
        s nextPutAll: 'Package & Metric & MMR \\'; cr.
        s nextPutAll: '\hline'; cr.

        aCol do: [ :bench |
            | packageName |
            packageName := bench package name.
            bench results keysAndValuesDo: [ :metric :result |
                s
                    nextPutAll: packageName; nextPutAll: ' & ';
                    nextPutAll: metric asString; nextPutAll: ' & ';
                    nextPutAll: result mmrString; nextPutAll: ' \\'; cr
            ].
        ].

        s nextPutAll: '\hline'; cr.
        s nextPutAll: '\end{tabular}'; cr.
    ]


]

{ #category : 'api' }
CooBenchRunner class >> latexTableResultForABenchCollection22: aCol [
    "Produce a LaTeX table showing the results from each benchmark in aCol."
    | header body mmrColumns |
    
    mmrColumns := { }.
    
    body := String streamContents: [ :s |
        aCol do: [ :bench |
            | packageName mmrStr mmrLines overallMMR details temp finalMMR |
            packageName := bench package name.
            bench results keysAndValuesDo: [ :metric :result |
                    mmrStr := result mmrString.
                    "Split the mmr string on newlines."
                    mmrLines := mmrStr splitOn: Character cr.
                    "Assume the first line is the overall MMR value"
                    overallMMR := mmrLines first.
                    "The rest of the lines (if any) are detailed key/value pairs"
                    details := mmrLines allButFirst.
                    
                    details isEmpty
                        ifTrue: [ finalMMR := overallMMR ]
                        ifFalse: [
                            "If we have details, update mmrColumns when needed"
                            ( details size > mmrColumns size ) ifTrue: [
                                temp := details collect: [ :c | 
                                    | parts |
                                    parts := c findTokens: ' '.
                                    Association key: parts first value: parts second.
                                ] as: Dictionary.
                                mmrColumns := temp keys.
                                details := temp values.
                            ].
                            "Join overall and detailed values with & separators"
                            finalMMR := overallMMR , ' & ' , (details joinUsing: ' & ').
                        ].
                    
                    s
                        nextPutAll: packageName; nextPutAll: ' & ';
                        nextPutAll: metric asString; nextPutAll: ' & ';
                        nextPutAll: finalMMR; nextPutAll: ' \\'; cr.
            ].
        ].
    ].
    
    header := String streamContents: [ :s |
        s nextPutAll: '\begin{tabular}{lll'.
        1 to: mmrColumns size do: [ :i |
            s nextPutAll: 'l'.
        ].
        s nextPutAll: '}'; cr.
        s nextPutAll: '\hline'; cr.
        "The header now shows 'MMR' for the overall value plus extra columns if available"
        s nextPutAll: 'Package & Metric & MMR'.
        mmrColumns ifNotEmpty: [ :columns |
            s nextPutAll: ' & '.
            s nextPutAll: (columns joinUsing: ' & ').
        ].
        s nextPutAll: '\\'; cr.
        s nextPutAll: '\hline'; cr.
    ].
    
    ^ header, body, String streamContents: [ :s |
        s nextPutAll: '\hline'; cr.
        s nextPutAll: '\end{tabular}'; cr.
    ].

]

{ #category : 'api' }
CooBenchRunner class >> latexTableResultForABenchCollection2: aCol [
    "Produce a LaTeX table showing the results from each benchmark in aCol."
	| header body mmrColumns footer |
	
	mmrColumns := { }.
	
	body := String streamContents: [ :s |
        aCol do: [ :bench |
            | packageName |
            packageName := bench package name.
            bench results keysAndValuesDo: [ :metric :result |
					| mmr |
					mmr := result mmrString.
					mmr := mmr splitOn: Character cr.
					
					( mmr size > mmrColumns size) ifTrue: [
					
						| temp |
						temp := mmr collect: [ :c | 
							| assoc  mmrAssoc|							
							mmrAssoc := c splitOn: Character space.
							Association key: mmrAssoc first value: mmrAssoc second.
						] as: Dictionary .
						mmr := temp values.
						mmrColumns := temp keys.
					].
					mmr := mmr joinUsing: ' & '.	
                s
                    nextPutAll: packageName; nextPutAll: ' & ';
                    nextPutAll: metric asString; nextPutAll: ' & ';
                    nextPutAll: mmr; nextPutAll: ' \\'; cr
            ].
        ].
	].

	header := String streamContents: [ :s |
        s nextPutAll: '\begin{tabular}{lll'.
		  1 to: mmrColumns size do: [ :i |
				s nextPutAll: 'l'.
		  ].
		  s nextPutAll: '}'; cr.
        s nextPutAll: '\hline'; cr.
        s nextPutAll: 'Package & Metric & MMR '.
		
		  mmrColumns ifNotEmpty: [ :columns | 
				s nextPutAll: ' & '.
				s nextPutAll: (columns joinUsing: ' & ').
		  ].
		  s nextPutAll: '\\'; cr.
        s nextPutAll: '\hline'; cr.
	].

	footer := String streamContents: [ :s |
        s nextPutAll: '\hline'; cr.
        s nextPutAll: '\end{tabular}'; cr.
   ].

	^ header, body, footer
]

{ #category : 'api' }
CooBenchRunner class >> latexTableResultForABenchCollection3: aCol [
    "Produce a LaTeX table showing the results from each benchmark in aCol."
    | header body mmrColumns footer |

    mmrColumns := #().

    body := String streamContents: [:s |
        aCol do: [:bench |
            | packageName |
            packageName := bench package name.
            bench results keysAndValuesDo: [:metric :result |
                | mmrList mmrDict row |
                mmrList := result lines.

                mmrDict := Dictionary new.
                mmrList do: [:line |
                    | parts |
                    parts := line substrings: { ' ' }.
                    (parts size >= 2) ifTrue: [
                        mmrDict at: parts first put: parts second.
                    ].
                ].

                (mmrDict keys size > mmrColumns size) ifTrue: [
                    mmrColumns := mmrDict keys.
                ].

                row := mmrColumns collect: [:key |
                    (mmrDict at: key ifAbsent: ['-'])
                ].

                s
                    nextPutAll: packageName; nextPutAll: ' & ';
                    nextPutAll: metric asString; nextPutAll: ' & ';
                    nextPutAll: (row joinUsing: ' & ');
                    nextPutAll: ' \\'; cr
            ].
        ].
    ].

    header := String streamContents: [:s |
        s nextPutAll: '\begin{tabular}{lll'.
        mmrColumns do: [:each | s nextPutAll: 'l'].
        s nextPutAll: '}'; cr.
        s nextPutAll: '\hline'; cr.
        s nextPutAll: 'Package & Metric'.
        mmrColumns ifNotEmpty: [
            s nextPutAll: ' & '; nextPutAll: (mmrColumns joinUsing: ' & ').
        ].
        s nextPutAll: ' \\'; cr.
        s nextPutAll: '\hline'; cr.
    ].

    footer := String streamContents: [:s |
        s nextPutAll: '\hline'; cr.
        s nextPutAll: '\end{tabular}'; cr.
    ].

    ^ header, body, footer

]

{ #category : 'api' }
CooBenchRunner class >> latexTableResultForABenchCollection: aCol [
    "Produce a LaTeX table showing the results from each benchmark in aCol."
    | header body mmrKeys footer rows |

    mmrKeys := OrderedCollection new.
    rows := OrderedCollection new.

    "First pass: collect all keys for MMR columns"
    aCol do: [ :bench |
        bench results do: [ :result |
            | mmrLines mmrDict |
            mmrLines := result mmrString splitOn: Character cr.
            mmrDict := Dictionary new.

            mmrLines do: [ :line |
                | parts |
                parts := line splitOn: Character space.
                (parts size = 2 and: [ parts first isAllDigits ]) ifTrue: [
                    mmrDict at: parts first put: parts second.
                    (mmrKeys includes: parts first) ifFalse: [ mmrKeys add: parts first ].
                ].
            ].
        ].
    ].

    "Second pass: build rows"
    aCol do: [ :bench |
        | packageName |
        packageName := bench package name.

        bench results keysAndValuesDo: [ :metric :result |
            | mmrLines mmrValue mmrDict row |
            mmrLines := result mmrString splitOn: Character cr.
            mmrValue := 'N/A'.
            mmrDict := Dictionary new.

            mmrLines do: [ :line |
                | parts |
                parts := line splitOn: Character space.
                (parts size = 2 and: [ parts first isAllDigits ]) ifTrue: [
                    mmrDict at: parts first put: parts second.
                ] ifFalse: [
                    (line beginsWith: 'mmr:') ifTrue: [
                        mmrValue := (line copyAfter: ':') trimmed.
                    ].
                ].
            ].

            row := OrderedCollection with: packageName with: metric asString with: mmrValue.
            mmrKeys do: [ :key |
                row add: (mmrDict at: key ifAbsent: ['']).
            ].
            rows add: row.
        ].
    ].

    "Build header"
    header := String streamContents: [ :s |
        s nextPutAll: '\begin{tabular}{lll'.
        mmrKeys do: [ :k | s nextPutAll: 'l' ].
        s nextPutAll: '}'; cr.
        s nextPutAll: '\hline'; cr.
        s nextPutAll: 'Package & Metric & MMR'.
        mmrKeys do: [ :k | s nextPutAll: ' & ', k ].
        s nextPutAll: ' \\'; cr.
        s nextPutAll: '\hline'; cr.
    ].

    "Build body"
    body := String streamContents: [ :s |
        rows do: [ :row |
            s nextPutAll: (row joinUsing: ' & '); nextPutAll: ' \\'; cr.
        ].
    ].

    "Footer"
    footer := String streamContents: [ :s |
        s nextPutAll: '\hline'; cr.
        s nextPutAll: '\end{tabular}'; cr.
    ].

    ^ header, body, footer

]

{ #category : 'utils' }
CooBenchRunner class >> runComparisonForPackages: aCol [

	^ aCol collect: [ :pack |
		  self new
			  package: pack;
			  baseline: #classNamesWithoutPackageScope;
			  others: { #classNamesWithRepositoryPackageScope . #classNamesWithDependencyPackageScope };
			  run ]
]

{ #category : 'examples to debug single run' }
CooBenchRunner class >> runMessageOnNeCompletionPackage [
	<script>
	
	^ (CooStaticBenchmarksMessage 
			runOnPackage: (PackageOrganizer default packageNamed: 'NECompletion')
			heuristics: [:b | b]) inspect. 
]

{ #category : 'examples to debug single run' }
CooBenchRunner class >> runVariableOnNeCompletionPackage [
	<script>
	
	^ (CooStaticBenchmarksVariables 
			runOnPackage: (PackageOrganizer default packageNamed: 'NECompletion')
			heuristics: [:b | b]) inspect. 
]

{ #category : 'utils' }
CooBenchRunner class >> stringResultForABenchCollection: aCol [

	^ String streamContents: [ :s |
		  aCol do: [ :p |
			  s << p package name.
			  s cr.
			  p results keysAndValuesDo: [ :k :v |
				 	s << k asString. 
					s cr.  
					s << v mmrString.
				  s cr ].
			  s cr ] ]
]

{ #category : 'accessing' }
CooBenchRunner >> baseline: aSymbol [

	baseline := aSymbol 
]

{ #category : 'experience' }
CooBenchRunner >> classNamesGlobalSorterScope [
	"self new 
		package: AnalyserData1 package;
		classNamesWithoutPackageScope"

	| builder benchmark |
	builder := CoGlobalSorterResultSetBuilder new.
	benchmark := (CooStaticBenchmarksVariables new
		name: 'Flat global sorter variable';
		scope: (CoBenchmarkPackage on: package);
		builder: builder;
		run).
	benchmark inspect.
	^ benchmark

]

{ #category : 'experience' }
CooBenchRunner >> classNamesWithDependencyPackageScope [
	"self new 
		package: AnalyserData1 package;
		classNamesWithDependencyPackageScope"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: (CoGlobalVariablesHeuristic new globalVariableFetcherClass:
						  CoDependencyPackageScopedGlobalVariableFetcher);
			 build).
	benchmark := CooStaticBenchmarksVariables new
		             name: 'Scoped Global';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunner >> classNamesWithRepositoryPackageScope [
	"self new 
		package: AnalyserData1 package;
		classNamesWithPackageScope"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic:
						(builder newHeuristicBuilder
			      				add: CoLocalScopeVariablesHeuristic new;
			                add: CoWorkspaceVariablesHeuristic new;
			                add: CoInstanceAccessibleVariablesHeuristic new;
			                add: (CoGlobalVariablesHeuristic new
					                         globalVariableFetcherClass:
						                         CoRepositoryPackageScopedGlobalVariableFetcher);
			                build).
	benchmark := (CooStaticBenchmarksVariables new
		name: 'Scoped Global';
		scope: (CoBenchmarkPackage on: package);
		builder: builder;
		run).
	^ benchmark

]

{ #category : 'accessing' }
CooBenchRunner >> classNamesWithoutPackageScope [
	"self new 
		package: AnalyserData1 package;
		classNamesWithoutPackageScope"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic:
						(builder newHeuristicBuilder
			      				add: CoLocalScopeVariablesHeuristic new;
			                add: CoWorkspaceVariablesHeuristic new;
			                add: CoInstanceAccessibleVariablesHeuristic new;
			                add: CoGlobalVariablesHeuristic new;
			                build).
	benchmark := (CooStaticBenchmarksVariables new
		name: 'Flat semantic global variable';
		scope: (CoBenchmarkPackage on: package);
		builder: builder;
		run).
	benchmark inspect.
	^ benchmark

]

{ #category : 'accessing' }
CooBenchRunner >> computeRatio [

	^ (results at: baseline) accuracyResults
		computeRatioWithReceiverAsBaselineComparedTo: (results at: others first) accuracyResults
]

{ #category : 'accessing' }
CooBenchRunner >> others: aSymbolCollect [

	others := aSymbolCollect 
]

{ #category : 'accessing' }
CooBenchRunner >> package [
	^ package
]

{ #category : 'accessing' }
CooBenchRunner >> package: aPackage [

	package := aPackage
]

{ #category : 'accessing' }
CooBenchRunner >> results [
	^ results
]

{ #category : 'accessing' }
CooBenchRunner >> run [ 

	results := Dictionary new.
	{baseline} , others
		do: [ :s | results at: s  put: (self perform: s)]

]
