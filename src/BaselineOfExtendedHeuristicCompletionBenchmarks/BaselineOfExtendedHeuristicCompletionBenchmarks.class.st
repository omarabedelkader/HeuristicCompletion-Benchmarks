Class {
	#name : 'BaselineOfExtendedHeuristicCompletionBenchmarks',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfExtendedHeuristicCompletionBenchmarks',
	#package : 'BaselineOfExtendedHeuristicCompletionBenchmarks'
}

{ #category : 'script' }
BaselineOfExtendedHeuristicCompletionBenchmarks >> postLoad [

	CompletionContext sorterClass: NoSorter
]

{ #category : 'baselines' }
BaselineOfExtendedHeuristicCompletionBenchmarks >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec postLoadDoIt: #postLoad.
			spec package: 'ExtendedHeuristicCompletion-Benchmarks'.

			spec
				package: 'ExtendedHeuristicCompletion-Benchmarks-Tests'
				with: [ spec requires: #( 'ExtendedHeuristicCompletion-Benchmarks' ) ]]
]
