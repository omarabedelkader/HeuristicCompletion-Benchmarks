"
a simple interface for managing the running of the benchs, look to my subclasses to know more
"
Class {
	#name : 'CoBenchRunner',
	#superclass : 'Object',
	#instVars : [
		'package',
		'baseline',
		'others',
		'results'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks',
	#package : 'ExtendedHeuristicCompletion-Benchmarks'
}

{ #category : 'baselines' }
CoBenchRunner >> baseline: aSymbol [

	baseline := aSymbol
]

{ #category : 'accessing' }
CoBenchRunner >> computeRatio [

	^ (results at: baseline) accuracyResults
		  computeRatioWithReceiverAsBaselineComparedTo:
		  (results at: others first) accuracyResults
]

{ #category : 'accessing' }
CoBenchRunner >> others: aSymbolCollect [

	others := aSymbolCollect
]

{ #category : 'accessing' }
CoBenchRunner >> package [

	^ package
]

{ #category : 'accessing' }
CoBenchRunner >> package: aPackage [

	package := aPackage
]

{ #category : 'accessing' }
CoBenchRunner >> results [

	^ results
]

{ #category : 'accessing' }
CoBenchRunner >> run [

	results := Dictionary new.
	{ baseline } , others do: [ :s |
		results at: s put: (self perform: s) ]
]

{ #category : 'experience' }
CoBenchRunner >> withAdaptiveWeightedMetaFetcher [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CoBenchRunner >> withDependency [
	^ self subclassResponsibility
]

{ #category : 'experience' }
CoBenchRunner >> withGlobalSorterScope [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CoBenchRunner >> withLateralDependency [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CoBenchRunner >> withOllamaReRank [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CoBenchRunner >> withPackageScope [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CoBenchRunner >> withReverseDependency [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CoBenchRunner >> withTransitiveDependency [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CoBenchRunner >> withWeightedMetaFetcher [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CoBenchRunner >> withoutPackageScope [
	^ self subclassResponsibility
]
