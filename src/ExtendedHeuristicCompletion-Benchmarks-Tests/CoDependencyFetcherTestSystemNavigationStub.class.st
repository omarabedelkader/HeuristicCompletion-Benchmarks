Class {
	#name : 'CoDependencyFetcherTestSystemNavigationStub',
	#superclass : 'CoReverseDependencyWithoutLocalPackageFetcher',
	#instVars : [
		'environment'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'accessing' }
CoDependencyFetcherTestSystemNavigationStub >> environment [
        ^ environment
]

{ #category : 'accessing' }
CoDependencyFetcherTestSystemNavigationStub >> environment: anEnvironment [
        environment := anEnvironment
]
