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
CoPackageScopedGlobalVariableFetcher >> packageLocalClasses: aBlock [

	| homePackageClassNames |
	homePackageClassNames := SortedCollection sortUsing: [ :a :b | a <= b ]. 
	
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
