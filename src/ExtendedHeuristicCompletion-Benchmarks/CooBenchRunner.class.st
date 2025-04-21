"
a simple interface for managing the running of the benchs, look to my subclasses to know more
"
Class {
	#name : 'CooBenchRunner',
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
CooBenchRunner >> baseline: aSymbol [

	baseline := aSymbol
]

{ #category : 'accessing' }
CooBenchRunner >> computeRatio [

	^ (results at: baseline) accuracyResults
		  computeRatioWithReceiverAsBaselineComparedTo:
		  (results at: others first) accuracyResults
]

{ #category : 'accessing' }
CooBenchRunner >> others: aSymbolCollect [

	others := aSymbolCollect
]

{ #category : 'accessing' }
CooBenchRunner >> package [

	^ package
]

{ #category : 'accessing' }
CooBenchRunner >> package: aPackage [

	package := aPackage
]

{ #category : 'accessing' }
CooBenchRunner >> results [

	^ results
]

{ #category : 'accessing' }
CooBenchRunner >> run [

	results := Dictionary new.
	{ baseline } , others do: [ :s |
		results at: s put: (self perform: s) ]
]

{ #category : 'experience' }
CooBenchRunner >> withAdaptiveWeightedMetaFetcher [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CooBenchRunner >> withDependency [
	^ self subclassResponsibility
]

{ #category : 'experience' }
CooBenchRunner >> withGlobalSorterScope [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CooBenchRunner >> withLateralDependency [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CooBenchRunner >> withOllamaReRank [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CooBenchRunner >> withPackageScope [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CooBenchRunner >> withReverseDependency [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CooBenchRunner >> withTransitiveDependency [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CooBenchRunner >> withWeightedMetaFetcher [

	^ self subclassResponsibility
]

{ #category : 'experience' }
CooBenchRunner >> withoutPackageScope [
	^ self subclassResponsibility
]
