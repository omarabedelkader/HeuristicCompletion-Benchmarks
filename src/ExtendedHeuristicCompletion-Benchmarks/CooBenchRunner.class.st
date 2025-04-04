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
    latex := self latexTableResultForABenchCollection2: runs.
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
	^ (self allResultsFor: { 'Refactoring-Transformations-Tests'.
		  'Refactoring-Transformations'. 'NECompletion'. 'NECompletion-Tests' }) inspect
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
CooBenchRunner class >> latexTableResultForABenchCollection2: aCol [
    "Produce a LaTeX table, splitting each benchmark's MMR string by newline,
     so that each line becomes something you can parse into columns."

    ^ String streamContents: [ :s |

        "Adjust the tabular spec ({l l r r r ...}) depending on how many columns you have."
        s nextPutAll: '\begin{tabular}{l l r r r r r r r r}'; cr.
        s nextPutAll: '\hline'; cr.
        s nextPutAll: 'Packages & Scope & MMR & 2 & 3 & 4 & 5 & 6 & 7 & 8 \\'; cr.
        s nextPutAll: '\hline'; cr.

        aCol do: [ :bench |
            | packageName |
            packageName := bench package name.

            bench results keysAndValuesDo: [ :metric :result |
                | lines scopeLine mmrLine val2 val3 val4 val5 val6 val7 val8 |
                
                "Split the entire MMR string by newline."
                lines := result mmrString findTokens: String lf.
                
                "Assuming 'lines' now has something like:
                  #( 'without'
                     'mmr: 0.3955'
                     '2 0.08'
                     '3 0.22'
                     '4 0.39'
                     '5 0.44'
                     '6 0.49'
                     '7 0.54'
                     '8 0.66' )."

                scopeLine := lines first. "e.g. 'without' or 'with'."
                
                "Parse out the MMR from e.g. 'mmr: 0.3955'"
                mmrLine := (lines second findTokens: Character space) last. 
                
                "Then parse out each subsequent value, e.g. '2 0.08' => #('2' '0.08'), etc."
                val2 := (lines third  findTokens: Character space) last.
                val3 := (lines fourth findTokens: Character space) last.
                val4 := (lines fifth  findTokens: Character space) last.
                val5 := (lines sixth  findTokens: Character space) last.
                val6 := (lines seventh findTokens: Character space) last.
                val7 := (lines eighth  findTokens: Character space) last.
                val8 := (lines ninth   findTokens: Character space) last.

                "Now write out one row in the table."
                s
                    nextPutAll: packageName; nextPutAll: ' & ';
                    nextPutAll: scopeLine;  nextPutAll: ' & ';
                    nextPutAll: mmrLine;   nextPutAll: ' & ';
                    nextPutAll: val2;      nextPutAll: ' & ';
                    nextPutAll: val3;      nextPutAll: ' & ';
                    nextPutAll: val4;      nextPutAll: ' & ';
                    nextPutAll: val5;      nextPutAll: ' & ';
                    nextPutAll: val6;      nextPutAll: ' & ';
                    nextPutAll: val7;      nextPutAll: ' & ';
                    nextPutAll: val8;      nextPutAll: ' \\'; cr.
            ].
        ].

        s nextPutAll: '\hline'; cr.
        s nextPutAll: '\end{tabular}'; cr.
    ]
]

{ #category : 'api' }
CooBenchRunner class >> latexTableResultForABenchCollection: aCol [
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
