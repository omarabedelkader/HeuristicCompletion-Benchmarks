Class {
	#name : 'CoPackageScopedGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'packages',
		'completionClass'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-CandidatesForPharoInclusion',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'CandidatesForPharoInclusion'
}

{ #category : 'enumerating' }
CoPackageScopedGlobalVariableFetcher >> dependenciesOf: aString [

	^ self class dependenciesOf: aString
]

{ #category : 'enumerating' }
CoPackageScopedGlobalVariableFetcher >> fallbackEntriesDo: aBlock [ 

	^ self systemNavigation
		allGlobalNamesStartingWith: filter completionString
		do: [ :e | aBlock value: (NECGlobalEntry contents: e node: astNode) ]
		caseSensitive: NECPreferences caseSensitive
]

{ #category : 'enumerating' }
CoPackageScopedGlobalVariableFetcher >> packages: aCollection [

	packages := aCollection
]
