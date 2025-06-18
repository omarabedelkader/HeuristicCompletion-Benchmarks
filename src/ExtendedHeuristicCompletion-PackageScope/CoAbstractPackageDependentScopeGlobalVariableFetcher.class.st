"
I'm a fetcher supporting group of packages
"
Class {
	#name : 'CoAbstractPackageDependentScopeGlobalVariableFetcher',
	#superclass : 'CoPackageScopedGlobalVariableFetcher',
	#classVars : [
		'Dependencies'
	],
	#classInstVars : [
		'dependencies'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-CandidatesForPharoInclusion',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'CandidatesForPharoInclusion'
}

{ #category : 'accessing' }
CoAbstractPackageDependentScopeGlobalVariableFetcher class >> computeDependenciesOf: aPackageName [
	
	^ StDependencyChecker new dependenciesOf: aPackageName
]

{ #category : 'accessing' }
CoAbstractPackageDependentScopeGlobalVariableFetcher class >> dependenciesOf: aPackageName [

	^ self dependencyCache at: aPackageName ifAbsentPut: [ self computeDependenciesOf: aPackageName ]
]

{ #category : 'accessing' }
CoAbstractPackageDependentScopeGlobalVariableFetcher class >> dependencyCache [

	^ Dependencies ifNil: [ Dependencies := Dictionary new ]
]

{ #category : 'accessing' }
CoAbstractPackageDependentScopeGlobalVariableFetcher class >> resetCache [

	Dependencies := nil
]

{ #category : 'enumerating' }
CoAbstractPackageDependentScopeGlobalVariableFetcher >> dependenciesOf: aString [

	^ self class dependenciesOf: aString
]
