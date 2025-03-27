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

{ #category : 'definitions' }
VocabularyMetricer >> externalDefinitions: aCollection [ 
	externalDefinitions := aCollection
]

{ #category : 'definitions' }
VocabularyMetricer >> localDefinitions: aCollection [ 
	localDefinitions := aCollection
]

{ #category : 'definitions' }
VocabularyMetricer >> localityDefinitionRatio [

	^ self percent: localDefinitions size / (localDefinitions size + externalDefinitions size) 
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
