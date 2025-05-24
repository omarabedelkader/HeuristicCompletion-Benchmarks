Class {
	#name : 'CoLateralPackageGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'completionClass'
	],
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
		| string case allGlobals excludedNames packageNamePart organizer excludedPackages |
		completionClass isNil ifTrue: [ ^ self fallbackEntriesDo: aBlock ].

		string := filter completionString.
		case := NECPreferences caseSensitive.
		organizer := completionClass package organizer.

		"Identify current and repository packages to exclude"
		packageNamePart := completionClass package name copyUpTo: $-.
		excludedPackages := organizer packageNames select: [ :pkg |
				                    pkg = completionClass package name or: [
					                    packageNamePart , '*' match: pkg ] ].

		"Gather all class names from excluded packages"
		excludedNames := excludedPackages flatCollect: [ :pkg |
				                 (organizer packageNamed: pkg ifAbsent: [ nil ])
					                 ifNotNil: [ :package |
					                 package definedClasses collect: [ :each |
						                 each name ] ]
					                 ifNil: [ #(  ) ] ].

		"Now get all global keys, subtract those excluded, and filter"
		allGlobals := self systemNavigation environment keys
			              asOrderedCollection.
		excludedNames do: [ :name | allGlobals remove: name ifAbsent: [ ] ].

		allGlobals do: [ :globalName |
				(globalName beginsWith: string caseSensitive: case) ifTrue: [
					aBlock value: (NECGlobalEntry contents: globalName node: astNode) ] ] 
]

{ #category : 'enumerating' }
CoLateralPackageGlobalVariableFetcher >> fallbackEntriesDo: aBlock [ 

	^ self systemNavigation
		allGlobalNamesStartingWith: filter completionString
		do: [ :e | aBlock value: (NECGlobalEntry contents: e node: astNode) ]
		caseSensitive: NECPreferences caseSensitive
]
