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
	#name : 'CooBenchRunnerMessage',
	#superclass : 'CoBenchRunner',
	#category : 'ExtendedHeuristicCompletion-Benchmarks',
	#package : 'ExtendedHeuristicCompletion-Benchmarks'
}

{ #category : 'api' }
CooBenchRunnerMessage class >> allLatexResultsFor: aColOfPackageNames [

    | packages runs latex |
    packages := aColOfPackageNames collect: [ :p | PackageOrganizer default packageNamed: p ].
    runs := self runComparisonForPackages: packages.
    latex := self latexTableResultForABenchCollection: runs.
    ^ latex
]

{ #category : 'api' }
CooBenchRunnerMessage class >> allResultsFor: aColOfPackageNames [
	
	| packages runs string |
	packages := aColOfPackageNames collect: [ :p |  PackageOrganizer default packageNamed: p ].
	runs := self runComparisonForPackages: packages. 
	string := self stringResultForABenchCollection: runs. 
	^ {  runs . string }
]

{ #category : 'examples ' }
CooBenchRunnerMessage class >> comparing [

	<script>
	CooBenchRunnerVariables new
		package: CompletionSorter package;
		baseline: #withoutPackageScope;
		others: { #withPackageScope };
		run
]

{ #category : 'examples ' }
CooBenchRunnerMessage class >> comparingRBTests [

	<script> 

	CooBenchRunnerVariables new
		package: (PackageOrganizer default packageNamed: 'Refactoring-Transformations-Tests');
		baseline: #withoutPackageScope;
		others: { #withPackageScope };
		run.
]

{ #category : 'examples ' }
CooBenchRunnerMessage class >> comparingRBTrans [

	<script> 

	CooBenchRunnerVariables new
		package: (PackageOrganizer default packageNamed: 'Refactoring-Transformations');
		baseline: #withoutPackageScope;
		others: { #withPackageScope };
		run.
]

{ #category : 'examples ' }
CooBenchRunnerMessage class >> comparingSpecTest [

	<script> 

	CooBenchRunnerVariables new
		package: (PackageOrganizer default packageNamed: 'Spec2-Tests');
		baseline: #withoutPackageScope;
		others: { #withPackageScope };
		run.
]

{ #category : 'iwst' }
CooBenchRunnerMessage class >> iwst1 [
	<script>
	^ (self allResultsFor: { 'NECompletion-Tests' }) inspect
]

{ #category : 'iwst' }
CooBenchRunnerMessage class >> iwst1test [

	<script>
	^ (self allResultsFor: { 'Refactoring-Transformations-Tests' })
		  inspect
]

{ #category : 'iwst' }
CooBenchRunnerMessage class >> iwst1test2 [

	<script>
	^ (self allResultsFor: { 'ExtendedHeuristicCompletion-Analyser' })
		  inspect 
]

{ #category : 'api' }
CooBenchRunnerMessage class >> latexTableResultForABenchCollection: aCol [
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
CooBenchRunnerMessage class >> runComparisonForPackages: aCol [

	^ aCol collect: [ :pack |
			  self new
				  package: pack;
				  baseline: #withoutPackageScope;
				  others:
					  { #withPackageScope. #withReverseDependency.
					  #withDependency. #withWeightedMetaFetcher };
				  run ]
]

{ #category : 'examples to debug single run' }
CooBenchRunnerMessage class >> runMessageOnNeCompletionPackage [
	<script>
	
	^ (CooStaticBenchmarksMessage 
			runOnPackage: (PackageOrganizer default packageNamed: 'NECompletion')
			heuristics: [:b | b]) inspect. 
]

{ #category : 'examples to debug single run' }
CooBenchRunnerMessage class >> runVariableOnNeCompletionPackage [
	<script>
	
	^ (CooStaticBenchmarksVariables 
			runOnPackage: (PackageOrganizer default packageNamed: 'NECompletion')
			heuristics: [:b | b]) inspect. 
]

{ #category : 'utils' }
CooBenchRunnerMessage class >> stringResultForABenchCollection: aCol [

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
CooBenchRunnerMessage >> withDependency [
	"self new 
		package: AnalyserData1 package;
		classNamesWithDependencyPackageScope"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoSelfMessageHeuristic new;
			 add: CoSuperMessageHeuristic new;
			 add: CoTypedReceiverMessageHeuristic new;
			 add: CoInitializeInferencedMessageHeuristic new;
			 add: CoLiteralMessageHeuristic new;
			 add: CoGlobalVariableMessageHeuristic new;
			 add: CoVariableWithTypeNameMessageHeuristic new;
			 add: CoUnknownMessageHeuristic new;
			 build).
	benchmark := CooStaticBenchmarksMessage new
		             name: 'Dependency';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerMessage >> withoutPackageScope [
	"self new 
		package: AnalyserData1 package;
		classNamesWithoutPackageScope"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoSelfMessageHeuristic new;
			 add: CoSuperMessageHeuristic new;
			 add: CoTypedReceiverMessageHeuristic new;
			 add: CoInitializeInferencedMessageHeuristic new;
			 add: CoLiteralMessageHeuristic new;
			 add: CoGlobalVariableMessageHeuristic new;
			 add: CoVariableWithTypeNameMessageHeuristic new;
			 add: CoUnknownMessageHeuristic new;
			 build).
	benchmark := CooStaticBenchmarksMessage new
		             name: '';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]
