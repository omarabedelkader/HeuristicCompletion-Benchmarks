"
```

CooBenchRunner new
	package: SpPresenter package;
	baseline: #classNamesWithoutPackageScope;
	others: { #classNamesWithPackageScope };
	run.
	
```



```
CooBenchRunner new
   package: CompletionContextTest package;
   baseline: #WithoutPackageScope;
   others: { #WithOllamaReRank };
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
		baseline: #WithoutPackageScope;
		others: { #WithPackageScope };
		run.
]

{ #category : 'examples ' }
CooBenchRunner class >> comparingRBTests [

	<script> 

	CooBenchRunner new
		package: (PackageOrganizer default packageNamed: 'Refactoring-Transformations-Tests');
		baseline: #WithoutPackageScope;
		others: { #WithPackageScope };
		run.
]

{ #category : 'examples ' }
CooBenchRunner class >> comparingRBTrans [

	<script> 

	CooBenchRunner new
		package: (PackageOrganizer default packageNamed: 'Refactoring-Transformations');
		baseline: #WithoutPackageScope;
		others: { #WithPackageScope };
		run.
]

{ #category : 'examples ' }
CooBenchRunner class >> comparingSpecTest [

	<script> 

	CooBenchRunner new
		package: (PackageOrganizer default packageNamed: 'Spec2-Tests');
		baseline: #WithoutPackageScope;
		others: { #WithPackageScope };
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
CooBenchRunner class >> latexTableResultForABenchCollection: aCol [
    "Produce a LaTeX table showing the results from each benchmark in aCol."
    | header body mmrKeys footer rows |

    mmrKeys := OrderedCollection new.
    rows := OrderedCollection new.

    "First pass: collect all keys for MMR columns"
    aCol do: [ :bench |
		 bench results do: [ :result |
			| mmrs |
			mmrs := result mmrString splitOn: Character cr.
			mmrs := mmrs copyFrom: 2 to: mmrs size. 
			mmrKeys := mmrs collect: [ :r | (r splitOn: Character space) first ] 
		].
    ].

    "Second pass: build rows"
   body := String streamContents: [ :s |
		 aCol do: [ :bench |
        | packageName |
        packageName := bench package name.

        bench results keysAndValuesDo: [ :metric :result |
            | mmrs mmrValues globalMmr |

				mmrs := result mmrString splitOn: Character cr.
				mmrValues := mmrs copyFrom: 2 to: mmrs size. 
				mmrValues := mmrValues collect: [ :r | (r splitOn: Character space) second ].
				globalMmr := (mmrs first splitOn: Character space) second.

				s nextPutAll: packageName; nextPutAll: ' & '.
             s nextPutAll: metric asString; nextPutAll: ' & '.
             s nextPutAll: globalMmr asString; nextPutAll: ' & '.     
				s nextPutAll: (mmrValues joinUsing: ' & ').
				s nextPutAll: ' \\'.
				s cr
			
				
      		   ].
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
			  baseline: #WithoutPackageScope;
			  others: { #WithPackageScope . #WithDependency };
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

{ #category : 'experience' }
CooBenchRunner >> WithDependency [
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
CooBenchRunner >> WithOllamaReRank [
   "Use a re-ranked global fetcher based on Ollama."

   | builder benchmark |
   builder := CoASTHeuristicsResultSetBuilder new.

   "Add local/workspace/instance fetchers as normal"
   builder variablesHeuristic: (builder newHeuristicBuilder
       add: CoLocalScopeVariablesHeuristic new;
       add: CoWorkspaceVariablesHeuristic new;
       add: CoInstanceAccessibleVariablesHeuristic new;

       "Now we add a CoGlobalVariablesHeuristic that uses CoOllamaReRankFetcher"
       add: (
          CoGlobalVariablesHeuristic new
             globalVariableFetcherClass: CoOllamaReRankFetcher
       );

       build).

   "Finally build and run the benchmark"
   benchmark := CooStaticBenchmarksVariables new
       name: 'Ollama Re-rank Global';
       scope: (CoBenchmarkPackage on: package);
       builder: builder;
       run.

   ^ benchmark
]

{ #category : 'experience' }
CooBenchRunner >> WithPackageScope [
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
CooBenchRunner >> WithoutPackageScope [
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
	^ benchmark

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
