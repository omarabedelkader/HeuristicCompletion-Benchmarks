Class {
	#name : 'CooDummyContext',
	#superclass : 'Object',
	#instVars : [
		'cls'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'accessing' }
CooDummyContext >> completionClass [ 
    ^ cls
]

{ #category : 'accessing' }
CooDummyContext >> completionClass: aClass [ 
    cls := aClass
]
