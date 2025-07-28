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
CooHistoryInstaller class >> current [

    <script>
    (CooSession current) inspect
]
