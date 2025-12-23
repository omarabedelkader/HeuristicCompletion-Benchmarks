Class {
	#name : 'CooGlobalSorterResultSetBuilder',
	#superclass : 'CoGlobalSorterResultSetBuilder',
	#category : 'ExtendedHeuristicCompletion-Benchmarks',
	#package : 'ExtendedHeuristicCompletion-Benchmarks'
}

{ #category : 'API - building' }
CooGlobalSorterResultSetBuilder >> parseNode [

	| aNewNode |
	aNewNode := super parseNode.
	TypingVisitor new visitNode: aNewNode methodNode.
	^ aNewNode
]

{ #category : 'API - building' }
CooGlobalSorterResultSetBuilder >> sorterClass [

	^ sorterClass ifNil: [ completionContext class sorterClass ]
]

{ #category : 'API - building' }
CooGlobalSorterResultSetBuilder >> sorterClass: anObject [
	sorterClass := anObject
]

{ #category : 'visiting' }
CooGlobalSorterResultSetBuilder >> visitNode: aNode [

	| fetcher entries sorter |
	entries := aNode completionEntries: completionContext position.
	
		
	sorter := self sorterClass new context: completionContext.
	entries := sorter sortCompletionList: entries.

	fetcher := CoCollectionFetcher onCollection: entries.

	^ self configureFetcher: fetcher forNode: aNode
]
