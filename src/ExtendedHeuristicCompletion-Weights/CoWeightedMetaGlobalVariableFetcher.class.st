"
`CoWeightedMetaGlobalVariableFetcher` is a composite fetcher that combines results from multiple global variable fetchers using a weighted scoring system.

- **Aggregates Multiple Fetchers**: It wraps several different global variable fetchers, each responsible for suggesting variables from a different scope (e.g., repository, dependency, or transitive dependency).
- **Applies Weighted Heuristics**: Each fetcher contributes to the final result based on an assigned weight, which reflects its importance or reliability. Higher weights mean the fetcher's suggestions are more likely to appear at the top.
- **Normalizes and Ranks Suggestions**: It collects suggestions from all fetchers, sums the weights for duplicate names, and sorts them in descending order by total weight before presenting them.
- **Supports Configuration**: You can customize the fetchers and their weights or use the sensible defaults provided via `defaultFetcher` or `withDefaultFetchers`.


"
Class {
	#name : 'CoWeightedMetaGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'fetchersAndWeights',
		'completionClass'
	],
	#category : 'ExtendedHeuristicCompletion-Weights',
	#package : 'ExtendedHeuristicCompletion-Weights'
}

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

{ #category : 'enumerating' }
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
						ifTrue: [ suggestionsMap at: name put: (suggestionsMap at: name) + weight ]
						ifFalse: [ suggestionsMap at: name put: weight ] ] ].

	(suggestionsMap associations
		asSortedCollection: [ :a :b | a value > b value ]) do: [ :assoc |
				| name |
				name := assoc key.
				aBlock value: ((NECGlobalEntry contents: name node: nil)  fetcher: self ; yourself)].

]

{ #category : 'accessing' }
CoWeightedMetaGlobalVariableFetcher >> fetchersAndWeights: aCollection [ 

	fetchersAndWeights := aCollection
]

{ #category : 'initialization' }
CoWeightedMetaGlobalVariableFetcher >> initialize [

	super initialize.
	fetchersAndWeights := {(CoDependencyPackageScopedGlobalVariableFetcher
			                       new -> 0.7).
		                      (CoLateralPackageWithLocalPackageFetcher
			                       new -> 0.05).
		                      
		                      (CoTransitiveDependencyPackageScopedGlobalVariableFetcher
			                       new -> 0.25) } asOrderedCollection
]
