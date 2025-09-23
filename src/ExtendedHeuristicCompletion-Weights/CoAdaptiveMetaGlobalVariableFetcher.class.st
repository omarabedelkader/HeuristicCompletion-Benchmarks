"
`CoAdaptiveMetaGlobalVariableFetcher` is a smart, self-adjusting global variable fetcher that dynamically re-weights its underlying heuristics based on their past success. It’s designed to improve code completion suggestions over time by **learning from usage patterns**.

### Core Responsibilities

- **Combines Multiple Heuristic Fetchers**: It wraps several other fetchers, each responsible for suggesting global variables from different scopes.
- **Applies Adaptive Weights**: Unlike static weighting systems, this fetcher updates the weight (influence) of each sub-fetcher based on how often their suggestions are selected successfully.
- **Learns Over Time**: Every time a fetcher produces a successful suggestion, it’s recorded via `registerSuccessfulFetch:`. Periodically, weights are updated via `updateWeightsBasedOnSuccess` to prioritize better-performing fetchers.

### How It Works

1. **Initialization**:
   - Starts with a predefined weighted list of fetchers (e.g., repository-scoped, dependency-scoped, and transitive).
   - Initializes a success count dictionary to track how often each fetcher contributes a successful suggestion.

2. **Fetching Suggestions**:
   - When `entriesDo:` is called, each fetcher contributes suggestions.
   - Duplicate suggestions are combined, with their weights summed.
   - The resulting suggestions are sorted by total weight and passed to the provided block.

3. **Tracking Successes**:
   - If a suggestion is selected from a specific fetcher, `registerSuccessfulFetch:` is called with that fetcher.
   - This increases its success count.

4. **Rebalancing Weights**:
   - Calling `updateWeightsBasedOnSuccess` recalculates each fetcher’s weight based on the proportion of total successes it has accumulated.
   - Fetchers with higher success rates will contribute more strongly to future suggestions.

### Why Use This?

This fetcher is ideal when:
- You want **contextual, behavior-driven completion**, tailored to how developers actually use the system.
- The relevance of different fetchers may **shift over time** depending on project structure or team workflows.
- You want a **feedback loop** that improves the user experience without manual tuning.
"
Class {
	#name : 'CoAdaptiveMetaGlobalVariableFetcher',
	#superclass : 'CoPackageScopedGlobalVariableFetcher',
	#instVars : [
		'fetchersAndWeights',
		'successCounts'
	],
	#category : 'ExtendedHeuristicCompletion-Weights',
	#package : 'ExtendedHeuristicCompletion-Weights'
}

{ #category : 'initialization' }
CoAdaptiveMetaGlobalVariableFetcher >> completionClass: anObject [ 
	completionClass := anObject.
	self flag: #todo. "this is horrible"
	fetchersAndWeights ifNotNil: [
		fetchersAndWeights do: [:pair |
            (pair key respondsTo: #completionClass:) ifTrue: [
                pair key completionClass: anObject
            ]
        ]
    ].
]

{ #category : 'enumerating' }
CoAdaptiveMetaGlobalVariableFetcher >> entriesDo: aBlock [ 

    | suggestionsMap |
    suggestionsMap := Dictionary new.

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
        asSortedCollection: [:a :b | a value > b value ]) do: [ :assoc |
        aBlock value: ((NECGlobalEntry contents: assoc key node: nil) fetcher: self ; yourself)
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
        (CoLateralPackageWithLocalPackageFetcher new) -> 0.5.
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
