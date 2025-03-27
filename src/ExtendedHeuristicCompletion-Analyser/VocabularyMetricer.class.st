Class {
	#name : 'VocabularyMetricer',
	#superclass : 'Object',
	#instVars : [
		'localDefinitions',
		'externalDefinitions',
		'localUses',
		'externalUses'
	],
	#category : 'ExtendedHeuristicCompletion-Analyser',
	#package : 'ExtendedHeuristicCompletion-Analyser'
}

{ #category : 'definitions' }
VocabularyMetricer >> externalDefinitions: aCollection [ 
	externalDefinitions := aCollection
]

{ #category : 'as yet unclassified' }
VocabularyMetricer >> externalUses: aCollection [ 
	externalUses := aCollection 
]

{ #category : 'definitions' }
VocabularyMetricer >> localDefinitions: aCollection [ 
	localDefinitions := aCollection
]

{ #category : 'as yet unclassified' }
VocabularyMetricer >> localUses: aCollection [ 
	localUses := aCollection 
]

{ #category : 'as yet unclassified' }
VocabularyMetricer >> localityDefUseRatio [
	
	^ self percent: localUses size / localDefinitions size
]

{ #category : 'definitions' }
VocabularyMetricer >> localityDefinitionRatio [

	^ self percent: localDefinitions size / (localDefinitions size + externalDefinitions size) 
]

{ #category : 'as yet unclassified' }
VocabularyMetricer >> localityUseRatio [
	^ self percent: (localUses size / (localUses size + externalUses size)) 
]

{ #category : 'tests' }
VocabularyMetricer >> percent: aNumber [ 
	^ aNumber asFloat round: 2
]

{ #category : 'printing' }
VocabularyMetricer >> printOn: aStream [

	aStream << 'locality definition ratio: '.
	self localityDefinitionRatio printOn: aStream.
	aStream << ' ('.
	localDefinitions size printOn: aStream.
	aStream << '/'.
	(externalDefinitions size + localDefinitions size) printOn: aStream.
	aStream << ')'.
	
]
