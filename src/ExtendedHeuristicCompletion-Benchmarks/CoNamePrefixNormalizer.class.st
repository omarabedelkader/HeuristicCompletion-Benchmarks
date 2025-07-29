Class {
	#name : 'CoNamePrefixNormalizer',
	#superclass : 'Object',
	#instVars : [
		'prefixes',
		'mapping'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Prefix',
	#package : 'ExtendedHeuristicCompletion-Benchmarks',
	#tag : 'Prefix'
}

{ #category : 'initialization' }
CoNamePrefixNormalizer >> denormalize: aName [ 

        ^ mapping at: aName ifAbsent: [ aName ]
]

{ #category : 'initialization' }
CoNamePrefixNormalizer >> initialize [ 

        super initialize.
        prefixes := OrderedCollection new.
        mapping := Dictionary new
]

{ #category : 'initialization' }
CoNamePrefixNormalizer >> normalize: aName [ 

        prefixes do: [ :prefix |
                (aName beginsWith: prefix)
                        ifTrue: [
                                | base |
                                base := aName copyFrom: prefix size + 1 to: aName size.
                                mapping at: base put: aName.
                                ^ base ] ].
        mapping at: aName put: aName.
        ^ aName
]

{ #category : 'initialization' }
CoNamePrefixNormalizer >> prefixes [ 


        ^ prefixes
]

{ #category : 'initialization' }
CoNamePrefixNormalizer >> prefixes: aCollection [ 

        prefixes := aCollection asOrderedCollection
]
