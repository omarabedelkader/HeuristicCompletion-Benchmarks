Class {
	#name : 'CoFrameworkPrefixNormalizer',
	#superclass : 'CoNamePrefixNormalizer',
	#instVars : [
		'frameworkPrefixes'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Prefix',
	#package : 'ExtendedHeuristicCompletion-Benchmarks',
	#tag : 'Prefix'
}

{ #category : 'initialization' }
CoFrameworkPrefixNormalizer >> addPrefix: aString forFramework: aSymbol [ 

    frameworkPrefixes at: aSymbol put: aString.
    self prefixes add: aString
]

{ #category : 'initialization' }
CoFrameworkPrefixNormalizer >> denormalize: aName forFramework: aSymbol [ 

    ^ mapping at: aName ifAbsent: [
        | prefix |
        prefix := self prefixFor: aSymbol.
        prefix
            ifNil: [ aName ]
            ifNotNil: [ prefix , aName ]
    ]
]

{ #category : 'initialization' }
CoFrameworkPrefixNormalizer >> initialize [ 

    super initialize.
    frameworkPrefixes := Dictionary new
]

{ #category : 'initialization' }
CoFrameworkPrefixNormalizer >> normalize: aName forFramework: aSymbol [ 

    | prefix base |
    prefix := self prefixFor: aSymbol.
    prefix ifNil: [ ^ super normalize: aName ].
    (aName beginsWith: prefix)
        ifTrue: [
            base := aName copyFrom: prefix size + 1 to: aName size.
            mapping at: base put: aName.
            ^ base ].
    mapping at: aName put: aName.
    ^ aName
]

{ #category : 'initialization' }
CoFrameworkPrefixNormalizer >> prefixFor: aSymbol [ 

    ^ frameworkPrefixes at: aSymbol ifAbsent: [ nil ]
]
