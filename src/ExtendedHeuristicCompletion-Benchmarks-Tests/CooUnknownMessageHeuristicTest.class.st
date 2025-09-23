Class {
	#name : 'CooUnknownMessageHeuristicTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'tests' }
CooUnknownMessageHeuristicTest >> testGlobalMessageFetcherPassesCompletionClassWhenSupported [
    | heuristic fetcher |
    heuristic := CooUnknownMessageHeuristicTestHeuristic new.
    heuristic globalMessageFetcherClass: CooUnknownMessageHeuristicTestFetcher.
    fetcher := heuristic newGlobalMessageFetcher.
    self assert: fetcher class equals: CooUnknownMessageHeuristicTestFetcher.
    self assert: fetcher receivedCompletionClass equals: heuristic completionClass.
]

{ #category : 'tests' }
CooUnknownMessageHeuristicTest >> testNewGlobalMessageFetcherUsesDefaultFetcher [
    | heuristic fetcher |
    heuristic := CooUnknownMessageHeuristic new.
    fetcher := heuristic newGlobalMessageFetcher.
    self assert: fetcher class equals: CoGlobalSelectorFetcher.
]
