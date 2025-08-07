Class {
	#name : 'CoLateralPackageGlobalSelectorFetcher',
	#superclass : 'CoPackageScopedGlobalSelectorFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'enumerating' }
CoLateralPackageGlobalSelectorFetcher >> entriesDo: aBlock [ 

    | packageNamePart excludedPackages excludedSelectors allSelectors |
    completionClass isNil ifTrue: [ ^ self ].

    packageNamePart := package name copyUpTo: $-.
    excludedPackages := organizer packageNames select: [ :pkg |
        pkg = package name or: [ packageNamePart , '*' match: pkg ] ].

    excludedSelectors := OrderedCollection new.
    excludedPackages do: [ :pkgName |
        | pkg |
        pkg := organizer packageNamed: pkgName ifAbsent: [ nil ].
        pkg ifNotNil: [ pkg definedClasses do: [ :cls | excludedSelectors addAll: cls selectors ] ] ].

    allSelectors := systemNavigation allSelectors asOrderedCollection.
    excludedSelectors do: [ :sel | allSelectors remove: sel ifAbsent: [ ] ].

    allSelectors do: [ :sel |
        (filter accepts: sel) ifTrue: [
            aBlock value: ((NECGlobalEntry contents: sel node: nil)
                            fetcher: self;
                            yourself) ] ].
]
