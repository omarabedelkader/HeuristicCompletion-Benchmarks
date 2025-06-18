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
		self defineDependencies: spec.
		self definePackages: spec.
		]
]

{ #category : 'baselines' }
BaselineOfExtendedHeuristicCompletion >> defineDependencies: spec [

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]

{ #category : 'baselines' }
BaselineOfExtendedHeuristicCompletion >> definePackages: spec [

		spec package: 'ExtendedHeuristicCompletion-Benchmarks'.
		spec package: 'ExtendedHeuristicCompletion-Benchmarks-Tests' 
			with: [spec requires:
							'ExtendedHeuristicCompletion-Benchmarks'].
		spec package: 'ExtendedHeuristicCompletion-PackageScope' 
			with: [spec requires:
							'ExtendedHeuristicCompletion-Benchmarks'].
		spec package: 'ExtendedHeuristicCompletion-History'.
		spec package: 'ExtendedHeuristicCompletion-OllamaAPI'.
		spec package: 'ExtendedHeuristicCompletion-Model'
			with: [ spec requires:'ExtendedHeuristicCompletion-PackageScope' ].
	
		"analyser"
		spec package: 'ExtendedHeuristicCompletion-Analyser-Data'.
		spec package: 'ExtendedHeuristicCompletion-Analyser-Data2'.
		spec 
			package: 'ExtendedHeuristicCompletion-Analyser-Data3'
			with: [ spec requires: 'ExtendedHeuristicCompletion-Analyser-Data2' ].
		
		spec 
			package: 'ExtendedHeuristicCompletion-Analyser-Data4'
			with: [ 
				spec requires: 'ExtendedHeuristicCompletion-Analyser-Data'.
				spec requires: 'ExtendedHeuristicCompletion-Analyser-Data2' ].
		
		
		spec package: 'ExtendedHeuristicCompletion-Analyser' .

]
