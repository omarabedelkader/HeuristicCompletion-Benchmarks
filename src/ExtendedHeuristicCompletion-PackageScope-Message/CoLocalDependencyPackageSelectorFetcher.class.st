Class {
	#name : 'CoLocalDependencyPackageSelectorFetcher',
	#superclass : 'CoPackageScopedSelectorFetcher',
	#instVars : [
		'dependencies'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'enumerating' }
CoLocalDependencyPackageSelectorFetcher >> entriesDo: aBlock [

	| dependentPackages dependentSelectors |
	completionClass isNil ifTrue: [ ^ self ].

	self packageLocalSelectors: aBlock.

	dependentSelectors := Set new.
	dependentPackages := self dependenciesOf: package name.

	dependentPackages do: [ :pkgName |
			self treatPackageNamed: pkgName  into: dependentSelectors ].

	dependentSelectors do: [ :sel |
			(filter accepts: sel) ifTrue: [
					aBlock value: ((NECGlobalEntry contents: sel node: nil)
							 fetcher: self;
							 yourself) ] ]
]
