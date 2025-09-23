Class {
	#name : 'CoDependencyFetcherTestOrganizerStub',
	#superclass : 'Object',
	#instVars : [
		'packages'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'accessing' }
CoDependencyFetcherTestOrganizerStub >> packageNamed: aString ifAbsent: aBlock [
        ^ packages
                  at: aString
                  ifAbsent: aBlock
]

{ #category : 'accessing' }
CoDependencyFetcherTestOrganizerStub >> packages: aDictionary [
        packages := aDictionary
]
