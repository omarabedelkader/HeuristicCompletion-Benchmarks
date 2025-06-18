Class {
	#name : 'CoRepositoryPackageScopedGlobalMessageFetcher',
	#superclass : 'CoAbstractPackageDependentScopeGlobalVariableFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Message'
}

{ #category : 'enumerating' }
CoRepositoryPackageScopedGlobalMessageFetcher >> entriesDo: aBlock [

	| closeClassNames keys 
	  packageNamePart friendClassNames friendPackageNames |
	self flag: #todo. 
	"We should split this method and the one of the superclass to revise.
	
	"
	
	astNode ifNotNil: [ :node |
		node parent ifNotNil: [ :parent |
			(parent isMessage and: [ parent isKeyword ])
				ifTrue: [
					self systemNavigation
						allSelectorsStartingWith: parent selector , filter completionString
						do: [ :sel |
							aBlock value:
								(((NECSelectorEntry
									contents: (sel copyFrom: parent selector size + 1 to: sel size)
									node: astNode)
									selector: sel) fetcher: self ; yourself) ] ] ] ].

	closeClassNames := self packageLocalClasses: aBlock.
		
		
	packageNamePart := package name copyUpTo: $-.
	friendPackageNames := organizer packageNames asOrderedCollection.
	friendPackageNames remove:  package name.

	friendClassNames := OrderedCollection new.
	friendPackageNames do: [ :pkgName |
		(packageNamePart , '*' match: pkgName)
			ifTrue: [ friendClassNames addAll:
						((organizer packageNamed: pkgName ifAbsent: [ ])
							definedClasses collect: [ :each | each name ]) ] ].

	friendClassNames do: [ :className |
		(filter accepts: className)
			ifTrue: [ aBlock value: ((NECGlobalEntry contents: className node: nil)  fetcher: self ; yourself) ] ].

	keys := self systemNavigation environment keys asOrderedCollection.
	closeClassNames do: [ :n | keys remove: n ifAbsent: [ ] ].
	friendClassNames do: [ :n | keys remove: n ifAbsent: [ ] ].

	keys do: [ :globalName |
		(filter accepts: globalName)
			ifTrue: [ aBlock value:
						((NECGlobalEntry contents: globalName node: astNode) fetcher: self ; yourself) ] ].

]
