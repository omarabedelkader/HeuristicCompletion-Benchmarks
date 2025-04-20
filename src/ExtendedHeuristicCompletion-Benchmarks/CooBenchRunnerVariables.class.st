"
```
comparingSpecTest

	<script>
	CooBenchRunnerVariables new
		package: (PackageOrganizer default packageNamed: 'Spec2-Tests');
		baseline: #withoutPackageScope;
		others: { #withPackageScope };
		run
```



```
testcomparingdependcyandreverse

	<script>
	CooBenchRunnerVariables new
		package: CompletionContextTest package;
		baseline: #withoutPackageScope;
		others: { #withWeightedMetaFetcher };
		run
```

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
	#name : 'CooBenchRunnerVariables',
	#superclass : 'CoBenchRunner',
	#category : 'ExtendedHeuristicCompletion-Benchmarks',
	#package : 'ExtendedHeuristicCompletion-Benchmarks'
}

{ #category : 'api' }
CooBenchRunnerVariables class >> allLatexResultsFor: aColOfPackageNames [

    | packages runs latex |
    packages := aColOfPackageNames collect: [ :p | PackageOrganizer default packageNamed: p ].
    runs := self runComparisonForPackages: packages.
    latex := self latexTableResultForABenchCollection: runs.
    ^ latex
]

{ #category : 'api' }
CooBenchRunnerVariables class >> allResultsFor: aColOfPackageNames [
	
	| packages runs string |
	packages := aColOfPackageNames collect: [ :p |  PackageOrganizer default packageNamed: p ].
	runs := self runComparisonForPackages: packages. 
	string := self stringResultForABenchCollection: runs. 
	^ {  runs . string }
]

{ #category : 'api' }
CooBenchRunnerVariables class >> comparingNECompletionOllama [

	<script>
	CooBenchRunnerVariables new
		package: (PackageOrganizer default packageNamed: 'NECompletion');
		baseline: #withoutPackageScope;
		others: { #withPackageScope. #withDependency. #withLateralDependency };
		run

]

{ #category : 'api' }
CooBenchRunnerVariables class >> comparingSpecTest [

	<script>
	CooBenchRunnerVariables new
		package: (PackageOrganizer default packageNamed: 'Spec2-Tests');
		baseline: #withoutPackageScope;
		others: { #withPackageScope };
		run

]

{ #category : 'iwst' }
CooBenchRunnerVariables class >> iwst1 [

	<script>
	^ (self allLatexResultsFor: {'Spec2-Core'.'Spec2-Tests'.'Refactoring-Transformations'.'Refactoring-Transformations-Tests'.'NECompletion'. 'NECompletion-Tests' })
		  inspect
]

{ #category : 'iwst' }
CooBenchRunnerVariables class >> iwst1final [

	<script>
	^ (self allLatexResultsFor: {'Spec2-Core'.'Spec2-Tests'})
		  inspect
]

{ #category : 'iwst' }
CooBenchRunnerVariables class >> iwst1finalIceberg [

<script>
^ (self allResultsFor: {
    'Iceberg'.
    'Iceberg-Libgit'.
    'Iceberg-Libgit-Filetree'.
    'Iceberg-Libgit-Tonel'.
    'Iceberg-Metacello-Integration'.
    'Iceberg-Plugin'.
    'Iceberg-Plugin-Github'.
    'Iceberg-Plugin-Migration'.
    'Iceberg-Plugin-Pharo'.
    'Iceberg-TipUI'.
    'Iceberg-TipUI-SnapShotBrowser'
}) inspect


]

{ #category : 'iwst' }
CooBenchRunnerVariables class >> iwst1finalmoose [

<script>
^ (self allLatexResultsFor: {
    'Moose-Blueprint-Invocations-Models'.
    'Moose-Blueprint-Models'.
    'Moose-Blueprint-Models-Tests'.
    'Moose-Blueprint-Visualization-Models'.
    'Moose-Configuration'.
    'Moose-Core'.
    'Moose-Core-Generator'.
    'Moose-Core-Tests'.
    'Moose-Core-Tests-Entities'.
    'Moose-Importers'.
    'Moose-Importers-Tests'.
    'Moose-Query'.
    'Moose-Query-Extensions'.
    'Moose-Query-Test'.
    'Moose-SmalltalkImporter'.
    'Moose-SmalltalkImporter-Core-Tests'.
    'Moose-SmalltalkImporter-KGB-Tests'.
    'Moose-SmalltalkImporter-LAN-Tests'.
    'Moose-TestResources-KGB-P10InteractedReferee'.
    'Moose-TestResources-KGB-P11FullReferee'.
    'Moose-TestResources-KGB-P12FullReferencer'.
    'Moose-TestResources-KGB-P13FullReferencer'.
    'Moose-TestResources-KGB-P14FullReferee'.
    'Moose-TestResources-KGB-P1FullReferencer'.
    'Moose-TestResources-KGB-P2InteractedReferencerReferee'.
    'Moose-TestResources-KGB-P3InteractedReferencer'.
    'Moose-TestResources-KGB-P4FullInteracted'.
    'Moose-TestResources-KGB-P5FullReferee'.
    'Moose-TestResources-KGB-P6InteractedReferee'.
    'Moose-TestResources-KGB-P7ReferencerReferee'.
    'Moose-TestResources-KGB-P8FullReferencer'.
    'Moose-TestResources-KGB-P9FullReferencer'.
    'Moose-TestResources-KGB-PExtensions'.
    'Moose-TestResources-LAN'.
    'Moose-TestResources-LCOM'.
    'Moose-TestResources-PackageBlueprint-P1'.
    'Moose-TestResources-PackageBlueprint-P2'.
    'Moose-TestResources-PackageBlueprint-P3'.
    'Moose-TestResources-PackageBlueprint-P4'.
    'Moose-TestResources-Reference-Core'.
    'Moose-TestResources-Reference-External'.
    'Moose-TestResources-Reference-PackageOne'.
    'Moose-TestResources-Reference-PackageTwo'.
    'Moose-WelcomeBrowser'.
    'MooseIDE-Analysis'.
    'MooseIDE-AttributedText'.
    'MooseIDE-ButterflyMap'.
    'MooseIDE-ButterflyMap-Tests'.
    'MooseIDE-ClassBlueprint'.
    'MooseIDE-CoUsageMap'.
    'MooseIDE-CoUsageMap-Tests'.
    'MooseIDE-Core'.
    'MooseIDE-Core-Reporter'.
    'MooseIDE-CriticBrowser'.
    'MooseIDE-CriticBrowser-Tests'.
    'MooseIDE-Dependency'.
    'MooseIDE-Duplication'.
    'MooseIDE-Export'.
    'MooseIDE-Famix'.
    'MooseIDE-LayerVisualization'.
    'MooseIDE-Meta'.
    'MooseIDE-NewTools'.
    'MooseIDE-NewTools-Tests'.
    'MooseIDE-QueriesBrowser'.
    'MooseIDE-QueriesBrowser-Tests'.
    'MooseIDE-QueriesDashboard'.
    'MooseIDE-Spotter'.
    'MooseIDE-Spotter-Tests'.
    'MooseIDE-Tagging'.
    'MooseIDE-Tagging-Tests'.
    'MooseIDE-Tests'.
    'MooseIDE-Visualization'
}) inspect

]

{ #category : 'iwst' }
CooBenchRunnerVariables class >> iwst1finalseaside [

<script>
^ (self allLatexResultsFor: {
    'Seaside-Ajaxifier-Core'.
    'Seaside-Canvas'.
    'Seaside-Component'.
    'Seaside-Continuation'.
    'Seaside-Core'.
    'Seaside-Development'.
    'Seaside-Email'.
    'Seaside-Environment'.
    'Seaside-Examples'.
    'Seaside-Flow'.
    'Seaside-JSON-Core'.
    'Seaside-Pharo-Canvas'.
    'Seaside-Pharo-Continuation'.
    'Seaside-Pharo-Core'.
    'Seaside-Pharo-Development'.
    'Seaside-Pharo-Email'.
    'Seaside-Pharo-Environment'.
    'Seaside-Pharo-Flow'.
    'Seaside-Pharo-JSON-Core'.
    'Seaside-Pharo-Tools-Web'.
    'Seaside-Pharo-Welcome'.
    'Seaside-Pharo100-Tools-Spec2'.
    'Seaside-Pharo90-REST-Core'.
    'Seaside-REST-Core'.
    'Seaside-RenderLoop'.
    'Seaside-Session'.
    'Seaside-Tests-Canvas'.
    'Seaside-Tests-Component'.
    'Seaside-Tests-Core'.
    'Seaside-Tests-Environment'.
    'Seaside-Tests-Flow'.
    'Seaside-Tests-Functional'.
    'Seaside-Tests-Pharo-Canvas'.
    'Seaside-Tests-Pharo-Continuation'.
    'Seaside-Tests-Pharo-Core'.
    'Seaside-Tests-Pharo-Functional'.
    'Seaside-Tests-RenderLoop'.
    'Seaside-Tests-Session'.
    'Seaside-Tools-Core'.
    'Seaside-Tools-Web'.
    'Seaside-Welcome'.
    'Seaside-Widgets'.
    'Seaside-Zinc-Core'.
    'Seaside-Zinc-Pharo'
}) inspect

]

{ #category : 'iwst' }
CooBenchRunnerVariables class >> iwst1finalspec [

	<script>
^ (self allLatexResultsFor: {
    'Spec2-Adapters-Morphic'.
    'Spec2-Adapters-Morphic-ListView'.
    'Spec2-Adapters-Morphic-Tests'.
    'Spec2-Adapters-Stub'.
    'Spec2-Backend-Tests'.
    'Spec2-Code'.
    'Spec2-Code-Backend-Tests'.
    'Spec2-Code-Commands'.
    'Spec2-Code-Diff'.
    'Spec2-Code-Diff-Morphic'.
    'Spec2-Code-Diff-Tests'.
    'Spec2-Code-Morphic'.
    'Spec2-Code-Tests'.
    'Spec2-CommandLine'.
    'Spec2-Commander2'.
    'Spec2-Commander2-Tests'.
    'Spec2-Commands'.
    'Spec2-CommonWidgets'.
    'Spec2-Core'.
    'Spec2-Dialogs'.
    'Spec2-Dialogs-Tests'.
    'Spec2-Examples'.
    'Spec2-Interactions'.
    'Spec2-Layout'.
    'Spec2-ListView'.
    'Spec2-ListView-Tests'.
    'Spec2-Microdown'.
    'Spec2-Morphic'.
    'Spec2-Morphic-Backend-Tests'.
    'Spec2-Morphic-Examples'.
    'Spec2-Morphic-Tests'.
    'Spec2-Tests'.
    'Spec2-Transmission'
}) inspect

]

{ #category : 'api' }
CooBenchRunnerVariables class >> latexTableResultForABenchCollection: aCol [
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
CooBenchRunnerVariables class >> runComparisonForPackages1: aCol [

	^ aCol collect: [ :pack |
			  self new
				  package: pack;
				  baseline: #withoutPackageScope;
				  others:
					  { #withPackageScope. #withDependency. #withLateralDependency .#withReverseDependency.
					  #withTransitiveDependency. #withWeightedMetaFetcher. #withAdaptiveWeightedMetaFetcher };
				  run ]
]

{ #category : 'utils' }
CooBenchRunnerVariables class >> runComparisonForPackages: aCol [

	^ aCol collect: [ :pack |
			  self new
				  package: pack;
				  baseline: #withoutPackageScope;
				  others:
					  { #withPackageScope};
				  run ]
]

{ #category : 'examples to debug single run' }
CooBenchRunnerVariables class >> runMessageOnNeCompletionPackage [
	<script>
	
	^ (CooStaticBenchmarksMessage 
			runOnPackage: (PackageOrganizer default packageNamed: 'NECompletion')
			heuristics: [:b | b]) inspect. 
]

{ #category : 'examples to debug single run' }
CooBenchRunnerVariables class >> runVariableOnNeCompletionPackage [
	<script>
	
	^ (CooStaticBenchmarksVariables 
			runOnPackage: (PackageOrganizer default packageNamed: 'NECompletion')
			heuristics: [:b | b]) inspect. 
]

{ #category : 'utils' }
CooBenchRunnerVariables class >> stringResultForABenchCollection: aCol [

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
CooBenchRunnerVariables >> withAdaptiveWeightedMetaFetcher [
	"self new 
		package: AnalyserData1 package;
		withAdaptiveWeightedMetaFetcher"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: (CoGlobalVariablesHeuristic new globalVariableFetcherClass:
						  CoAdaptiveMetaGlobalVariableFetcher);
			 build).
	benchmark := CooStaticBenchmarksVariables new
		             name: 'Adaptive Weighted Dependency';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerVariables >> withDependency [
	"self new 
		package: AnalyserData1 package;
		withDependency"

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
		             name: 'Dependency';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerVariables >> withGlobalSorterScope [
	"self new 
		package: AnalyserData1 package;
		withGlobalSorterScope"

	| builder benchmark |
	builder := CoGlobalSorterResultSetBuilder new.
	benchmark := CooStaticBenchmarksVariables new
		             name: 'Flat global sorter variable';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	benchmark inspect.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerVariables >> withLateralDependency [
	"self new 
		package: AnalyserData1 package;
		withReverseDependency"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: (CoGlobalVariablesHeuristic new globalVariableFetcherClass:
						  CoLateralPackageGlobalVariableFetcher);
			 build).
	benchmark := CooStaticBenchmarksVariables new
		             name: 'Lateral Dependency';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerVariables >> withOllamaReRank [
	"self new 
		package: AnalyserData1 package;
		withOllamaReRank"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.

	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: (CoGlobalVariablesHeuristic new globalVariableFetcherClass:
						  CoOllamaReRankFetcher);
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
CooBenchRunnerVariables >> withPackageScope [
	"self new 
		package: AnalyserData1 package;
		withPackageScope"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: (CoGlobalVariablesHeuristic new globalVariableFetcherClass:
						  CoRepositoryPackageScopedGlobalVariableFetcher);
			 build).
	benchmark := CooStaticBenchmarksVariables new
		             name: 'Packages Scope';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerVariables >> withReverseDependency [
	"self new 
		package: AnalyserData1 package;
		withReverseDependency"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: (CoGlobalVariablesHeuristic new globalVariableFetcherClass:
						  CoReverseDependencyPackageScopedGlobalVariableFetcher);
			 build).
	benchmark := CooStaticBenchmarksVariables new
		             name: 'Reverse Dependency';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerVariables >> withTransitiveDependency [
	"self new 
		package: AnalyserData1 package;
		withTransitiveDependency"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: (CoGlobalVariablesHeuristic new globalVariableFetcherClass:
						  CoTransitiveDependencyPackageScopedGlobalVariableFetcher);
			 build).
	benchmark := CooStaticBenchmarksVariables new
		             name: 'Transitive Dependency';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerVariables >> withWeightedMetaFetcher [
	"self new 
		package: AnalyserData1 package;
		withWeightedMetaFetcher"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: (CoGlobalVariablesHeuristic new globalVariableFetcherClass:
						  CoWeightedMetaGlobalVariableFetcher);
			 build).
	benchmark := CooStaticBenchmarksVariables new
		             name: 'Weighted Dependency';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerVariables >> withoutPackageScope [
	"self new 
		package: AnalyserData1 package;
		withoutPackageScope"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder variablesHeuristic: (builder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: CoGlobalVariablesHeuristic new;
			 build).
	benchmark := CooStaticBenchmarksVariables new
		             name: 'Without PackageScope';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]
