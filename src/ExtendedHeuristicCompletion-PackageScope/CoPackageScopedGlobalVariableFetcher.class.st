"
I'm a fetcher knowing package.
"
Class {
	#name : 'CoPackageScopedGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'package',
		'completionClass',
		'organizer'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-CandidatesForPharoInclusion',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'CandidatesForPharoInclusion'
}

{ #category : 'accessing' }
CoPackageScopedGlobalVariableFetcher >> completionClass [

	^ completionClass
]

{ #category : 'accessing' }
CoPackageScopedGlobalVariableFetcher >> completionClass: anObject [

	completionClass := anObject.
	package := completionClass package.
	organizer := package organizer.
]

{ #category : 'enumerating' }
CoPackageScopedGlobalVariableFetcher >> fallbackEntriesDo: aBlock [ 

	^ self systemNavigation
		allGlobalNamesStartingWith: filter completionString
		do: [ :e | aBlock value: (NECGlobalEntry contents: e node: astNode) ]
		caseSensitive: filter isCaseSensitive 
]
