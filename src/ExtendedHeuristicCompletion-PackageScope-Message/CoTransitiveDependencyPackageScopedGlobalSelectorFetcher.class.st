Class {
	#name : 'CoTransitiveDependencyPackageScopedGlobalSelectorFetcher',
	#superclass : 'CoPackageScopedGlobalSelectorFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'enumerating' }
CoTransitiveDependencyPackageScopedGlobalSelectorFetcher >> entriesDo: aBlock [ 

    | dependentPackages visited dependentSelectors |
    completionClass isNil ifTrue: [ ^ self ].

    self packageLocalSelectors: aBlock.

    dependentSelectors := OrderedCollection new.
    visited := Set with: package name.

    dependentPackages := OrderedCollection withAll: (StDependencyChecker new dependenciesOf: package name).

    [ dependentPackages isEmpty ] whileFalse: [
        | pkgName more pkg |
        pkgName := dependentPackages removeFirst.
        visited add: pkgName.
        more := (StDependencyChecker new dependenciesOf: pkgName) reject: [ :each | visited includes: each ].
        dependentPackages addAll: more.
        pkg := organizer packageNamed: pkgName ifAbsent: [ nil ].
        pkg ifNotNil: [
            pkg definedClasses do: [ :cls | cls selectors do: [ :sel | dependentSelectors add: sel ] ] ] ].

    dependentSelectors do: [ :sel |
        (filter accepts: sel) ifTrue: [
            aBlock value: ((NECGlobalEntry contents: sel node: nil)
                            fetcher: self;
                            yourself) ] ].
]
