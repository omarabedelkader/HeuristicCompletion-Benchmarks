"
Fetcher that takes into account the lateral dependencies
"
Class {
	#name : 'CoLateralPackageGlobalVariableFetcher',
	#superclass : 'CoPackageScopedGlobalVariableFetcher',
	#category : 'ExtendedHeuristicCompletion-Dependency',
	#package : 'ExtendedHeuristicCompletion-Dependency'
}

{ #category : 'enumerating' }
CoLateralPackageGlobalVariableFetcher >> entriesDo: aBlock [
		| allGlobals excludedNames packageNamePart excludedPackages |
		completionClass isNil ifTrue: [ ^ self ].

		"Identify current and repository packages to exclude"
		packageNamePart := package name copyUpTo: $-.
		excludedPackages := organizer packageNames select: [ :pkg |
				                    pkg = completionClass package name or: [ packageNamePart , '*' match: pkg ] ].

		"Gather all class names from excluded packages"
		excludedNames := excludedPackages flatCollect: [ :pkg |
				                 (organizer packageNamed: pkg ifAbsent: [ nil ])
					                 ifNotNil: [ :packag | packag definedClasses collect: [ :each | each name ] ]
					                 ifNil: [ #(  ) ] ].

		"Now get all global keys, subtract those excluded, and filter"
		allGlobals := systemNavigation environment keys asOrderedCollection.
		excludedNames do: [ :name | allGlobals remove: name ifAbsent: [ ] ].

		allGlobals do: [ :globalName |
				(filter accepts: globalName) ifTrue: [
					aBlock value: ((NECGlobalEntry contents: globalName node: astNode) fetcher: self ; yourself) ] ] 
]
