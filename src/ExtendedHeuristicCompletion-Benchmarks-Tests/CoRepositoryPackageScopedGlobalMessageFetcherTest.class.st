Class {
	#name : 'CoRepositoryPackageScopedGlobalMessageFetcherTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CoRepositoryPackageScopedGlobalMessageFetcherTest >> setUp [ 

    | a b organizer dict |
    completionClass := CoMockClass new name: 'Comp'.
    package := CoMockPackage new.
    package name: 'P1-Core'.
    package definedClasses: { completionClass }.
    completionClass package: package.

    organizer := CoMockPackageOrganizer new.
    organizer packages: { package }.
    package organizer: organizer.

    dict := Dictionary new.
    { 'foo'. 'bar' } do: [:e | dict at: e put: e ].
    systemNavigation := CoMockSystemNavigation new
        globals: dict;
        yourself.

    fetcher := CoRepositoryPackageScopedGlobalMessageFetcher new.
    fetcher packages: { package }.
    fetcher systemNavigation: systemNavigation.
    fetcher completionClass: completionClass.
    fetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: 'f').

    expectedElements := {
        NECGlobalEntry contents: 'foo' node: nil }
]

{ #category : 'running' }
CoRepositoryPackageScopedGlobalMessageFetcherTest >> testReturnGlobalsWhenNoAstNode [ 

    | fetched |
    fetched := self fetcher upToEnd.
    fetched withIndexDo: [:each :index | self assertEntry: each equals: (expectedElements at: index) ].
    self assert: fetched size equals: expectedElements size
]
