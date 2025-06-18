Class {
	#name : 'CoDependencyPackageScopedGlobalVariableTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'tests' }
CoDependencyPackageScopedGlobalVariableTest >> testLocalFirst [

	| localFetcher  fetchedElements |
	localFetcher := CoDependencyPackageScopedGlobalVariableFetcher  new.
	localFetcher
		completionClass: nil;
		filter: (CoBeginsWithFilter caseSensitive: false filterString: 'Ai').

	fetchedElements := localFetcher upToEnd.

	"Because the package is empty and we have no 'completionClass', 
	 the default logic might just revert to the global fetcher or return the 2 globals."

	self assert: fetchedElements size equals: 2.
	self
		assert: (fetchedElements collect: #contents) asSet
		equals: #( 'AiGlobal1' 'AiGlobal2' ) asSet
]
