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
	engine completionBuilder: ( builder messageHeuristic: newElement ).  

	RubSmalltalkEditor completionEngineInstance: engine
]

{ #category : 'requests' }
CooSessionMessagesHeuristic >> appliesForNode: aNode inContext: aContext [

	^ aNode isMethod or: [ aNode isMessage ]
]

{ #category : 'requests' }
CooSessionMessagesHeuristic >> buildFetcherFor: aMessageNode inContext: aContext [
	
	^ CoCollectionFetcher onCollection: 
			( self session words collect: [ :each | (NECSelectorEntry contents: each key node: each value) ])
]

{ #category : 'accessing' }
CooSessionMessagesHeuristic >> session [
	^ session ifNil: [ session := CoSession current ]
]

{ #category : 'accessing' }
CooSessionMessagesHeuristic >> session: anObject [
	session := anObject
]
