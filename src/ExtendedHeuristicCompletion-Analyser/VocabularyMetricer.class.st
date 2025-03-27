Class {
	#name : 'VocabularyMetricer',
	#superclass : 'Object',
	#instVars : [
		'localDefinitions',
		'externalDefinitions'
	],
	#category : 'ExtendedHeuristicCompletion-Analyser',
	#package : 'ExtendedHeuristicCompletion-Analyser'
}

{ #category : 'as yet unclassified' }
VocabularyMetricer >> externalDefinitions: aCollection [ 
	externalDefinitions := aCollection
]

{ #category : 'as yet unclassified' }
VocabularyMetricer >> localDefinitions: aCollection [ 
	localDefinitions := aCollection
]

{ #category : 'as yet unclassified' }
VocabularyMetricer >> localityDefinitionRatio [

	^ self percent: localDefinitions size / (localDefinitions size + externalDefinitions size) 
]

{ #category : 'tests' }
VocabularyMetricer >> percent: aNumber [ 
	^ aNumber asFloat round: 2
]
