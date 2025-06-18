Class {
	#name : 'CoDependencyPackageScopedGlobalVariableTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'tests' }
CoDependencyPackageScopedGlobalVariableTest >> testLocalFirstThenDependent [
	| localFetcher  fetchedElements |
	localFetcher := CoDependencyPackageScopedGlobalVariableFetcher  new.
	localFetcher
		completionClass: ClassWithDependencyOnData2;
		filter: (CoBeginsWithFilter caseSensitive: false filterString: 'Diff').

	fetchedElements := localFetcher next: 3.

	self assert: fetchedElements size equals: 3.
	self
		assert: (fetchedElements collect: #contents) asArray
		equals: #( 'DifferentAnalyserData4' 'DifferentAnalyserData1' 'DifferentAnalyserData2')
]

{ #category : 'tests' }
CoDependencyPackageScopedGlobalVariableTest >> testWhenNoLocalThenDependentPackages [

	| localFetcher  fetchedElements |
	localFetcher := CoDependencyPackageScopedGlobalVariableFetcher  new.
	localFetcher
		completionClass: ClassWithDependencyOnData2;
		filter: (CoBeginsWithFilter caseSensitive: false filterString: 'An').

	fetchedElements := localFetcher next: 3.

	self assert: fetchedElements size equals: 3.
	self
		assert: (fetchedElements collect: #contents) asArray 
		equals: #(#AnalyserA #AnalyserData1 #AnalyserData1SharedPool)
]
