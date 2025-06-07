Class {
	#name : 'CooCompletionEngine',
	#superclass : 'CoCompletionEngine',
	#category : 'ExtendedHeuristicCompletion-Model',
	#package : 'ExtendedHeuristicCompletion-Model'
}

{ #category : 'initialization' }
CooCompletionEngine >> initialize [ 

    super initialize.
    completionBuilder := CooResultSetBuilder new.
]
