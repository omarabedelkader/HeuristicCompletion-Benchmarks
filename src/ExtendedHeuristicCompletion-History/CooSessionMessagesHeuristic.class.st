"
I am an heuristic that autocompletes messages based on a session vocabulary.
"
Class {
	#name : 'CooSessionMessagesHeuristic',
	#superclass : 'CoASTNodeFetcherHeuristic',
	#instVars : [
		'session'
	],
	#category : 'ExtendedHeuristicCompletion-History',
	#package : 'ExtendedHeuristicCompletion-History'
}

{ #category : 'requests' }
CooSessionMessagesHeuristic class >> installSessionInSystem [
	<script>
	"self installSessionInSystem"
	
	| engine builder heuBuilder  newElement |
	engine := CoCompletionEngine new.
	
	builder := CoASTHeuristicsResultSetBuilder new. 
	heuBuilder := CoHeuristicBuilder new. 
	newElement := heuBuilder add: CooSessionMessagesHeuristic new; build.
	newElement next: builder messageHeuristic.
	"we place the session in front of the Semantics approach."
	
	"then we set a chain of builder for the message part."
	engine completionBuilder: ( builder messageHeuristic: newElement ).  
	
	RubSmalltalkEditor completionEngineInstance: engine
]

{ #category : 'requests' }
CooSessionMessagesHeuristic >> appliesForNode: aNode inContext: aContext [

	^ aNode isMethod or: [ aNode isMessage ]
]

{ #category : 'requests' }
CooSessionMessagesHeuristic >> buildFetcherFor: aMessageNode inContext: aContext [ 

    | prefix entries |
    prefix := aContext completionToken ifNil: [ '' ].
    entries := self session messageEntriesForPrefix: prefix limit: 20 inContext: aContext.
    ^ CoCollectionFetcher onCollection: entries
]

{ #category : 'accessing' }
CooSessionMessagesHeuristic >> session [
	^ session ifNil: [ session := CoSession current ]
]

{ #category : 'accessing' }
CooSessionMessagesHeuristic >> session: anObject [
	session := anObject
]
