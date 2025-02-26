Class {
	#name : 'CoStaticBenchmarksDiff',
	#superclass : 'Object',
	#instVars : [
		'benchA',
		'benchB',
		'tableDataA',
		'tableDataB',
		'tableDataDifference'
	],
	#category : 'HeuristicCompletion-Benchmarks',
	#package : 'HeuristicCompletion-Benchmarks'
}

{ #category : 'initialization' }
CoStaticBenchmarksDiff class >> initializeWith: benchA and: benchB [
    ^ self new
        benchA: benchA
        benchB: benchB
]

{ #category : 'as yet unclassified' }
CoStaticBenchmarksDiff >> accuracyInspectionResults [
	"Defines how this object is presented in the Inspector as a tab labeled 'Accuracy'."
	<inspectorPresentationOrder: 0 title: 'Difference'>
	^ self inspectionResults
]

{ #category : 'benchmarking' }
CoStaticBenchmarksDiff >> benchA: aBenchmark benchB: anotherBenchmark [

	benchA := aBenchmark.
	benchB := anotherBenchmark.
	^ self
]

{ #category : 'as yet unclassified' }
CoStaticBenchmarksDiff >> compute [
	"Compute the table data for benchA and benchB, then compute the difference."
	tableDataA := self computeTableDataFor: benchA.
	tableDataB := self computeTableDataFor: benchB.
	tableDataDifference := self
		computeDifferenceBetween: tableDataA
		and: tableDataB
]

{ #category : 'as yet unclassified' }
CoStaticBenchmarksDiff >> computeDifferenceBetween: tableA and: tableB [
	"Given two arrays of rows with the same structure,
	 compute the difference row by row, column by column."
	| rowCount |
	rowCount := tableA size.

	^ (1 to: rowCount) collect: [ :index |
		| label diffRowData |
		"Keep the prefix label from the first table."
		label := (tableA at: index) first.

		diffRowData := (tableA at: index) allButFirst withIndexCollect: 
			[ :stringValueA :colIndex |
				| valueA valueB difference |
				valueA := stringValueA asNumber ifNil: [ 0 ].
				valueB := ((tableB at: index) at: colIndex + 1) asNumber ifNil: [ 0 ].
				difference := valueA - valueB.
				difference printShowingDecimalPlaces: 2
			].

		{ label } , diffRowData
	]
]

{ #category : 'as yet unclassified' }
CoStaticBenchmarksDiff >> computeTableDataFor: aBenchmark [
	"Compute an array of rows for the given aBenchmark.
	 Each row looks like #(#('Prefix') 'val1' 'val2' ...). 
	 In this example, we assume aBenchmark has #completionIndexes and #prefixSizes,
	 and provides #accuracyForCompletionIndex:withPrefixSize:."

	| tableData completionIndexes prefixSizes |
	completionIndexes := aBenchmark completionIndexes.
	prefixSizes := aBenchmark prefixSizes.

	tableData := completionIndexes collect: [ :completionIndexRange |
		| label rowData |
		"Compute the label for the first column"
		label := '% '.
		label := label , (
			completionIndexRange size = 1
				ifTrue: [
					{ 'fail'. '1st'. '2nd'. '3rd' } 
						at: completionIndexRange first + 1
				]
				ifFalse: [
					completionIndexRange first asString , '-' , completionIndexRange last asString
				]
		).

		"Compute the accuracy columns"
		rowData := prefixSizes collect: [ :prefixSize |
			(aBenchmark accuracyForCompletionIndex: completionIndexRange withPrefixSize: prefixSize) 
				* 100
				printShowingDecimalPlaces: 2
		].

		{ label } , rowData
	].

	^ tableData
]

{ #category : 'as yet unclassified' }
CoStaticBenchmarksDiff >> inspectionResults [
	"Returns a dictionary that the Inspector can render as nested tabs:
	   - 'BenchmarkA'
	   - 'BenchmarkB'
	   - 'Difference'
	 Each key maps to an SpTablePresenter."
	
	"Ensure we have computed everything"
	self compute.

	^ {
		'BenchmarkA' -> (self tablePresenterFromTableData: tableDataA).
		'BenchmarkB' -> (self tablePresenterFromTableData: tableDataB).
		'Difference' -> (self tablePresenterFromTableData: tableDataDifference).
	}
]

{ #category : 'as yet unclassified' }
CoStaticBenchmarksDiff >> tablePresenterFromTableData: tableData [
	"Build and return an SpTablePresenter from an array of rows,
	 each of the form #(#('Prefix') 'val1' 'val2' ...)."
	| tablePresenter prefixColumnTitle prefixColumn rowCount colCount |

	rowCount := tableData size.
	colCount := tableData ifEmpty: [ 0 ] ifNotEmpty: [ tableData first size ].
	colCount := colCount max: 1. "Ensure at least 1 column"

	tablePresenter := SpTablePresenter new items: tableData.

	"First column is the label column"
	prefixColumnTitle := 'Prefix'.
	prefixColumn := SpStringTableColumn 
		title: prefixColumnTitle
		evaluated: [ :row | row first ].

	tablePresenter addColumn: prefixColumn.

	"Add the next columns for accuracy/diff values"
	1 to: (colCount - 1) do: [ :colIndex |
		| dynamicTitle |
		dynamicTitle := 'C', colIndex asString. "or any other naming scheme"
		tablePresenter addColumn: (
			SpStringTableColumn
				title: dynamicTitle
				evaluated: [ :row | row at: colIndex + 1 ]
		)
	].

	^ tablePresenter
]
