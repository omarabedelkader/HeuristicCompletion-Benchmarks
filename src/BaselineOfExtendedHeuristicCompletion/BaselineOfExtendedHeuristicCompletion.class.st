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
		spec package: 'ExtendedHeuristicCompletion-PackageScope' 
			with: [spec requires:
							'ExtendedHeuristicCompletion-Benchmarks'].
		spec package: 'ExtendedHeuristicCompletion-History'.
		spec package: 'ExtendedHeuristicCompletion-OllamaAPI'.
	
		"analyser"
		spec package: 'ExtendedHeuristicCompletion-Analyser-Data'.
		spec package: 'ExtendedHeuristicCompletion-Analyser-Data2'.
		spec package: 'ExtendedHeuristicCompletion-Analyser'
			 with: [ spec requires: #( 
						'ExtendedHeuristicCompletion-Analyser-Data' 
					 	'ExtendedHeuristicCompletion-Analyser-Data2') ].
		]
]

{ #category : 'baselines' }
BaselineOfExtendedHeuristicCompletion >> defineDependencies: spec [ 

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]
