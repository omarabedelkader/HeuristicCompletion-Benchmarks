Class {
	#name : 'AnalyserData1',
	#superclass : 'Object',
	#classVars : [
		'Ans'
	],
	#pools : [
		'AnalyserData1SharedPool'
	],
	#category : 'ExtendedHeuristicCompletion-Analyser-Data',
	#package : 'ExtendedHeuristicCompletion-Analyser-Data'
}

{ #category : 'accessing' }
AnalyserData1 >> accessingAnalyserData1SharedPool [

	^ AnalyserData1SharedPool
]

{ #category : 'accessing' }
AnalyserData1 >> foo [  

	^ AnalyserA 
]

{ #category : 'as yet unclassified' }
AnalyserData1 >> referToAnalyzer1 [

	^ AnalyserData1 foo
]

{ #category : 'as yet unclassified' }
AnalyserData1 >> sharedCaller [

	^ Ans foo
]

{ #category : 'as yet unclassified' }
AnalyserData1 >> sharedPoolCaller [

	^ Ansp1 foo
]
