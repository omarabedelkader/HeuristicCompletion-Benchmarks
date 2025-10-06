"
I am a fetcher looking for globals in an environment.
"
Class {
	#name : 'CoRepositoryPackageScopedGlobalVariableFetcherPrefix',
	#superclass : 'CoAbstractPackageDependentScopeGlobalVariableFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Variable',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Variable'
}

{ #category : 'enumerating' }
CoRepositoryPackageScopedGlobalVariableFetcherPrefix >> entriesDo: aBlock [

	| packageNamePart friendClassNames friendPackageNames normalizer |
	completionClass isNil ifTrue: [ ^ self ].

	normalizer := CoNamePrefixNormalizer new.
	normalizer prefixes: { 'Sp' }.

	self packageLocalClasses: aBlock.


	"Package of the project e.g that starts with the same tag bfore the - 
	ExtendedHeuristicCompletion-PackageScope -> HeuristicCompletion"
	packageNamePart := package name copyUpTo: $-.
	friendClassNames := OrderedCollection new.
	friendPackageNames := organizer packageNames asOrderedCollection.
	friendPackageNames remove: package name. "ifAbsent: [ nil ]"
	"It is improbable but let us make sure that we do not break is the organizer
	does not contain the package"

	friendPackageNames do: [ :packageName |
			(packageNamePart , '*' match: packageName) ifTrue: [
					friendClassNames addAll:
						((organizer packageNamed: packageName ifAbsent: [ ])
							 definedClasses collect: [ :each | each name ]) ] ].

        friendClassNames do: [ :friend |
                | normalized |
                normalized := normalizer normalize: friend.
                (filter accepts: normalized)
                        ifTrue: [ aBlock value: ((NECGlobalEntry contents: (normalizer denormalize: normalized) node: nil)  fetcher: self ; yourself) ]].
]
