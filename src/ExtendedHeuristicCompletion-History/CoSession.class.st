"
I implement a session that collects execution information.
I collect the last words in modified methods.
"
Class {
	#name : 'CoSession',
	#superclass : 'Object',
	#instVars : [
		'vocabularyCache'
	],
	#classVars : [
		'Current'
	],
	#category : 'ExtendedHeuristicCompletion-History',
	#package : 'ExtendedHeuristicCompletion-History'
}

{ #category : 'actions' }
CoSession class >> current [ 

	^ Current ifNil: [ Current := self new ]
]

{ #category : 'actions' }
CoSession class >> deinstall [
	<script>
	
	self environment codeChangeAnnouncer unsubscribe: self current.
	CoSession allInstances 
		do: [ :each | self environment codeChangeAnnouncer unsubscribe: each ]
]

{ #category : 'actions' }
CoSession class >> install [
	<script>
	
	self environment codeChangeAnnouncer
		when: MethodAdded
		send: #addNewMethodInVocabulary: 
		to: self current.
	"
	This does not work for now because we are expecting a node and the menu does not give us a node
	in addition we do not get the."
	"self environment codeChangeAnnouncer
		when: CompletionItemSelected
		send: #addMessageInVocabulary: 
		to: self current."
]

{ #category : 'actions' }
CoSession class >> reset [
	<script>
	Current ifNotNil: [ 
		self environment codeChangeAnnouncer
			unsubscribe: Current.
	Current := nil ]
]

{ #category : 'accessing' }
CoSession >> addMessageInVocabulary: anAnn [

	self addVocabulary: anAnn selectedItem selector  at: DateAndTime now
]

{ #category : 'vocabulary' }
CoSession >> addNewMethodInVocabulary: anAnn [
	
	self addVocabulary: (anAnn selector -> anAnn method ast) at: DateAndTime now 
]

{ #category : 'vocabulary' }
CoSession >> addVocabulary: aString at: aDateAndTime [

	vocabularyCache at: aString put: aDateAndTime
]

{ #category : 'initialization' }
CoSession >> initialize [

	super initialize.
	vocabularyCache := LRUCache new maximumWeight: 1000
]

{ #category : 'accessing' }
CoSession >> size [
	^ vocabularyCache size
]

{ #category : 'accessing' }
CoSession >> words [

	^ vocabularyCache keys
]
