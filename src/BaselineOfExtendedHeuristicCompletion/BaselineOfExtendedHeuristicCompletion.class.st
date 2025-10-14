Class {
	#name : 'BaselineOfExtendedHeuristicCompletion',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfExtendedHeuristicCompletion',
	#package : 'BaselineOfExtendedHeuristicCompletion'
}

{ #category : 'baselines' }
BaselineOfExtendedHeuristicCompletion >> baseline: spec [

	<baseline>
	spec for: #common do: [
	spec package: 'ExtendedHeuristicCompletion-Benchmarks'.

	spec package: 'ExtendedHeuristicCompletion-Benchmarks-Tests' with: [ spec requires: #( 'ExtendedHeuristicCompletion-Benchmarks'
                                           'ExtendedHeuristicCompletion-Dependency')  ].

	spec
		package: 'ExtendedHeuristicCompletion-PackageScope-Message'
		with: [ spec requires: 'ExtendedHeuristicCompletion-Benchmarks' ].

	spec
		package: 'ExtendedHeuristicCompletion-PackageScope-Variable'
		with: [ spec requires: 'ExtendedHeuristicCompletion-Benchmarks' ].

	spec package: 'ExtendedHeuristicCompletion-Dependency' with: [ spec requires: 'ExtendedHeuristicCompletion-Benchmarks' ].

	spec package: 'ExtendedHeuristicCompletion-Prefixes' with: [ spec requires: 'ExtendedHeuristicCompletion-Benchmarks' ].

	spec package: 'ExtendedHeuristicCompletion-Model' with: [ spec requires: 'ExtendedHeuristicCompletion-PackageScope-Variable' ]. "analyser"
	spec package: 'ExtendedHeuristicCompletion-Analyser-Data'.
	spec package: 'ExtendedHeuristicCompletion-Analyser-Data2'.
	spec package: 'ExtendedHeuristicCompletion-Analyser-Data3' with: [ spec requires: 'ExtendedHeuristicCompletion-Analyser-Data2' ].

	spec package: 'ExtendedHeuristicCompletion-Analyser-Data4' with: [
			spec requires: 'ExtendedHeuristicCompletion-Analyser-Data'.
			spec requires: 'ExtendedHeuristicCompletion-Analyser-Data2' ].


	spec package: 'ExtendedHeuristicCompletion-Analyser'
		]
]
