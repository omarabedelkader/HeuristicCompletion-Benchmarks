Class {
	#name : 'CoDependencyFetcherTestPackageStub',
	#superclass : 'Object',
	#instVars : [
		'name',
		'definedClasses',
		'organizer'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'accessing' }
CoDependencyFetcherTestPackageStub >> definedClasses [ 
        ^ definedClasses ifNil: [ #(  ) ]
]

{ #category : 'accessing' }
CoDependencyFetcherTestPackageStub >> definedClasses: aCollection [
        definedClasses := aCollection
]

{ #category : 'accessing' }
CoDependencyFetcherTestPackageStub >> name [
        ^ name
]

{ #category : 'accessing' }
CoDependencyFetcherTestPackageStub >> name: aString [
        name := aString
]

{ #category : 'accessing' }
CoDependencyFetcherTestPackageStub >> organizer [
        ^ organizer
]

{ #category : 'accessing' }
CoDependencyFetcherTestPackageStub >> organizer: anOrganizer [
        organizer := anOrganizer
]
