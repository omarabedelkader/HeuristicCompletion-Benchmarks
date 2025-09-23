Class {
	#name : 'CoDependencyFetcherTestDirectFetcher',
	#superclass : 'CoDependencyPackageWithoutLocalPackageFetcher',
	#instVars : [
		'dependencyMap'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'accessing' }
CoDependencyFetcherTestDirectFetcher >> dependenciesOf: aPackageName [
        ^ dependencyMap
                  at: aPackageName
                  ifAbsent: [ #(  ) ]
]

{ #category : 'accessing' }
CoDependencyFetcherTestDirectFetcher >> dependencyMap: aDictionary [
        dependencyMap := aDictionary
]
