Class {
	#name : 'CoDependencyFetcherTestEnvironmentStub',
	#superclass : 'Object',
	#instVars : [
		'keys'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'as yet unclassified' }
CoDependencyFetcherTestEnvironmentStub class >> withKeys: aCollection [ 
        ^ self new
                  keys: aCollection;
                  yourself
]

{ #category : 'accessing' }
CoDependencyFetcherTestEnvironmentStub >> keys [ 
        ^ keys
]

{ #category : 'accessing' }
CoDependencyFetcherTestEnvironmentStub >> keys: aCollection [
        keys := aCollection
]
