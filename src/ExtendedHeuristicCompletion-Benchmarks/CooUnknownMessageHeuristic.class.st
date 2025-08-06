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

{ #category : 'nil' }
CooUnknownMessageHeuristic >> buildFetcherFor: aNode inContext: completionContext [

	^ self globalMessageFetcherClass new
		  completionClass: completionContext completionClass;
		  astNode: aNode;
		  yourself
]

{ #category : 'as yet unclassified' }
CooUnknownMessageHeuristic >> globalMessageFetcher [
    "Return the fetcher instance that supplies global selectors for unknown messages.
     IMPORTANT: honor #globalMessageFetcherClass and avoid compile-time unknown sends."
    | f |
    f := self globalMessageFetcherClass new.

    "If the fetcher supports completionClass:, try to pass one *if we can* without hard-coding a send."
    (f respondsTo: #completionClass:) ifTrue: [
        (self respondsTo: #completionClass)
            ifTrue: [ f completionClass: (self perform: #completionClass) ] ].

    ^ f
]

{ #category : 'accessing' }
CooUnknownMessageHeuristic >> globalMessageFetcherClass [

	^ globalMessageFetcherClass ifNil: [  globalMessageFetcherClass := CoGlobalSelectorFetcher ]
]

{ #category : 'accessing' }
CooUnknownMessageHeuristic >> globalMessageFetcherClass: aClass [

	globalMessageFetcherClass := aClass
]

{ #category : 'as yet unclassified' }
CooUnknownMessageHeuristic >> newGlobalMessageFetcher [
    ^ self globalMessageFetcher
]
