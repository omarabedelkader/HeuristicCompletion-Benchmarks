Class {
	#name : 'CooUnknownMessageHeuristicTestFetcher',
	#superclass : 'Object',
	#instVars : [
		'receivedCompletionClass'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'accessing' }
CooUnknownMessageHeuristicTestFetcher >> completionClass: aClass [
    receivedCompletionClass := aClass
]

{ #category : 'accessing' }
CooUnknownMessageHeuristicTestFetcher >> receivedCompletionClass [
    ^ receivedCompletionClass
]
