Class {
	#name : 'PackageAnalyserTest',
	#superclass : 'TestCase',
	#category : 'HeuristicCompletion-Benchmarks-Analyser',
	#package : 'HeuristicCompletion-Benchmarks-Analyser'
}

{ #category : 'tests' }
PackageAnalyserTest >> testDefineClassesOfData [
	
	| pa |
	pa := PackageAnalyser new.
	pa runAnalysisForPackage: (PackageOrganizer default packageNamed: 'HeuristicCompletion-Benchmarks-Analyser-Data').
	self 
		assert: pa definedClassNames asOrderedCollection 
		equals: #(#AnalyserData1 #AnalyserData2 #OtherAnalyserData1 #AnalyserData3 #OtherAnalyserData2) asOrderedCollection 
]

{ #category : 'tests' }
PackageAnalyserTest >> testDefineClassesOfData2 [
	
	| pa |
	pa := PackageAnalyser new.
	pa runAnalysisForPackage: (PackageOrganizer default packageNamed: 'HeuristicCompletion-Benchmarks-Analyser-Data2').
	self 
		assert: pa definedClassNames asOrderedCollection
		equals: #(#DifferentAnalyserData1 #DifferentAnalyserData2 #OtherAnalyserData3) asOrderedCollection 
]
