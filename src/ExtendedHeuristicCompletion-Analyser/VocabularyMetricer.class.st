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

{ #category : 'use' }
VocabularyMetricer >> externalUses: aCollection [ 
	externalUses := aCollection 
]

{ #category : 'definitions' }
VocabularyMetricer >> localDefinitions: aCollection [ 
	localDefinitions := aCollection
]

{ #category : 'use' }
VocabularyMetricer >> localUses: aCollection [ 
	localUses := aCollection 
]

{ #category : 'definitions' }
VocabularyMetricer >> localityDefUseRatio [
	
	^ self percent: localUses size / localDefinitions size
]

{ #category : 'definitions' }
VocabularyMetricer >> localityDefinitionRatio [

	^ self percent: localDefinitions size / (localDefinitions size + externalDefinitions size) 
]

{ #category : 'use' }
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
	aStream cr.
	
	aStream << 'locality use ratio: '.
	self localityDefinitionRatio printOn: aStream.
	aStream << ' ('.
	localUses size printOn: aStream.
	aStream << '/'.
	(localUses size + externalUses size) printOn: aStream.
	aStream << ')'.
	aStream cr. 
	
	aStream << 'local def/use ratio: '.
	self localityDefUseRatio printOn: aStream.
	aStream << ' ('.
	localUses size printOn: aStream.
	aStream << '/'.
	localDefinitions size printOn: aStream.
	aStream << ')'.
	
	
	
]
