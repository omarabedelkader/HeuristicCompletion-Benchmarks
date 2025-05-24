"
```smalltalk
runMessageOnNeCompletionPackage

	<script>
	^ (CooStaticBenchmarksMessage
		   runOnPackage:
		   (PackageOrganizer default packageNamed: 'NECompletion')
		   heuristics: [ :b | b ]) inspect
	
```



```smalltalk
CooBenchRunner new
   package: CompletionContextTest package;
   baseline: #WithoutPackageScope;
   others: { #WithOllamaReRank };
   run.

```
"
Class {
	#name : 'CooBenchRunnerMessage',
	#superclass : 'CooBenchRunner',
	#category : 'ExtendedHeuristicCompletion-Benchmarks',
	#package : 'ExtendedHeuristicCompletion-Benchmarks'
}

{ #category : 'iwst' }
CooBenchRunnerMessage class >> iwst1 [

	<script>
	^ (self allResultsFor: { 'NECompletion' . 'NECompletion-Tests' })
		  inspect
]

{ #category : 'experience' }
CooBenchRunnerMessage >> withBaseline [
	"self new 
		package: AnalyserData1 package;
		withBaseline"

	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder messageHeuristic: (builder newHeuristicBuilder
			 add: (CoUnknownMessageHeuristic new globalMessageFetcherClass:
				CoGlobalSelectorFetcher) ;
			 build).
	benchmark := CooStaticBenchmarksMessage new
		             name: 'Baseline';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerMessage >> withPackageScope [
	"self new 
		package: AnalyserData1 package;
		withPackageScope"
		
	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder messageHeuristic: (builder newHeuristicBuilder
			 add: CoSelfMessageHeuristic new;
			 add: CoSuperMessageHeuristic new;
			 add: CoTypedReceiverMessageHeuristic new;
			 add: CoInitializeInferencedMessageHeuristic new;
			 add: CoLiteralMessageHeuristic new;
			 add: CoGlobalVariableMessageHeuristic new;
			 add: CoVariableWithTypeNameMessageHeuristic new;
			add: (CoUnknownMessageHeuristic new globalMessageFetcherClass:
				CoRepositoryPackageScopedGlobalMessageFetcher );	
			 build).
	benchmark := CooStaticBenchmarksMessage new
		             name: '';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]

{ #category : 'experience' }
CooBenchRunnerMessage >> withSemantics [
	"self new 
		package: AnalyserData1 package;
		withSemantics"
		
	| builder benchmark |
	builder := CoASTHeuristicsResultSetBuilder new.
	builder messageHeuristic: (builder newHeuristicBuilder
			 add: CoSelfMessageHeuristic new;
			 add: CoSuperMessageHeuristic new;
			 add: CoTypedReceiverMessageHeuristic new;
			 add: CoInitializeInferencedMessageHeuristic new;
			 add: CoLiteralMessageHeuristic new;
			 add: CoGlobalVariableMessageHeuristic new;
			 add: CoVariableWithTypeNameMessageHeuristic new;
			 add: (CoUnknownMessageHeuristic new globalMessageFetcherClass:
				CooGlobalSelectorFetcher );
			 build).
	benchmark := CooStaticBenchmarksMessage new
		             name: '';
		             scope: (CoBenchmarkPackage on: package);
		             builder: builder;
		             run.
	^ benchmark
]
