Class {
	#name : 'CoDependencyPackageScopedGlobalSelectorFetcher',
	#superclass : 'CoPackageScopedGlobalSelectorFetcher',
	#instVars : [
		'dependencies'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'enumerating' }
CoDependencyPackageScopedGlobalSelectorFetcher >> entriesDo: aBlock [ 

    | dependentPackages dependentSelectors |
    completionClass isNil ifTrue: [ ^ self ].

    self packageLocalSelectors: aBlock.

    dependentSelectors := OrderedCollection new.
    dependentPackages := self dependenciesOf: package name.

    dependentPackages do: [ :pkgName |
        | pkg |
        pkg := organizer packageNamed: pkgName ifAbsent: [ nil ].
        pkg ifNotNil: [
            pkg definedClasses do: [ :cls | cls selectors do: [ :sel | dependentSelectors add: sel ] ] ] ].

    dependentSelectors do: [ :sel |
        (filter accepts: sel) ifTrue: [
            aBlock value: ((NECGlobalEntry contents: sel node: nil)
                            fetcher: self;
                            yourself) ] ].
]
