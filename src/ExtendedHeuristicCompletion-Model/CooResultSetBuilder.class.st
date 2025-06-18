Class {
	#name : 'CooResultSetBuilder',
	#superclass : 'CoASTHeuristicsResultSetBuilder',
	#category : 'ExtendedHeuristicCompletion-Model',
	#package : 'ExtendedHeuristicCompletion-Model'
}

{ #category : 'heuristics' }
CooResultSetBuilder >> messageHeuristic [ 

	^ messageHeuristic ifNil: [ messageHeuristic := self newHeuristicBuilder
		add: CoSuperMessageHeuristic new;
		add: CoTypedReceiverMessageHeuristic new;
		add: CoVariableWithTypeNameMessageHeuristic new;
		add: CoVariableValueMessageHeuristic new;
		add: CoUnknownMessageHeuristic new;
		build ]
]

{ #category : 'heuristics' }
CooResultSetBuilder >> variablesHeuristic [

	self halt.
	^ variablesHeuristic ifNil: [ variablesHeuristic := self newHeuristicBuilder
		add: CoLocalScopeVariablesHeuristic new;
		add: CoWorkspaceVariablesHeuristic new;
		add: CoInstanceAccessibleVariablesHeuristic new;
		add: (CoGlobalVariablesHeuristic new globalVariableFetcherClass:
					CoDependencyPackageScopedGlobalVariableFetcher);
		build ]
]
