Class {
	#name : 'ClassWithDependencyOnData2',
	#superclass : 'Object',
	#category : 'ExtendedHeuristicCompletion-Analyser-Data4',
	#package : 'ExtendedHeuristicCompletion-Analyser-Data4'
}

{ #category : 'methods for tests' }
ClassWithDependencyOnData2 >> defineADependencyToAnalyserData1 [

	^ AnalyserData1
]

{ #category : 'methods for tests' }
ClassWithDependencyOnData2 >> defineADependencyToDifferentAnalyserData1 [

	^ DifferentAnalyserData1
]
