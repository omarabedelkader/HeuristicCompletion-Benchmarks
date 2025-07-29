Class {
	#name : 'CoFrameworkPrefixNormalizerTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Prefix',
	#package : 'ExtendedHeuristicCompletion-Benchmarks',
	#tag : 'Prefix'
}

{ #category : 'tests' }
CoFrameworkPrefixNormalizerTest >> testNormalizeForFramework [ 

    | norm |
    norm := CoFrameworkPrefixNormalizer new.
    norm addPrefix: 'Sp' forFramework: #Spec.
    norm addPrefix: 'RS' forFramework: #Roassal.

    self assert: (norm normalize: 'SpButton' forFramework: #Spec) equals: 'Button'.
    self assert: (norm denormalize: 'Button' forFramework: #Spec) equals: 'SpButton'.
    self assert: (norm normalize: 'RSShape' forFramework: #Roassal) equals: 'Shape'.
    self assert: (norm denormalize: 'Shape' forFramework: #Roassal) equals: 'RSShape'.
]
