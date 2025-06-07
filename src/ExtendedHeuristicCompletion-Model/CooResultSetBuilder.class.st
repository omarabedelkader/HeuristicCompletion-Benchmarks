Class {
	#name : 'CooResultSetBuilder',
	#superclass : 'CoASTHeuristicsResultSetBuilder',
	#category : 'ExtendedHeuristicCompletion-Model',
	#package : 'ExtendedHeuristicCompletion-Model'
}

{ #category : 'heuristics' }
CooResultSetBuilder >> messageHeuristic [ 

    ^ self newHeuristicBuilder
            add: CoSuperMessageHeuristic new;             "changed order"
            add: CoSelfMessageHeuristic new;
            add: CoTypedReceiverMessageHeuristic new;
            add: CoInitializeInferencedMessageHeuristic new;
            add: CoLiteralMessageHeuristic new;
            add: CoGlobalVariableMessageHeuristic new;
            add: CoVariableWithTypeNameMessageHeuristic new;
            add: CoVariableValueMessageHeuristic new;
            add: CoUnknownMessageHeuristic new;
            build
]
