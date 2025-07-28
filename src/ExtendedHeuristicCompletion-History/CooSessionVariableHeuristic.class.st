Class {
	#name : 'CooSessionVariableHeuristic',
	#superclass : 'CoASTNodeFetcherHeuristic',
	#instVars : [
		'session'
	],
	#category : 'ExtendedHeuristicCompletion-History',
	#package : 'ExtendedHeuristicCompletion-History'
}

{ #category : 'requests' }
CooSessionVariableHeuristic >> appliesForNode: aNode inContext: aContext [ 

    "Be conservative: only when we are in a variable/global context.
     Many variable nodes are class refs (uppercase first)."
    ^ aNode isVariable or: [ aNode isGlobal ]
]

{ #category : 'requests' }
CooSessionVariableHeuristic >> buildFetcherFor: aNode inContext: aContext [ 

    | prefix entries |
	self halt.
    prefix := aContext completionToken ifNil: [ '' ].
    entries := self session globalEntriesForPrefix: prefix limit: 20 inContext: aContext.
    ^ CoCollectionFetcher onCollection: entries
]

{ #category : 'requests' }
CooSessionVariableHeuristic >> session [ 

    ^ session ifNil: [ session := CooSession current ]
]

{ #category : 'requests' }
CooSessionVariableHeuristic >> session: aSession [ 
	session := aSession
]
