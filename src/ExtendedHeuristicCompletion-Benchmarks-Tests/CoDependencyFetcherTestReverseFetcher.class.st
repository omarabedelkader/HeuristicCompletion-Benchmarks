Class {
	#name : 'CoDependencyFetcherTestReverseFetcher',
	#superclass : 'CoReverseDependencyWithoutLocalPackageFetcher',
	#instVars : [
		'reverseDependencyMap'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'accessing' }
CoDependencyFetcherTestReverseFetcher >> reverseDependenciesOf: aPackageName [
        ^ reverseDependencyMap
                  at: aPackageName
                  ifAbsent: [ #(  ) ]
]

{ #category : 'accessing' }
CoDependencyFetcherTestReverseFetcher >> reverseDependencyMap: aDictionary [
        reverseDependencyMap := aDictionary
]
