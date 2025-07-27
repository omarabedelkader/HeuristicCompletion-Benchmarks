Class {
	#name : 'CooHistoryInstaller',
	#superclass : 'Object',
	#classVars : [
		'Current'
	],
	#category : 'ExtendedHeuristicCompletion-History',
	#package : 'ExtendedHeuristicCompletion-History'
}

{ #category : 'actions' }
CooHistoryInstaller class >> install [ 

    <script>
    CooSession install.  "subscribe for method additions (your existing code)"
    CooSessionMessagesHeuristic installSessionInSystem.
    CooSessionVariableHeuristic installSessionInSystem.
]

{ #category : 'actions' }
CooHistoryInstaller class >> loadHistoryIfPresent [ 

    <script>
    CooSession current loadFromDefaultFile
]

{ #category : 'actions' }
CooHistoryInstaller class >> saveHistoryNow [ 

    <script>
    CooSession current saveToDefaultFile
]
