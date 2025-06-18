Class {
	#name : 'CoAdaptiveMetaGlobalVariableFetcherTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CoAdaptiveMetaGlobalVariableFetcherTest >> setUp [ 

    | f1 f2 |
    f1 := CoCollectionFetcher onCollection:{ NECGlobalEntry contents: 'A1' node: nil }.
    f2 := CoCollectionFetcher onCollection:{ NECGlobalEntry contents: 'A2' node: nil }.
    fetcher := CoAdaptiveMetaGlobalVariableFetcher new.
    fetcher fetchersAndWeights: { f1 -> 0.5 . f2 -> 0.5 }.
    fetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: 'A').
    completionClass := CoMockClass new name: 'Cls'.
    fetcher completionClass: completionClass.
    fetcher registerSuccessfulFetch: f1.
    fetcher registerSuccessfulFetch: f1.
    fetcher registerSuccessfulFetch: f1.
    fetcher registerSuccessfulFetch: f2.
    fetcher updateWeightsBasedOnSuccess.
    expectedElements := {
        NECGlobalEntry contents: 'A1' node: nil .
        NECGlobalEntry contents: 'A2' node: nil }
]

{ #category : 'running' }
CoAdaptiveMetaGlobalVariableFetcherTest >> testAdaptiveOrdering [ 

    | fetched |
    fetched := self fetcher next: 2.
    fetched withIndexDo: [:each :index | self assertEntry: each equals: (expectedElements at: index) ].
    self assert: fetched size equals: expectedElements size
]
