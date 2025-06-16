Class {
	#name : 'CoLateralPackageGlobalVariableFetcher',
	#superclass : 'CoPackageScopedGlobalVariableFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Variables',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Variables'
}

{ #category : 'enumerating' }
CoLateralPackageGlobalVariableFetcher >> completionClass [ 

	^ completionClass
]

{ #category : 'enumerating' }
CoLateralPackageGlobalVariableFetcher >> completionClass: anObject [ 

	completionClass := anObject
]

{ #category : 'enumerating' }
CoLateralPackageGlobalVariableFetcher >> entriesDo: aBlock [
		| allGlobals excludedNames packageNamePart organizer excludedPackages |
		completionClass isNil ifTrue: [ ^ self fallbackEntriesDo: aBlock ].
	
		organizer := completionClass package organizer.

		"Identify current and repository packages to exclude"
		packageNamePart := completionClass package name copyUpTo: $-.
		excludedPackages := organizer packageNames select: [ :pkg |
				                    pkg = completionClass package name or: [ packageNamePart , '*' match: pkg ] ].

		"Gather all class names from excluded packages"
		excludedNames := excludedPackages flatCollect: [ :pkg |
				                 (organizer packageNamed: pkg ifAbsent: [ nil ])
					                 ifNotNil: [ :package | package definedClasses collect: [ :each | each name ] ]
					                 ifNil: [ #(  ) ] ].

		"Now get all global keys, subtract those excluded, and filter"
		allGlobals := systemNavigation environment keys asOrderedCollection.
		excludedNames do: [ :name | allGlobals remove: name ifAbsent: [ ] ].

		allGlobals do: [ :globalName |
				(filter accepts: globalName) ifTrue: [
					aBlock value: (NECGlobalEntry contents: globalName node: astNode) ] ] 
]

{ #category : 'enumerating' }
CoLateralPackageGlobalVariableFetcher >> fallbackEntriesDo: aBlock [ 

	^ self systemNavigation
		allGlobalNamesStartingWith: filter completionString
		do: [ :e | aBlock value: (NECGlobalEntry contents: e node: astNode) ]
		caseSensitive: filter isCaseSensitive
]
