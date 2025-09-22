"
Fetcher that takes into account the lateral dependencies
"
Class {
	#name : 'CoLateralPackageGlobalVariableFetcherPrefix',
	#superclass : 'CoPackageScopedGlobalVariableFetcher',
	#category : 'ExtendedHeuristicCompletion-Prefixes',
	#package : 'ExtendedHeuristicCompletion-Prefixes'
}

{ #category : 'enumerating' }
CoLateralPackageGlobalVariableFetcherPrefix >> entriesDo: aBlock [

	| allGlobals excludedNames packageNamePart excludedPackages normalizer |
	completionClass isNil ifTrue: [ ^ self ].

	normalizer := CoNamePrefixNormalizer new.
	normalizer prefixes: { 'Sp' }.

	"Identify current and repository packages to exclude"
	packageNamePart := package name copyUpTo: $-.
	excludedPackages := organizer packageNames select: [ :pkg |
			                    pkg = completionClass package name or: [
				                    packageNamePart , '*' match: pkg ] ].

	"Gather all class names from excluded packages"
	excludedNames := excludedPackages flatCollect: [ :pkg |
			                 (organizer packageNamed: pkg ifAbsent: [ nil ])
				                 ifNotNil: [ :packag |
				                 packag definedClasses collect: [ :each |
					                 each name ] ]
				                 ifNil: [ #(  ) ] ].

	"Now get all global keys, subtract those excluded, and filter"
	allGlobals := systemNavigation environment keys asOrderedCollection.
	excludedNames do: [ :name | allGlobals remove: name ifAbsent: [ ] ].

allGlobals do: [ :globalName |
                                | normalized |
                                normalized := normalizer normalize: globalName.
                                (filter accepts: normalized) ifTrue: [
                                        aBlock value: ((NECGlobalEntry contents: (normalizer denormalize: normalized) node: astNode) fetcher: self ; yourself) ] ]
]
