"
### `OllamaAPI` Class
Handles interactions with a hypothetical Ollama API server.

- **`query:`**: Sends a query to the Ollama API and returns the response.
- **`initialize`**: Sets default values and initializes the API instance.
- **`list`**: Lists available models on the Ollama server.
- **`delete`**: Deletes a model from the Ollama server.
"
Class {
	#name : 'OllamaAPI',
	#superclass : 'Object',
	#instVars : [
		'model',
		'host',
		'port',
		'stream',
		'temperature',
		'num_predict',
		'top_k',
		'top_p',
		'format'
	],
	#classInstVars : [
		'defaultModel'
	],
	#category : 'ExtendedHeuristicCompletion-OllamaAPI',
	#package : 'ExtendedHeuristicCompletion-OllamaAPI'
}

{ #category : 'accessing' }
OllamaAPI class >> defaultModel [

	^ defaultModel ifNil: [ defaultModel := OCodeLlamaModel class >> #b7 ]
]

{ #category : 'accessing' }
OllamaAPI class >> defaultModel: anObject [

	defaultModel := anObject
]

{ #category : 'settings' }
OllamaAPI class >> ollamaSettings: aBuilder [

	<systemsettings>
	(aBuilder group: #ChatPharo)
		parent: #tools;
		with: [
			(aBuilder pickOne: #defaultModel)
				order: -100000;
				label: 'Ollama Default model';
				target: self;
				default: OCodeLlamaModel class >> #b7;
				domainValues:
					(((Pragma allNamed: #ollamaInit:) collect: [ :pragma |
							  pragma arguments first -> pragma method ]) sorted: [ :a :b |
							 a key < b key ]);
				ghostHelp: 'Model name' ]
]

{ #category : 'private' }
OllamaAPI >> addParameterTo: paramDic [

	| options |
	options := Dictionary new.
	paramDic at: #options put: options.
	self temperature ifNotNil: [ :var |
		options at: #temperature put: var asFloat ].
	self num_predict ifNotNil: [ :var |
		options at: #num_predict put: var ].
	self top_k ifNotNil: [ :var | options at: #top_k put: var ].
	self top_p ifNotNil: [ :var | options at: #top_p put: var ]
]

{ #category : 'private' }
OllamaAPI >> buildQuery: aTextQuery [

	^ aTextQuery
]

{ #category : 'api' }
OllamaAPI >> delete [
	"Pull the model linked to this API"

	| znClient paramDic |
	znClient := ZnEasy client.
	znClient forJsonREST.
	znClient host: self host.
	znClient port: self port.
	znClient path: 'api/delete'.
	paramDic := Dictionary new.
	paramDic at: #name put: self model fullName.
	znClient entity: (ZnEntity json: (NeoJSONWriter toString: paramDic)).
	^ znClient delete
]

{ #category : 'accessing' }
OllamaAPI >> format [

	^ format
]

{ #category : 'accessing' }
OllamaAPI >> format: anObject [

	format := anObject
]

{ #category : 'accessing' }
OllamaAPI >> formatJson [

	format := 'json'
]

{ #category : 'accessing' }
OllamaAPI >> host [

	^ host
]

{ #category : 'accessing' }
OllamaAPI >> host: anObject [

	host := anObject
]

{ #category : 'initialization' }
OllamaAPI >> initialize [

	super initialize.
	host := '127.0.0.1'.
	port := 11434.
	model := self class defaultModel
		         valueWithReceiver:
		         self class defaultModel methodClass instanceSide
		         arguments: {  }.
	stream := false
]

{ #category : 'api' }
OllamaAPI >> list [
	"Pull the model linked to this API"

	| znClient |
	znClient := ZnEasy client.
	znClient forJsonREST.
	znClient host: self host.
	znClient port: self port.
	znClient path: 'api/tags'.
	^ znClient get
]

{ #category : 'accessing' }
OllamaAPI >> model [

	^ model
]

{ #category : 'accessing' }
OllamaAPI >> model: anObject [

	model := anObject
]

{ #category : 'accessing' }
OllamaAPI >> num_predict [

	^ num_predict
]

{ #category : 'accessing' }
OllamaAPI >> num_predict: anObject [

	num_predict := anObject
]

{ #category : 'accessing' }
OllamaAPI >> port [

	^ port
]

{ #category : 'accessing' }
OllamaAPI >> port: anObject [

	port := anObject
]

{ #category : 'api' }
OllamaAPI >> pull [
	"Pull the model linked to this API"

	| znClient paramDic |
	znClient := ZnEasy client.
	znClient forJsonREST.
	znClient host: self host.
	znClient port: self port.
	znClient path: 'api/pull'.
	paramDic := Dictionary new.
	paramDic at: #name put: self model fullName.
	paramDic at: #stream put: false.
	znClient entity: (ZnEntity json: (NeoJSONWriter toString: paramDic)).
	^ znClient post at: #response
]

{ #category : 'api' }
OllamaAPI >> query: aTextQuery [

	| znClient paramDic writer |
	znClient := ZnClient new.
	writer := ZnUtils defaultJSONWriter.
	znClient
		accept: ZnMimeType applicationJson;
		contentWriter: [ :data | ZnEntity json: (writer toString: data) ].
	znClient host: self host.
	znClient port: self port.
	znClient path: 'api/generate'.
	paramDic := Dictionary new.
	paramDic at: #model put: self model fullName.
	paramDic at: #prompt put: (self buildQuery: aTextQuery).
	paramDic at: #stream put: self stream.
	self format ifNotNil: [ :f | paramDic at: #format put: f ].


	self addParameterTo: paramDic.
	znClient contents: paramDic.

	self stream
		ifTrue: [
			znClient streaming: true.
			^ znClient post ]
		ifFalse: [
			| reader | 
			znClient forJsonREST.
			reader := ZnUtils defaultJSONReader.
			znClient contentReader: [ :entity |
				reader fromString: entity contents ].
			^ znClient post at: #response ]
]

{ #category : 'accessing' }
OllamaAPI >> reRankCandidates: candidateEntries withContext: textSoFar [
    "Send a request to Ollama to reorder 'candidateEntries' (which are 
     NECEntry objects or similar). Return them in a new sorted order."

    | candidateStrings requestPayload response rankedStrings finalOrdered |

    "1. Convert the candidate entries into strings for the API."
    candidateStrings := candidateEntries collect: [ :entry | entry contents ].

    "2. Build a textual prompt or JSON that tells Ollama how to do the re-rank."
    requestPayload := self buildReRankPayloadWith: candidateStrings context: textSoFar.

    "3. Actually send requestPayload to Ollama. For example, we might do 
        3.1) paramDic at: #model put: 'some-lora-model'
        3.2) paramDic at: #prompt put: 'Rank the following strings...'
     Then parse the JSON result to get an array of strings in the new order."
    response := self sendReRankRequestToOllama: requestPayload.

    "4. Suppose the response includes an array of candidate strings in new rank order."
    rankedStrings := response at: #ranked ifAbsent: [ candidateStrings ].

    "5. Match them back to your original `candidateEntries`, so we can return 
       the same objects in that new order."
    finalOrdered := OrderedCollection new.
    rankedStrings do: [ :str |
        | matchingEntry |
        matchingEntry := candidateEntries detect: [ :entry | entry contents = str ] ifNone: [ nil ].
        matchingEntry ifNotNil: [ finalOrdered add: matchingEntry ] ].

    ^ finalOrdered
]

{ #category : 'private' }
OllamaAPI >> reRankWithPayload: aPayload [
   "Implement the logic you want here or integrate with the desired API."
   ^ self sendReRankRequestToOllama: aPayload
]

{ #category : 'api' }
OllamaAPI >> sendReRankRequestToOllama: aPayload [ 
    | znClient paramDic |
    znClient := ZnClient new.
    znClient
        accept: ZnMimeType applicationJson;
        contentWriter: [:data | ZnEntity json: (NeoJSONWriter toString: data)].
    znClient host: self host.
    znClient port: self port.
    znClient path: 'api/rerank'.

    "Now paramDic is your final request body."
    paramDic := Dictionary new.
    paramDic at: #model put: self model fullName.
    paramDic at: #prompt put: (aPayload isString ifTrue: aPayload ifFalse: (aPayload at: #prompt ifAbsent: ['?'])).
    paramDic at: #stream put: false.

    "Add more stuff if your Rerank endpoint requires it."
    self addParameterTo: paramDic.

    znClient contents: paramDic.
    znClient forJsonREST.
    ^ znClient post at: #response
]

{ #category : 'accessing' }
OllamaAPI >> stream [

	^ stream
]

{ #category : 'accessing' }
OllamaAPI >> stream: anObject [

	stream := anObject
]

{ #category : 'accessing' }
OllamaAPI >> temperature [

	^ temperature
]

{ #category : 'accessing' }
OllamaAPI >> temperature: anObject [

	temperature := anObject
]

{ #category : 'accessing' }
OllamaAPI >> top_k [

	^ top_k
]

{ #category : 'accessing' }
OllamaAPI >> top_k: anObject [

	top_k := anObject
]

{ #category : 'accessing' }
OllamaAPI >> top_p [

	^ top_p
]

{ #category : 'accessing' }
OllamaAPI >> top_p: anObject [

	top_p := anObject
]
