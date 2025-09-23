Class {
	#name : 'CoLocal2LevelDependencyPackageSelectorFetcher',
	#superclass : 'CoPackageScopedSelectorFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'enumerating' }
CoLocal2LevelDependencyPackageSelectorFetcher >> entriesDo: aBlock [ 

    | dependentPackages twoLevelPackages dependentSelectors |
    completionClass isNil ifTrue: [ ^ self ].

    self packageLocalSelectors: aBlock.

    dependentSelectors := Set new.
	dependentPackages := self dependenciesOf: package name.
	twoLevelPackages := dependentPackages asSet.
		
	dependentPackages do: [ :each |
		twoLevelPackages addAll: (self dependenciesOf: each) ].

	twoLevelPackages do: [ :pkgName |
			self treatPackageNamed: pkgName into: dependentSelectors ]. 

    dependentSelectors do: [ :sel |
        (filter accepts: sel) ifTrue: [
            aBlock value: ((NECGlobalEntry contents: sel node: nil)
                            fetcher: self;
                            yourself) ] ].
]
