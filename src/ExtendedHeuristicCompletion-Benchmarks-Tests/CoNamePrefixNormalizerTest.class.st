Class {
	#name : 'CoNamePrefixNormalizerTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'tests' }
CoNamePrefixNormalizerTest >> testNormalizeAndDenormalize [ 

        | norm |
        norm := CoNamePrefixNormalizer new.
        norm prefixes: { 'Sp' }.
        self assert: (norm normalize: 'SpButton') equals: 'Button'.
        self assert: (norm denormalize: 'Button') equals: 'SpButton'.
]
