Class {
	#name : 'BaselineOfExtendedHeuristicCompletionBenchmarks',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfExtendedHeuristicCompletionBenchmarks',
	#package : 'BaselineOfExtendedHeuristicCompletionBenchmarks'
}

{ #category : 'baselines' }
BaselineOfExtendedHeuristicCompletionBenchmarks >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec package: 'ExtendedHeuristicCompletion-Benchmarks'.

			spec
				package: 'ExtendedHeuristicCompletion-Benchmarks-Tests'
				with: [ spec requires: #( 'ExtendedHeuristicCompletion-Benchmarks' 'ExtendedHeuristicCompletion-Dependency' ) ].

			spec
				package: 'ExtendedHeuristicCompletion-PackageScope-Message'
				with: [ spec requires: 'ExtendedHeuristicCompletion-Benchmarks' ].

			spec
				package: 'ExtendedHeuristicCompletion-PackageScope-Variable'
				with: [ spec requires: 'ExtendedHeuristicCompletion-Benchmarks' ].

			spec package: 'ExtendedHeuristicCompletion-Dependency' with: [ spec requires: 'ExtendedHeuristicCompletion-Benchmarks' ].

			spec package: 'ExtendedHeuristicCompletion-Prefixes' with: [ spec requires: 'ExtendedHeuristicCompletion-Benchmarks' ].

			spec package: 'ExtendedHeuristicCompletion-Model' with: [ spec requires: 'ExtendedHeuristicCompletion-PackageScope-Variable' ]. "analyser"]
		
]
