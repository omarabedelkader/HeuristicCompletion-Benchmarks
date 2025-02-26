"
I am an Analyser, responsible for analyzing how classes are defined
 and referenced within a given package. My analysis identifies which
 classes are internal versus external, how many references exist, and
 provides relevant metrics.
"
Class {
	#name : 'BenchAnalyser',
	#superclass : 'Object',
	#instVars : [
		'package',
		'scope',
		'definedClassNames',
		'referencesByClass'
	],
	#category : 'HeuristicCompletion-Benchmarks-Analyser',
	#package : 'HeuristicCompletion-Benchmarks-Analyser'
}

{ #category : 'queries' }
BenchAnalyser >> allReferencedClasses [
    "Returns a collection of all classes referenced within the package,
    whether defined internally or externally."
    ^ referencesByClass keys
]

{ #category : 'initialization' }
BenchAnalyser >> collectClassDefinitions [ 

    "Collect all classes defined in the target package and store them in 'definedClassNames'."
    definedClassNames := Set newFrom: 
        (package definedClasses collect: [ :each | each name ])
]

{ #category : 'initialization' }
BenchAnalyser >> collectClassReferences [
    "Scan each method in the package scope to identify class references.
    We store them in 'referencesByClass'."

    scope methodsDo: [ :method |
        | parseTree |
        parseTree := method parseTree.

        parseTree nodesDo: [ :node |
            (self isClassReferenceNode: node)
                ifTrue: [ 
                    self noteReferenceIn: method forClass: node receiver name 
                ]
        ]
    ]
]

{ #category : 'queries' }
BenchAnalyser >> definedClassNames [

    "Returns the set of classes that are actually defined in the package."
    ^ definedClassNames
]

{ #category : 'metrics' }
BenchAnalyser >> externalClassReferences [

    "Returns the set of classes that are referenced but NOT defined in the package."
    ^ self allReferencedClasses difference: definedClassNames
]

{ #category : 'metrics' }
BenchAnalyser >> externalUserCount [ 

    "Count the number of distinct external classes used by this package."
    ^ self externalClassReferences size
]

{ #category : 'metrics' }
BenchAnalyser >> externalUserRatio [ 

    "Ratio of external classes (referenced but not defined) to the total referenced classes."
    ^ self allReferencedClasses isEmpty
        ifTrue: [ 0.0 ]
        ifFalse: [
            (self externalUserCount / self allReferencedClasses size) asFloat
        ]
]

{ #category : 'initialization' }
BenchAnalyser >> initialize [ 

    "Initialize default state. This method is called automatically upon creation."
    super initialize.
    definedClassNames := Set new.
    referencesByClass := Dictionary new
]

{ #category : 'queries' }
BenchAnalyser >> internalClassReferences [

    "Returns the set of classes that are both defined and referenced in this package."
    ^ definedClassNames intersection: self allReferencedClasses
]

{ #category : 'metrics' }
BenchAnalyser >> internalUserCount [ 

    "How many classes in the package are referenced internally by other classes
    of the same package?"
    ^ self internalClassReferences size
]

{ #category : 'metrics' }
BenchAnalyser >> internalUserRatio [
    "Ratio of classes in the package that are actually used internally vs. total classes defined."
    ^ definedClassNames isEmpty
        ifTrue: [ 0.0 ]
        ifFalse: [
            (self internalUserCount / definedClassNames size) asFloat
        ]
]

{ #category : 'private' }
BenchAnalyser >> isClassReferenceNode: aNode [ 

    "Determine if 'aNode' is a message node referencing a class name.
    We assume it if the receiver is a variable whose first letter is uppercase."
    ^ aNode isMessage
        and: [ aNode receiver isVariable
        and: [ aNode receiver name first isUppercase ] ]
]

{ #category : 'private' }
BenchAnalyser >> noteReferenceIn: aCompiledMethod forClass: aClassName [ 

    "Record that 'aClassName' was referenced by the given method."
    (referencesByClass
        at: aClassName
        ifAbsentPut: [ OrderedCollection new ])
            add: aCompiledMethod
]

{ #category : 'metrics' }
BenchAnalyser >> referencesByClassCount [ 

    "Answers a dictionary from className -> numberOfReferences (methods referencing it)."
    | countDict |
    countDict := Dictionary new.
    referencesByClass keysAndValuesDo: [ :className :methodCollection |
        countDict at: className put: methodCollection size
    ].
    ^ countDict
]

{ #category : 'queries' }
BenchAnalyser >> referencesForClass: aClassName [ 

    "Returns an OrderedCollection of methods that reference the specified class name,
    or an empty collection if none found."
    ^ referencesByClass
        at: aClassName
        ifAbsent: [ #() ]
]

{ #category : 'initialization' }
BenchAnalyser >> runAnalysisForPackage: aPackage [

    "Main entry point for performing the analysis on a given package."
    package := aPackage.
    scope := CoBenchmarkPackage on: aPackage.

    self collectClassDefinitions.
    self collectClassReferences.
    ^ self  "Return self for further queries or inspections."
]

{ #category : 'metrics' }
BenchAnalyser >> topReferencedClasses: topN [ 

    "Return the top N most-referenced classes (internal or external) as an OrderedCollection of 
    (className -> referenceCount) pairs, sorted by descending referenceCount."
    | sortedPairs |
    sortedPairs := self referencesByClassCount associations
        sort: [ :a :b | a value > b value ].  "Sort descending by count"
    ^ sortedPairs first: (topN min: sortedPairs size)
]

{ #category : 'metrics' }
BenchAnalyser >> unreferencedClasses [ 

    "Classes that are defined in the package but never referenced by any method in the package."
    ^ definedClassNames difference: self allReferencedClasses
]
