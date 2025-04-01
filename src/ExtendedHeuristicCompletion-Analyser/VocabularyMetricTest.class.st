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
VocabularyMetricTest >> testDefUsesRatio [

	| vm |
	vm := VocabularyMetricer new.
	vm localDefinitions: #(A B C D E F).
	vm externalDefinitions: #(EA EB EC ED EF EG EH EI EJ EK).
	
	"here we have only A B C that are used"
	vm localUses: #(A B C).
	vm externalUses: #(EA EB EC ED EF). 
	
	self assert: vm localityDefUseRatio equals: (self percent: 3 / 6)
]

{ #category : 'tests' }
VocabularyMetricTest >> testDefUsesRatioPrefix [

	| vm |
	self skip.
	vm := VocabularyMetricer new.
	vm localDefinitions: #(Ane Announce Analphabet Addition Adouber France).
	vm externalDefinitions: #(Anneau Adapter Anhydrique Goulu Pharo Framacon Franc).
	
	"here we have only A B C that are used"
	vm localUses: #(A B C).
	vm externalUses: #(EA EB EC ED EF). 
	
	self assert: (vm localityDefUseRatioFor: 2) equals: (self percent: 3 / 6)
]

{ #category : 'tests' }
VocabularyMetricTest >> testDefinitionRatio [

	| vm |
	vm := VocabularyMetricer new.
	vm localDefinitions: #(A B C D E F).
	vm externalDefinitions: #(EA EB EC ED EF EG EH EI EJ EK).
	
	self assert: vm localityDefinitionRatio equals: (self percent: 6 / 16)
]

{ #category : 'tests' }
VocabularyMetricTest >> testPrinting [

	| vm |
	vm := VocabularyMetricer new.
	vm localDefinitions: #(A B C D E F).
	vm externalDefinitions: #(EA EB EC ED EF EG EH EI EJ EK).
	
	"here we have only A B C that are used"
	vm localUses: #(A B C).
	vm externalUses: #(EA EB EC ED EF). 
	
	self 
		assert: vm printString 
		equals: 
'locality definition ratio: 0.38 (6/16)
locality use ratio: 0.38 (3/8)
local def/use ratio: 0.5 (3/6)'
]

{ #category : 'tests' }
VocabularyMetricTest >> testUsesRatio [

	| vm |
	vm := VocabularyMetricer new.
	vm localDefinitions: #(A B C D E F).
	vm externalDefinitions: #(EA EB EC ED EF EG EH EI EJ EK).
	
	"here we have only A B C that are used"
	vm localUses: #(A B C).
	vm externalUses: #(EA EB EC ED EF). 
	
	"this measurre the ratio of local vs. global use"
	self assert: vm localityUseRatio equals: (self percent: 3 / 8).
	
]
