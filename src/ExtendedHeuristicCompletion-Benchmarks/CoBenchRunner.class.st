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

{ #category : 'as yet unclassified' }
CoBenchRunner class >> iwst1 [
	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
CoBenchRunner class >> runVariableOnNeCompletionPackage [
	^ self subclassResponsibility
]

{ #category : 'api' }
CoBenchRunner >> allResultsFor: aColOfPackageNames [

	| packages runs string latex |
	packages := aColOfPackageNames collect: [ :p |
		            PackageOrganizer default packageNamed: p ].
	runs := self runComparisonForPackages: packages.
	string := self stringResultForABenchCollection: runs.
	latex := self latexTableResultForABenchCollection: runs.
	^ {
		  runs.
		  string.
		  latex }
]

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

{ #category : 'reporting' }
CoBenchRunner >> latexTableResultForABenchCollection: aCol [
    "Produce a LaTeX table showing the results from each benchmark in aCol."
    | header body mmrKeys footer rows |

    mmrKeys := OrderedCollection new.
    rows := OrderedCollection new.

    "First pass: collect all keys for MMR columns"
    aCol do: [ :bench |
		 bench results do: [ :result |
			| mmrs |
			mmrs := result mmrString splitOn: Character cr.
			mmrs := mmrs copyFrom: 2 to: mmrs size. 
			mmrKeys := mmrs collect: [ :r | (r splitOn: Character space) first ] 
		].
    ].

    "Second pass: build rows"
   body := String streamContents: [ :s |
		 aCol do: [ :bench |
        | packageName |
        packageName := bench package name.

        bench results keysAndValuesDo: [ :metric :result |
            | mmrs mmrValues globalMmr |

				mmrs := result mmrString splitOn: Character cr.
				mmrValues := mmrs copyFrom: 2 to: mmrs size. 
				mmrValues := mmrValues collect: [ :r | (r splitOn: Character space) second ].
				globalMmr := (mmrs first splitOn: Character space) second.

				s nextPutAll: packageName; nextPutAll: ' & '.
             s nextPutAll: metric asString; nextPutAll: ' & '.
             s nextPutAll: globalMmr asString; nextPutAll: ' & '.     
				s nextPutAll: (mmrValues joinUsing: ' & ').
				s nextPutAll: ' \\'.
				s cr
			
				
      		   ].
   		  ].
	 ]. 
    "Build header"
    header := String streamContents: [ :s |
        s nextPutAll: '\begin{tabular}{lll'.
        mmrKeys do: [ :k | s nextPutAll: 'l' ].
        s nextPutAll: '}'; cr.
        s nextPutAll: '\hline'; cr.
        s nextPutAll: 'Package & Metric & MMR'.
        mmrKeys do: [ :k | s nextPutAll: ' & ', k ].
        s nextPutAll: ' \\'; cr.
        s nextPutAll: '\hline'; cr.
    ].

    "Footer"
    footer := String streamContents: [ :s |
        s nextPutAll: '\hline'; cr.
        s nextPutAll: '\end{tabular}'; cr.
    ].

    ^ header, body, footer

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

{ #category : 'utilities' }
CoBenchRunner >> runComparisonForPackages: aCol [

	^ aCol collect: [ :pack |
			  self
				  package: pack;
				  baseline: #withoutPackageScope;
				  others: { #withPackageScope };
				  run ]
]

{ #category : 'utilities' }
CoBenchRunner >> stringResultForABenchCollection: aCol [

	^ String streamContents: [ :s |
		  aCol do: [ :p |
			  s << p package name.
			  s cr.
			  p results keysAndValuesDo: [ :k :v |
				 	s << k asString. 
					s cr.  
					s << v mmrString.
				  s cr ].
			  s cr ] ]
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
