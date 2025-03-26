Class {
	#name : 'CooResultColumn',
	#superclass : 'Object',
	#instVars : [
		'title',
		'elements'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks',
	#package : 'ExtendedHeuristicCompletion-Benchmarks'
}

{ #category : 'accessing' }
CooResultColumn >> elements [

	^ elements
]

{ #category : 'accessing' }
CooResultColumn >> elements: anObject [

	elements := anObject
]

{ #category : 'printing' }
CooResultColumn >> printOn: aStream [
	aStream nextPutAll: title; nextPutAll: ' -- '.
	elements 
		do: [ :e | e printOn: aStream ]
		separatedBy: [ aStream space ]
]

{ #category : 'accessing' }
CooResultColumn >> title [

	^ title
]

{ #category : 'accessing' }
CooResultColumn >> title: anObject [

	title := anObject
]
