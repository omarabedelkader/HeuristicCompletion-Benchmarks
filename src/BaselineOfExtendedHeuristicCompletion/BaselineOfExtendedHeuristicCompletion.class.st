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
		spec package: 'ExtendedHeuristicCompletion-PackageScope' with: [ 
			spec requires: 'ExtendedHeuristicCompletion-Benchmarks' ].
		spec package: 'ExtendedHeuristicCompletion-History'.
	
		"analyser"
		spec package: 'ExtendedHeuristicCompletion-Benchmarks-Analyser-Data'.
		spec package: 'ExtendedHeuristicCompletion-Benchmarks-Analyser-Data2'.
		spec package: 'ExtendedHeuristicCompletion-Benchmarks-Analyser'
			 with: [ spec requires: #( 
						'ExtendedHeuristicCompletion-Benchmarks-Analyser-Data' 
					 	'ExtendedHeuristicCompletion-Benchmarks-Analyser-Data2') ].
		
		spec package: 'ExtendedHeuristicCompletion-Benchmarks-Data'
			 with: [ spec requires: 'ExtendedHeuristicCompletion-Benchmarks' ]]
]
