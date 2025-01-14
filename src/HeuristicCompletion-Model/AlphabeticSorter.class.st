"
Aplhabetical sorting
"
Class {
	#name : 'AlphabeticSorter',
	#superclass : 'Object',
	#category : 'HeuristicCompletion-Model',
	#package : 'HeuristicCompletion-Model'
}

{ #category : 'description' }
AlphabeticSorter class >> kind [

	^ 'alphabetical'
]

{ #category : 'sorting' }
AlphabeticSorter >> sortCompletionList: anOrderedCollection [

	^ anOrderedCollection sort
]
