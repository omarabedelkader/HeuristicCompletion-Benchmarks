"
Reverse alphabetic sorting
"
Class {
	#name : 'ReverseAlphabeticSorter',
	#superclass : 'CompletionSorter',
	#category : 'HeuristicCompletion-Model',
	#package : 'HeuristicCompletion-Model'
}

{ #category : 'description' }
ReverseAlphabeticSorter class >> kind [

	^ 'reverse'
]

{ #category : 'sorting' }
ReverseAlphabeticSorter >> sortCompletionList: anOrderedCollection [
	"this is just for testing, reverse sort makes no sense in practice"
	^ anOrderedCollection sort reverse
]
