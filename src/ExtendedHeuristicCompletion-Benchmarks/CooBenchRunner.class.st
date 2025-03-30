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
		others: { #classNamesWithPackageScope };
		inspect; 
		run.
]

{ #category : 'examples ' }
CooBenchRunner class >> comparingRBTests [

	<script> 

	CooBenchRunner new
		package: (PackageOrganizer default packageNamed: 'Refactoring-Transformations-Tests');
		baseline: #classNamesWithoutPackageScope;
		others: { #classNamesWithPackageScope };
		inspect; 
		run.
]

{ #category : 'examples ' }
CooBenchRunner class >> comparingRBTrans [

	<script> 

	CooBenchRunner new
		package: (PackageOrganizer default packageNamed: 'Refactoring-Transformations');
		baseline: #classNamesWithoutPackageScope;
		others: { #classNamesWithPackageScope };
		inspect; 
		run.
]

{ #category : 'examples ' }
CooBenchRunner class >> comparingSpecTest [

	<script> 

	CooBenchRunner new
		package: (PackageOrganizer default packageNamed: 'Spec2-Tests');
		baseline: #classNamesWithoutPackageScope;
		others: { #classNamesWithPackageScope };
		inspect; 
		run.
]

{ #category : 'iwst' }
CooBenchRunner class >> iwst1 [
	<script>
	^ (self allResultsFor: { 'Refactoring-Transformations-Tests'.
		  'Refactoring-Transformations'. 'NECompletion'. 'NECompletion-Tests' }) inspect
]

{ #category : 'utils' }
CooBenchRunner class >> runComparisonForPackages: aCol [ 

	^ aCol collect: [ :pack |
			self  new
				package: pack;
				baseline: #classNamesWithoutPackageScope;
				others: { #classNamesWithPackageScope };
		 		run.
				]
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
CooBenchRunner >> classNamesWithPackageScope [
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
						                         CoPackageScopedGlobalVariableFetcher);
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
