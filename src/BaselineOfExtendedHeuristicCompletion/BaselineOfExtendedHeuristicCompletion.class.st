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
		spec package: 'ExtendedHeuristicCompletion-Benchmarks-Tests'.
		spec package: 'HeuristicCompletion-PackageScope' with: [ 
			spec requires: 'ExtendedHeuristicCompletion-Benchmarks-Tests' ].
		spec package: 'ExtendedHeuristicCompletion-History'.
		spec package: 'ExtendedHeuristicCompletion-Benchmarks-Analyser'.
		spec package: 'ExtendedHeuristicCompletion-Benchmarks-Data'
			 with: [ spec requires: 'ExtendedHeuristicCompletion-Benchmarks-Tests' ]]
]
