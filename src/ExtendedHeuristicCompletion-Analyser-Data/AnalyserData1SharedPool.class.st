Class {
	#name : 'AnalyserData1SharedPool',
	#superclass : 'SharedPool',
	#classVars : [
		'Ansp1',
		'Ansp2'
	],
	#category : 'ExtendedHeuristicCompletion-Analyser-Data',
	#package : 'ExtendedHeuristicCompletion-Analyser-Data'
}

{ #category : 'accessing' }
AnalyserData1SharedPool >> accessingSharedVariable2 [ 
	
	^ Ansp1 + Ansp2 
]
