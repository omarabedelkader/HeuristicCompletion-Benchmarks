Class {
	#name : 'CooGlobalSelectorFetcherTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CooGlobalSelectorFetcherTest >> setUp [ 

    systemNavigation := CoMockSystemNavigation new
        selectors: { #doThis. #doThat };
        yourself.
    fetcher := CooGlobalSelectorFetcher new.
    fetcher systemNavigation: systemNavigation.
    fetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: 'do').
]

{ #category : 'running' }
CooGlobalSelectorFetcherTest >> testNoAstNodeReturnsEmpty [ 

    | fetched |
    fetched := fetcher upToEnd.
    self assert: fetched isEmpty

]
