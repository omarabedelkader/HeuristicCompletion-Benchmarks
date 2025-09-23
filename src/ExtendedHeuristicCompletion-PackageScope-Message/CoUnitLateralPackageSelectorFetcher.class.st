"
Look only on lateral packages and not in the current one.
"
Class {
	#name : 'CoUnitLateralPackageSelectorFetcher',
	#superclass : 'CoPackageScopedSelectorFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'enumerating' }
CoUnitLateralPackageSelectorFetcher >> entriesDo: aBlock [

	| packageNamePart friendPackageNames friendSelectors |
	completionClass isNil ifTrue: [ ^ self ]. "No Local packages" "Extract base prefix of the current package"
	packageNamePart := package name copyUpTo: $-.
	friendPackageNames := organizer packageNames asOrderedCollection.
	friendPackageNames remove: package name ifAbsent: [ ].

	friendSelectors := Set new.
	friendPackageNames do: [ :eachPackageName |
			(packageNamePart , '*' match: eachPackageName) ifTrue: [
					self treatPackageNamed: eachPackageName into: friendSelectors ] ].

	friendSelectors do: [ :sel | (filter accepts: sel) ifTrue: [ aBlock value: (NECGlobalEntry contents: sel node: nil) ] ]
]
