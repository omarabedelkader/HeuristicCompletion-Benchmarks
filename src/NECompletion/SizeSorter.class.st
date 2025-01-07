"
no need to add any comment. tjhis functionnalty will be added to Pharo soon
"
Class {
	#name : 'SizeSorter',
	#superclass : 'CompletionSorter',
	#category : 'NECompletion-Sorting',
	#package : 'NECompletion',
	#tag : 'Sorting'
}

{ #category : 'sorting' }
SizeSorter >> sortCompletionList: anOrderedCollection [

	^ anOrderedCollection sort: [ :a :b | a contents size < b contents size ]
]
