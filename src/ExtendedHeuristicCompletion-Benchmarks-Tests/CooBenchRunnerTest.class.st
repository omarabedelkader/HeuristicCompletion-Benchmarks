Class {
	#name : 'CooBenchRunnerTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'tests' }
CooBenchRunnerTest >> accuracyResultNamed: aString values: anArray [

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
CooBenchRunnerTest >> sampleMmrString [
        ^ String streamContents: [ :stream |
                stream
                        nextPutAll: 'mmr: 0.9';
                        cr;
                        nextPutAll: '2 0.8';
                        cr;
                        nextPutAll: '3 0.7' ]
]

{ #category : 'tests' }
CooBenchRunnerTest >> setResultsOn: aRunner with: aDictionary [
        aRunner instVarNamed: #results put: aDictionary
]

{ #category : 'tests' }
CooBenchRunnerTest >> testComputeDeltaReturnsDifferenceBetweenBaselineAndOther [

        | runner baselineResult otherResult |
        runner := CooBenchRunner new.
        runner baseline: #baseline.
        runner others: { #other }.

        baselineResult := CooBenchRunnerTestBenchmarkStub new
                                mmr: 3;
                                yourself.
        otherResult := CooBenchRunnerTestBenchmarkStub new
                                mmr: 5;
                                yourself.

        self
                setResultsOn: runner
                with: (Dictionary newFrom:
                                { #baseline -> baselineResult.
                                #other -> otherResult }).

        self assert: runner computeDelta equals: 2
]

{ #category : 'tests' }
CooBenchRunnerTest >> testComputeRatioBuildsResultFromAccuracyTables [

        | runner baselineResult otherResult ratio |
        runner := CooBenchRunner new.
        runner baseline: #baseline.
        runner others: { #other }.

        baselineResult := CooBenchRunnerTestBenchmarkStub new
                                accuracyResults: (self accuracyResultNamed: 'Baseline' values: #( 50 40 30 20 10 5 1 ));
                                yourself.
        otherResult := CooBenchRunnerTestBenchmarkStub new
                                accuracyResults: (self accuracyResultNamed: 'Other' values: #( 25 20 15 10 5 2.5 0.5 ));
                                yourself.

        self
                setResultsOn: runner
                with: (Dictionary newFrom:
                                { #baseline -> baselineResult.
                                #other -> otherResult }).

        ratio := runner computeRatio.

        self assert: ratio name equals: 'Baseline/Other'.
        ratio columns
                do: [ :column |
                        self
                                assert: column elements first
                                equals: 0.5 ]
]
