Class {
	#name : 'CooUnknownMessageHeuristic',
	#superclass : 'CoUnknownMessageHeuristic',
	#instVars : [
		'globalMessageFetcherClass'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Heuristics-Extensions',
	#package : 'ExtendedHeuristicCompletion-Benchmarks',
	#tag : 'Heuristics-Extensions'
}

{ #category : 'accessing' }
CooUnknownMessageHeuristic >> globalMessageFetcherClass [

	^ globalMessageFetcherClass ifNil: [  globalMessageFetcherClass := CoGlobalSelectorFetcher ]
]

{ #category : 'accessing' }
CooUnknownMessageHeuristic >> globalMessageFetcherClass: aClass [

	globalMessageFetcherClass := aClass
]
