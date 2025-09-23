Class {
	#name : 'CooBenchResultTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'tests' }
CooBenchResultTest >> createResultNamed: aString values: anArray [

        | result |
        result := CooBenchResult new.
        result name: aString.

        (2 to: 8) withIndexDo: [ :prefix :index |
                | column |
                column := CooResultColumn new.
                column title: prefix asString.
                column addElement: (anArray at: index).
                result addColumn: column ].

        ^ result
]

{ #category : 'tests' }
CooBenchResultTest >> testComputeRatioBuildsResultUsingBaseline [
        | baseline other ratio |
        baseline := self
                        createResultNamed: 'Baseline'
                        values: #( 10 20 30 40 50 60 70 ).
        other := self
                        createResultNamed: 'Other'
                        values: #( 5 10 15 20 25 30 35 ).

        ratio := baseline computeRatioWithReceiverAsBaselineComparedTo: other.

        self assert: ratio name equals: 'Baseline/Other'.
        self assert: ratio columns size equals: 7.
        ratio columns
                do: [ :column |
                        self
                                assert: column elements size
                                equals: 1.
                        self
                                assert: column elements first
                                equals: 0.5 ]
]
