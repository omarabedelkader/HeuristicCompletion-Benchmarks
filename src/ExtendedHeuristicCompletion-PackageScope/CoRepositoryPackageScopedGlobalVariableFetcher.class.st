"
I am a fetcher looking for globals in an environment.
"
Class {
	#name : 'CoRepositoryPackageScopedGlobalVariableFetcher',
	#superclass : 'CoAbstractPackageDependentScopeGlobalVariableFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Variables',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Variables'
}

{ #category : 'enumerating' }
CoRepositoryPackageScopedGlobalVariableFetcher >> entriesDo: aBlock [

	| string case closeClassNames keys packageNamePart friendClassNames friendPackageNames | 
	completionClass isNil ifTrue: [ ^ self fallbackEntriesDo: aBlock ].
	
	self flag: #todo. "Code duplication!!!"
	"First package level "
	closeClassNames :=  package definedClasses collect: [ :each | each name ].
	closeClassNames do: [ :closeClassName | 
		(filter accepts: closeClassName) 
			ifTrue: [ aBlock value: ((NECGlobalEntry contents: closeClassName node: nil) fetcher: self ; yourself) ]] .
	
	"Package of the project e.g that starts with the same tag bfore the - 
	ExtendedHeuristicCompletion-PackageScope -> HeuristicCompletion"
	
	packageNamePart := package name copyUpTo: $-.
	friendClassNames := OrderedCollection new. 
	
	friendPackageNames := organizer packageNames asOrderedCollection.
	friendPackageNames remove: package name. 
	
	friendPackageNames do: [ :packageName | 
			(packageNamePart, '*' match: packageName)
				ifTrue: [ friendClassNames addAll: ((organizer packageNamed: packageName ifAbsent: [ ]) definedClasses collect: [ :each |each name ])]]. 
	
	friendClassNames do: [ :closeClassName | 
		(filter accepts: closeClassName) 
			ifTrue: [ aBlock value: (NECGlobalEntry contents: closeClassName node: nil) ]].
	
	
	"Global"
	"forced to copy the keys but let us try."
	
	keys := self systemNavigation environment keys asOrderedCollection.
	closeClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].
	friendClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].
	"we could not use remove: ifAbsent: but this would hide something. 
	Because I do not get why the navigation should not contain the same objects than before."
	
	"Same as above this is the not the job of the fetcher to filter.
	This is a pity because we cannot reuse the logic of systemNavigation because we should not 
	modify the global environment."
	keys do: [ :globalName | 
		(filter accepts: globalName) 
			ifTrue: [ aBlock value: ((NECGlobalEntry contents: globalName node: astNode) fetcher: self ; yourself) ]]
		
	
]
