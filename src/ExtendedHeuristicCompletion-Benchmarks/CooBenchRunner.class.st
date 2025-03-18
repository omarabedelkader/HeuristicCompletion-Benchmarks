Class {
	#name : 'CooBenchRunner',
	#superclass : 'Object',
	#instVars : [
		'package',
		'builder'
	],
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
CooBenchRunner >> builder: aBuilder [

	builder := aBuilder
]

{ #category : 'accessing' }
CooBenchRunner >> package: aPackage [

	package := aPackage

	
]
