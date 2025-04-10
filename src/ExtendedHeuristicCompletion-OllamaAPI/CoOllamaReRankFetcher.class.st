Class {
	#name : 'CoOllamaReRankFetcher',
	#superclass : 'CoFetcherDecorator',
	#instVars : [
		'completionContext',
		'completionClass',
		'astNode'
	],
	#category : 'ExtendedHeuristicCompletion-OllamaAPI-Fetcher',
	#package : 'ExtendedHeuristicCompletion-OllamaAPI',
	#tag : 'Fetcher'
}

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> astNode: anASTNode [
    "Forward this to the wrapped fetcher (the decoree)."
    decoree astNode: anASTNode
]

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> buildReRankPayloadWith1: candidateStrings context: textSoFar [
   ^ '{ "context": "', textSoFar, '", "candidates": [', 
        (candidateStrings collect: [ :s | '"' , s , '"' ]) joinSeparatedBy: ',',
       '] }'
]

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> buildReRankPayloadWith: candidateStrings context: textSoFar [
    "Return the string/payload sent to Ollama, 
     containing the typed user context and the candidate completions."

    ^ String streamContents: [ :s |
        s nextPutAll: 'User typed: ', textSoFar; cr; cr.
        s nextPutAll: 'Candidates to rank:'; cr.

        candidateStrings do: [ :candidate |
            s tab; nextPutAll: candidate; cr ].

        s cr; nextPutAll: 'Please re-rank these candidates from best to worst.'
    ]
]

{ #category : 'accessing' }
CoOllamaReRankFetcher >> completionClass [

	^ completionClass
]

{ #category : 'accessing' }
CoOllamaReRankFetcher >> completionClass: anObject [

	completionClass := anObject
]

{ #category : 'accessing' }
CoOllamaReRankFetcher >> completionContext [

	^ completionContext
]

{ #category : 'accessing' }
CoOllamaReRankFetcher >> completionContext: anObject [

	completionContext := anObject
]

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> entriesDo: aBlock [
   "Decorate the underlying fetcher. Collect all of its candidate entries,
    pass them to Ollama, yield them in the new (re-ranked) order."
   | allResults reRanked |
   allResults := OrderedCollection new.
   decoree entriesDo: [ :entry | allResults add: entry ].
   reRanked := self ollamaReRank: allResults.
	reRanked do: [ :each | aBlock value: each ]

]

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> initialize [

   super initialize.
   decoree := CoRepositoryPackageScopedGlobalVariableFetcher new.
]

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> ollamaReRank: candidateEntries [
   | textUpToCaret candidateStrings payload api response newOrder |
   textUpToCaret := completionContext source
      copyFrom: 1
      to: completionContext position.

   "Convert each entry to the string to pass to Ollama."
   candidateStrings := candidateEntries collect: [ :entry | entry asString ].

   "build JSON for the Ollama API call."
   payload := self buildReRankPayloadWith: candidateStrings context: textUpToCaret.

   api := OllamaAPI new.
   response := api reRankWithPayload: payload.

   "Parse 'response' to figure out the new ordering of the candidates."
   newOrder := self parseReRankResponse: response 
                    forEntries: candidateEntries 
                    allStrings: candidateStrings.

   ^ newOrder
]

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> parseReRankResponse: response forEntries: candidateEntries allStrings: candidateStrings [
   "parsing the response to reorder candidateEntries. 
    This must return an OrderedCollection of the same entries in the new rank order."
   ^ self error: 'Not yet implemented.'
]
