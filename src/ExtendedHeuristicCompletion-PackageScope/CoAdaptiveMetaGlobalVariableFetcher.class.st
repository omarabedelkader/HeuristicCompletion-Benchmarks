Class {
	#name : 'CoAdaptiveMetaGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'fetchersAndWeights',
		'successCounts',
		'completionClass'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Dependency',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Dependency'
}

{ #category : 'initialization' }
CoAdaptiveMetaGlobalVariableFetcher >> completionClass [ 

    ^ completionClass
]

{ #category : 'initialization' }
CoAdaptiveMetaGlobalVariableFetcher >> completionClass: anObject [ 
    completionClass := anObject.
    fetchersAndWeights ifNotNil: [
        fetchersAndWeights do: [:pair |
            (pair key respondsTo: #completionClass:) ifTrue: [
                pair key completionClass: anObject
            ]
        ]
    ].
]

{ #category : 'initialization' }
CoAdaptiveMetaGlobalVariableFetcher >> entriesDo: aBlock [ 

    | suggestionsMap case string |
    suggestionsMap := Dictionary new.
    string := filter completionString.
    case := NECPreferences caseSensitive.

    fetchersAndWeights do: [:pair |
        | fetcher weight |
        fetcher := pair key.
        weight := pair value.
        fetcher entriesDo: [:entry |
            | name |
            name := entry contents.
            (suggestionsMap includesKey: name)
                ifTrue: [ suggestionsMap at: name put: (suggestionsMap at: name) + weight ]
                ifFalse: [ suggestionsMap at: name put: weight ]
        ]
    ].

    (suggestionsMap associations
        asSortedCollection: [:a :b | a value > b value ]) do: [:assoc |
        | name |
        name := assoc key.
        aBlock value: (NECGlobalEntry contents: name node: nil)
    ].
]

{ #category : 'initialization' }
CoAdaptiveMetaGlobalVariableFetcher >> fetchersAndWeights: aCollection [ 

    fetchersAndWeights := aCollection.
    successCounts := Dictionary new.
    fetchersAndWeights do: [:pair |
        successCounts at: pair key put: 0].
]

{ #category : 'initialization' }
CoAdaptiveMetaGlobalVariableFetcher >> initialize [ 

    super initialize.
    fetchersAndWeights := {
        (CoRepositoryPackageScopedGlobalVariableFetcher new) -> 0.5.
        (CoDependencyPackageScopedGlobalVariableFetcher new) -> 0.3.
        (CoTransitiveDependencyPackageScopedGlobalVariableFetcher new) -> 0.2
    } asOrderedCollection.

    successCounts := Dictionary new.
    fetchersAndWeights do: [:pair |
        successCounts at: pair key put: 0].
]

{ #category : 'initialization' }
CoAdaptiveMetaGlobalVariableFetcher >> registerSuccessfulFetch: aFetcher [ 

    successCounts at: aFetcher put: ((successCounts at: aFetcher ifAbsent: [0]) + 1).
]

{ #category : 'initialization' }
CoAdaptiveMetaGlobalVariableFetcher >> updateWeightsBasedOnSuccess [ 

    | total successes newWeights |
    successes := fetchersAndWeights collect: [:pair |
        successCounts at: pair key ifAbsent: [0]
    ].
    total := successes sum asFloat.
    total = 0 ifTrue: [ ^ self ].

    newWeights := OrderedCollection new.
    fetchersAndWeights doWithIndex: [:pair :i |
        | fetcher newWeight |
        fetcher := pair key.
        newWeight := (successCounts at: fetcher ifAbsent: [0]) / total.
        newWeights add: (fetcher -> newWeight)
    ].

    fetchersAndWeights := newWeights.
]
