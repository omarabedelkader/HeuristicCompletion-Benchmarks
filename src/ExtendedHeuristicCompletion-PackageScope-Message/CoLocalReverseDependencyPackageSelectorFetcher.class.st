Class {
	#name : 'CoLocalReverseDependencyPackageSelectorFetcher',
	#superclass : 'CoPackageScopedSelectorFetcher',
	#instVars : [
		'reverseDependencies'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'enumerating' }
CoLocalReverseDependencyPackageSelectorFetcher >> entriesDo: aBlock [ 

    | reversePackages reverseSelectors |
    completionClass isNil ifTrue: [ ^ self ].

    self packageLocalSelectors: aBlock.

    reversePackages := (PackageOrganizer default packages select: [ :pkg |
        | deps |
        deps := self dependenciesOf: pkg name.
        deps includes: package name ]) collect: [ :pkg | pkg name ].

    reverseSelectors := Set new.
    reversePackages do: [ :pkgName |
			self treatPackageNamed: pkgName into: reverseSelectors ].

    reverseSelectors do: [ :sel |
        (filter accepts: sel) ifTrue: [
            aBlock value: ((NECGlobalEntry contents: sel node: nil)
                            fetcher: self;
                            yourself) ] ].
]
