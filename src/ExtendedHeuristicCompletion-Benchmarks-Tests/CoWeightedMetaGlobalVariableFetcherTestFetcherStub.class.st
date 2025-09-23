Class {
	#name : 'CoWeightedMetaGlobalVariableFetcherTestFetcherStub',
	#superclass : 'Object',
	#instVars : [
		'entries',
		'completionClass'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'enumerating' }
CoWeightedMetaGlobalVariableFetcherTestFetcherStub >> completionClass [
	^ completionClass
]

{ #category : 'enumerating' }
CoWeightedMetaGlobalVariableFetcherTestFetcherStub >> completionClass: aClass [
	completionClass := aClass
]

{ #category : 'enumerating' }
CoWeightedMetaGlobalVariableFetcherTestFetcherStub >> entries: aCollection [
	entries := aCollection
]

{ #category : 'enumerating' }
CoWeightedMetaGlobalVariableFetcherTestFetcherStub >> entriesDo: aBlock [
	entries ifNil: [ ^ self ].
	entries do: aBlock
]
