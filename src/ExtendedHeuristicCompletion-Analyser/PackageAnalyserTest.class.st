Class {
	#name : 'PackageAnalyserTest',
	#superclass : 'TestCase',
	#category : 'ExtendedHeuristicCompletion-Analyser',
	#package : 'ExtendedHeuristicCompletion-Analyser'
}

{ #category : 'tests' }
PackageAnalyserTest >> testDefineClassesOfData [
	
	| pa |
	pa := PackageAnalyser new.
	pa runAnalysisForPackage: (PackageOrganizer default packageNamed: 'ExtendedHeuristicCompletion-Analyser-Data').
	self 
		assert: pa definedClassNames asOrderedCollection 
		equals: #(#AnalyserData1 #OtherAnalyserData1 #AnalyserData2 #AnalyserData3 #OtherAnalyserData2) asOrderedCollection 
]

{ #category : 'tests' }
PackageAnalyserTest >> testDefineClassesOfData2 [
	
	| pa |
	pa := PackageAnalyser new.
	pa runAnalysisForPackage: (PackageOrganizer default packageNamed: 'ExtendedHeuristicCompletion-Analyser-Data2').
	self 
		assert: pa definedClassNames asOrderedCollection
		equals: #(#DifferentAnalyserData1 #DifferentAnalyserData2 #OtherAnalyserData3) asOrderedCollection 
]
