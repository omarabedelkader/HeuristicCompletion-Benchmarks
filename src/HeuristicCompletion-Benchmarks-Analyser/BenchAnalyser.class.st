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

{ #category : 'initialization' }
BenchAnalyser >> allReferencedClasses [
	"Returns a collection of all classes referenced within the package, regardless of whether they are defined in the package."
	^ referencesByClass keys
]

{ #category : 'initialization' }
BenchAnalyser >> collectClassDefinitions [
    "Collect all classes defined in the target package."
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
				ifTrue: [ self noteReferenceIn: method forClass: node receiver name ]
		]
	]
]

{ #category : 'initialization' }
BenchAnalyser >> definedClassNames [
	"Returns the set of classes that are actually defined in the package."
	^ definedClassNames
]

{ #category : 'initialization' }
BenchAnalyser >> initialize [
	"Initialize default state. This method is called automatically upon creation."
	super initialize.
	definedClassNames := Set new.
	referencesByClass := Dictionary new
]

{ #category : 'initialization' }
BenchAnalyser >> internalClassReferences [
	"Returns the set of classes that are both defined and referenced within this package."
	^ definedClassNames intersection: self allReferencedClasses
]

{ #category : 'initialization' }
BenchAnalyser >> internalUserCount [
	"How many classes in the package are referenced internally by other classes of the same package?"
	^ self internalClassReferences size
]

{ #category : 'initialization' }
BenchAnalyser >> internalUserRatio [
	"Ratio of classes in the package that are actually used internally vs. total classes defined."
	^ definedClassNames isEmpty
		ifTrue: [ 0.0 ]
		ifFalse: [ (self internalUserCount / definedClassNames size) asFloat ]
]

{ #category : 'initialization' }
BenchAnalyser >> isClassReferenceNode: aNode [
	"Determine if 'aNode' is a message node referencing a class name.
	 We assume it if the receiver is a variable whose first letter is uppercase."
	^ aNode isMessage
		and: [ aNode receiver isVariable
		and: [ aNode receiver name first isUppercase ] ]
]

{ #category : 'initialization' }
BenchAnalyser >> noteReferenceIn: aCompiledMethod forClass: aClassName [
	"Record that 'aClassName' was referenced by the given method."
	(referencesByClass
		at: aClassName
		ifAbsentPut: [ OrderedCollection new ]) add: aCompiledMethod
]

{ #category : 'initialization' }
BenchAnalyser >> referencesForClass: aClassName [
	"Returns an OrderedCollection of methods that reference the specified class name, or an empty collection if none found."
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
	^ self  "Return self so we can do further queries or inspections."
]
