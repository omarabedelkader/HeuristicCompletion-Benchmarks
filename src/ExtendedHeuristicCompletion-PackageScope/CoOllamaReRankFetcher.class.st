Class {
	#name : 'CoOllamaReRankFetcher',
	#superclass : 'CoFetcherDecorator',
	#instVars : [
		'completionContext'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-PackageScope',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'PackageScope'
}

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> buildReRankPayloadWith1: candidateStrings context: textSoFar [
   ^ '{ "context": "', textSoFar, '", "candidates": [', 
        (candidateStrings collect: [ :s | '"' , s , '"' ]) joinSeparatedBy: ',',
       '] }'
]

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> buildReRankPayloadWith: candidateStrings context: textSoFar [
    "Return the string/payload you want to send to Ollama, 
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
CoOllamaReRankFetcher >> completionClass: aClass [ 
	self shouldBeImplemented.
]

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> entriesDo: aBlock [
   "Decorate the underlying fetcher. Collect all of its candidate entries,
    pass them to Ollama, then yield them in the new (re-ranked) order."
   | allResults reRanked |
   allResults := OrderedCollection new.

   "Ask the wrapped fetcher (the decoree) for all results."
   decoree entriesDo: [ :entry | allResults add: entry ].

   "Now let Ollama reorder them."
   reRanked := self ollamaReRank: allResults.

   "Yield them in the new order."
   reRanked do: [ :each | aBlock value: each ]

]

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> initialize [
   "Whenever a new instance is created, let's set up the decoree to a default fetcher."
   super initialize.
   decoree := CoRepositoryPackageScopedGlobalVariableFetcher new.
]

{ #category : 'enumerating' }
CoOllamaReRankFetcher >> ollamaReRank: candidateEntries [
   | textUpToCaret candidateStrings payload api response newOrder |
   textUpToCaret := completionContext source
      copyFrom: 1
      to: completionContext position.

   "Convert each entry to the string form you want to pass to Ollama."
   candidateStrings := candidateEntries collect: [ :entry | entry asString ].

   "Now build some text or JSON for the Ollama API call."
   payload := self buildReRankPayloadWith: candidateStrings context: textUpToCaret.

   api := OllamaAPI new.
   response := api reRankWithPayload: payload.

   "Parse 'response' to figure out the new ordering of the candidates."
   newOrder := self parseReRankResponse: response 
                    forEntries: candidateEntries 
                    allStrings: candidateStrings.

   ^ newOrder
]
