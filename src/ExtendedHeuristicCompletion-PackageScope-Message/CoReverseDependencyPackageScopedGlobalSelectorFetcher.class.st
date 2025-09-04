Class {
	#name : 'CoReverseDependencyPackageScopedGlobalSelectorFetcher',
	#superclass : 'CoPackageScopedGlobalSelectorFetcher',
	#instVars : [
		'reverseDependencies'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'enumerating' }
CoReverseDependencyPackageScopedGlobalSelectorFetcher >> entriesDo: aBlock [ 

    | reversePackages reverseSelectors |
    completionClass isNil ifTrue: [ ^ self ].

    self packageLocalSelectors: aBlock.

    reversePackages := (PackageOrganizer default packages select: [ :pkg |
        | deps |
        deps := self dependenciesOf: pkg name.
        deps includes: package name ]) collect: [ :pkg | pkg name ].

    reverseSelectors := OrderedCollection new.
    reversePackages do: [ :pkgName |
        | pkg |
        pkg := organizer packageNamed: pkgName ifAbsent: [ nil ].
        pkg ifNotNil: [ pkg definedClasses do: [ :cls | cls selectors do: [ :sel | reverseSelectors add: sel ] ] ] ].

    reverseSelectors do: [ :sel |
        (filter accepts: sel) ifTrue: [
            aBlock value: ((NECGlobalEntry contents: sel node: nil)
                            fetcher: self;
                            yourself) ] ].
]
