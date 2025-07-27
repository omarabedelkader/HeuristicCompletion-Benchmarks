Class {
	#name : 'CoWeightedMetaGlobalVariableFetcherTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CoWeightedMetaGlobalVariableFetcherTest >> setUp [

	super setUp.
	fetcher := CoWeightedMetaGlobalVariableFetcher new.
	fetcher fetchersAndWeights: {
			((CoCollectionFetcher onCollection:
				  { (NECGlobalEntry contents: 'A2' node: nil) }) -> 0.2).
			((CoCollectionFetcher onCollection:
				  { (NECGlobalEntry contents: 'A1' node: nil) }) -> 0.7).
			((CoCollectionFetcher onCollection:
				  { (NECGlobalEntry contents: 'A1' node: nil) }) -> 0.1) }.
	fetcher filter:
		(CoBeginsWithFilter caseSensitive: false filterString: 'A').
	expectedElements := {
		                    (NECGlobalEntry contents: 'A1' node: nil).
		                    (NECGlobalEntry contents: 'A2' node: nil) }
]

{ #category : 'running' }
CoWeightedMetaGlobalVariableFetcherTest >> testWeightedOrdering [ 

    | fetched |
    fetched := self fetcher next: 2.
    fetched withIndexDo: [:each :index | self assertEntry: each equals: (expectedElements at: index) ].
    self assert: fetched size equals: expectedElements size
]
