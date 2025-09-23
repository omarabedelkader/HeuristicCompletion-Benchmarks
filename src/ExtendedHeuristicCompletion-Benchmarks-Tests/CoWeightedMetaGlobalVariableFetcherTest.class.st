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
CoWeightedMetaGlobalVariableFetcherTest >> testAggregatedWeightsDetermineOrdering [
	| firstStub secondStub thirdStub localFetcher collected |
	firstStub := CoWeightedMetaGlobalVariableFetcherTestFetcherStub new.
	firstStub entries: { (NECGlobalEntry contents: 'Beta' node: nil) }.

	secondStub := CoWeightedMetaGlobalVariableFetcherTestFetcherStub new.
	secondStub entries: {
	                (NECGlobalEntry contents: 'Alpha' node: nil).
	                (NECGlobalEntry contents: 'Beta' node: nil) }.

	thirdStub := CoWeightedMetaGlobalVariableFetcherTestFetcherStub new.
	thirdStub entries: { (NECGlobalEntry contents: 'Gamma' node: nil) }.

	localFetcher := CoWeightedMetaGlobalVariableFetcher new.
	localFetcher fetchersAndWeights: {
	                (firstStub -> 0.3).
	                (secondStub -> 0.5).
	                (thirdStub -> 0.1) }.
	localFetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: '').

	collected := OrderedCollection new.
	localFetcher entriesDo: [ :entry | collected add: entry contents ].

	self assert: collected asArray equals: #( 'Beta' 'Alpha' 'Gamma' )
]

{ #category : 'running' }
CoWeightedMetaGlobalVariableFetcherTest >> testCompletionClassPropagatesToFetchers [
	| stubs completionClass |
	stubs := {
	                CoWeightedMetaGlobalVariableFetcherTestFetcherStub new.
	                CoWeightedMetaGlobalVariableFetcherTestFetcherStub new }.

	fetcher fetchersAndWeights: {
	                (stubs first -> 0.4).
	                (stubs second -> 0.6) }.

	completionClass := Object.
	fetcher completionClass: completionClass.

	stubs do: [ :each |
	        self
	                assert: each completionClass
	                identicalTo: completionClass ]
]

{ #category : 'running' }
CoWeightedMetaGlobalVariableFetcherTest >> testWeightedOrdering [ 

    | fetched |
    fetched := self fetcher next: 2.
    fetched withIndexDo: [:each :index | self assertEntry: each equals: (expectedElements at: index) ].
    self assert: fetched size equals: expectedElements size
]
