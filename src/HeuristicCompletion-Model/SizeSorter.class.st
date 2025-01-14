"
no need to comment this functionality, it will be added to pharo soon
"
Class {
	#name : 'SizeSorter',
	#superclass : 'Object',
	#category : 'HeuristicCompletion-Model',
	#package : 'HeuristicCompletion-Model'
}

{ #category : 'sorting' }
SizeSorter >> sortCompletionList: anOrderedCollection [

	^ anOrderedCollection sort: [ :a :b | a contents size < b contents size ]
]
