Class {
	#name : 'CoWeightedMetaGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'fetchersAndWeights',
		'completionClass'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Dependency',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Dependency'
}

{ #category : 'as yet unclassified' }
CoWeightedMetaGlobalVariableFetcher class >> defaultFetcher [ 

	^ self new
		fetchersAndWeights: {
			(CoRepositoryPackageScopedGlobalVariableFetcher new) -> 0.5.
			(CoDependencyPackageScopedGlobalVariableFetcher new) -> 0.3.
			(CoGlobalVariablesHeuristic new) -> 0.2
		};
		yourself
]

{ #category : 'as yet unclassified' }
CoWeightedMetaGlobalVariableFetcher class >> withDefaultFetchers [ 
	^ self new
		fetchersAndWeights: {
			(CoRepositoryPackageScopedGlobalVariableFetcher new) -> 0.5.
			(CoDependencyPackageScopedGlobalVariableFetcher new) -> 0.3.
			(CoGlobalVariablesHeuristic new) -> 0.2
		};
		yourself
]

{ #category : 'accessing' }
CoWeightedMetaGlobalVariableFetcher >> completionClass [ 

	^ completionClass
]

{ #category : 'accessing' }
CoWeightedMetaGlobalVariableFetcher >> completionClass: anObject [ 
	completionClass := anObject.
	fetchersAndWeights ifNotNil: [
		fetchersAndWeights do: [:pair |
			(pair key respondsTo: #completionClass:) ifTrue: [
				pair key completionClass: anObject ]]].

]

{ #category : 'accessing' }
CoWeightedMetaGlobalVariableFetcher >> entriesDo: aBlock [

	| suggestionsMap case string |
	suggestionsMap := Dictionary new.
	string := filter completionString.
	case := NECPreferences caseSensitive.

	fetchersAndWeights do: [ :pair |
			| fetcher weight |
			fetcher := pair key.
			weight := pair value.
			fetcher entriesDo: [ :entry |
					| name |
					name := entry contents.
					(suggestionsMap includesKey: name)
						ifTrue: [
						suggestionsMap at: name put: (suggestionsMap at: name) + weight ]
						ifFalse: [ suggestionsMap at: name put: weight ] ] ].

	(suggestionsMap associations
		asSortedCollection: [ :a :b | a value > b value ]) do: [ :assoc |
				| name |
				name := assoc key.
				aBlock value: (NECGlobalEntry contents: name node: nil) ].

]

{ #category : 'accessing' }
CoWeightedMetaGlobalVariableFetcher >> fetchersAndWeights: aCollection [ 

	fetchersAndWeights := aCollection
]

{ #category : 'accessing' }
CoWeightedMetaGlobalVariableFetcher >> initialize [

	super initialize.
	fetchersAndWeights := {
		                      (CoRepositoryPackageScopedGlobalVariableFetcher
			                       new -> 0.5).
		                      (CoDependencyPackageScopedGlobalVariableFetcher
			                       new -> 0.3).
		                      (CoTransitiveDependencyPackageScopedGlobalVariableFetcher new -> 0.2) "Fallback to vanilla global" }
		                      asOrderedCollection
]
