"
Look in the package and the other packages starting with the same prefix.
"
Class {
	#name : 'CoLocalLateralPackageSelectorFetcher',
	#superclass : 'CoPackageScopedSelectorFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'enumerating' }
CoLocalLateralPackageSelectorFetcher >> entriesDo: aBlock [

	| packageNamePart friendPackageNames friendSelectors |
	completionClass isNil ifTrue: [ ^ self ].

	self packageLocalSelectors: aBlock. "Extract base prefix of the current package"
	packageNamePart := package name copyUpTo: $-.
	friendPackageNames := organizer packageNames asOrderedCollection.
	friendPackageNames remove: package name ifAbsent: [ ].

	friendSelectors := Set new.
	friendPackageNames do: [ :eachPackageName |
			(packageNamePart , '*' match: eachPackageName) ifTrue: [
				self treatPackageNamed: eachPackageName into: friendSelectors ] ].

	friendSelectors do: [ :sel | (filter accepts: sel) ifTrue: [ aBlock value: (NECGlobalEntry contents: sel node: nil) ] ]
]
