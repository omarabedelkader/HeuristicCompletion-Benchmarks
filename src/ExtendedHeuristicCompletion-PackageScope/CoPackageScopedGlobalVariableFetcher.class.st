"
I'm a fetcher knowing package.
"
Class {
	#name : 'CoPackageScopedGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'package',
		'completionClass',
		'organizer'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-CandidatesForPharoInclusion',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'CandidatesForPharoInclusion'
}

{ #category : 'accessing' }
CoPackageScopedGlobalVariableFetcher >> completionClass [

	^ completionClass
]

{ #category : 'accessing' }
CoPackageScopedGlobalVariableFetcher >> completionClass: anObject [

	completionClass := anObject.
	completionClass ifNotNil: [ 
		package := completionClass package.
		organizer := package organizer ]
]

{ #category : 'enumerating' }
CoPackageScopedGlobalVariableFetcher >> fallbackEntriesDo: aBlock [ 

	^ self systemNavigation
		allGlobalNamesStartingWith: filter completionString
		do: [ :e | aBlock value: ((NECGlobalEntry contents: e node: astNode) fetcher: self ; yourself) ]
		caseSensitive: filter isCaseSensitive 
]

{ #category : 'enumerating' }
CoPackageScopedGlobalVariableFetcher >> packageLocalClasses: aBlock [

	| homePackageClassNames |
	homePackageClassNames := SortedCollection sortUsing: [ :a :b |
		                         a <= b ]. "First package level. This could be a separate fetcher to produce more composible code"
	package definedClasses do: [ :cls |
		homePackageClassNames add: cls name ].
	homePackageClassNames do: [ :closeClassName |
			(filter accepts: closeClassName) ifTrue: [
					aBlock value:
						((NECGlobalEntry contents: closeClassName node: nil)
							 fetcher: self;
							 yourself) ] ].
	^ homePackageClassNames
]
