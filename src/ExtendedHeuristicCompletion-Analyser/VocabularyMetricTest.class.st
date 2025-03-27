Class {
	#name : 'VocabularyMetricTest',
	#superclass : 'TestCase',
	#category : 'ExtendedHeuristicCompletion-Analyser',
	#package : 'ExtendedHeuristicCompletion-Analyser'
}

{ #category : 'tests' }
VocabularyMetricTest >> percent: aFraction [

	^ aFraction asFloat round: 2
]

{ #category : 'tests' }
VocabularyMetricTest >> testDefinitionRatio [

	| vm |
	vm := VocabularyMetricer new.
	vm localDefinitions: #(A B C D E F).
	vm externalDefinitions: #(EA EB EC ED EF EG EH EI EJ EK).
	
	self assert: vm localityDefinitionRatio equals: (self percent: 6 / 16)
]
