"
Aplhabetical sorting
"
Class {
	#name : 'AlphabeticSorter',
	#superclass : 'CompletionSorter',
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
