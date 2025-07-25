"
I am a fetcher looking for globals in an environment.
"
Class {
	#name : 'CoRepositoryPackageScopedGlobalVariableFetcher',
	#superclass : 'CoAbstractPackageDependentScopeGlobalVariableFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope',
	#package : 'ExtendedHeuristicCompletion-PackageScope'
}

{ #category : 'enumerating' }
CoRepositoryPackageScopedGlobalVariableFetcher >> entriesDo: aBlock [

	|  packageNamePart friendClassNames friendPackageNames | 
	completionClass isNil ifTrue: [ ^ self ].
	
	self packageLocalClasses: aBlock.
	
	
	"Package of the project e.g that starts with the same tag bfore the - 
	ExtendedHeuristicCompletion-PackageScope -> HeuristicCompletion"
	packageNamePart := package name copyUpTo: $-.
	friendClassNames := OrderedCollection new. 
	friendPackageNames := organizer packageNames asOrderedCollection.
	friendPackageNames remove: package name "ifAbsent: [ nil ]".
	"It is improbable but let us make sure that we do not break is the organizer
	does not contain the package"
	
	friendPackageNames do: [ :packageName | 
			(packageNamePart, '*' match: packageName)
				ifTrue: [ friendClassNames addAll: ((organizer packageNamed: packageName ifAbsent: [ ]) 
					definedClasses collect: [ :each |each name ])]]. 
	
	friendClassNames do: [ :friend | 
		(filter accepts: friend) 
			ifTrue: [ aBlock value: (NECGlobalEntry contents: friend node: nil) ]].
]
