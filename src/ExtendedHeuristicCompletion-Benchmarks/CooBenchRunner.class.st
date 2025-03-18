Class {
	#name : 'CooBenchRunner',
	#superclass : 'Object',
	#category : 'ExtendedHeuristicCompletion-Benchmarks',
	#package : 'ExtendedHeuristicCompletion-Benchmarks'
}

{ #category : 'examples' }
CooBenchRunner class >> runMessageOnNeCompletionPackage [
	<script>
	
	^ (CooStaticBenchmarksMessage 
			runOnPackage: (PackageOrganizer default packageNamed: 'NECompletion')
			heuristics: [:b | b]) inspect. 
]

{ #category : 'examples' }
CooBenchRunner class >> runVariableOnNeCompletionPackage [
	<script>
	
	^ (CooStaticBenchmarksVariables 
			runOnPackage: (PackageOrganizer default packageNamed: 'NECompletion')
			heuristics: [:b | b]) inspect. 
]

{ #category : 'accessing' }
CooBenchRunner >> classNamesWithPackageScope [
	"self new classNamesWithPackageScope"

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
		scope: (CoBenchmarkPackage on: CompletionSorter package);
		builder: builder;
		run).
	benchmark inspect.
	^ benchmark

]

{ #category : 'accessing' }
CooBenchRunner >> classNamesWithoutPackageScope [
	"self new classNamesWithoutPackageScope"

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
		scope: (CoBenchmarkPackage on: CompletionSorter package);
		builder: builder;
		run).
	benchmark inspect.
	^ benchmark

]
