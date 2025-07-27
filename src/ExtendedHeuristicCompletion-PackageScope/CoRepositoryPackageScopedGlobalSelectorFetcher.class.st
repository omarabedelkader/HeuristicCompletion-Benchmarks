Class {
	#name : 'CoRepositoryPackageScopedGlobalSelectorFetcher',
	#superclass : 'CoGlobalSelectorFetcher',
	#instVars : [
		'package',
		'completionClass',
		'organizer'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope',
	#package : 'ExtendedHeuristicCompletion-PackageScope'
}

{ #category : 'enumerating' }
CoRepositoryPackageScopedGlobalSelectorFetcher >> entriesDo: aBlock [
    | packageNamePart friendPackageNames friendSelectors |

    completionClass isNil ifTrue: [ ^ self ].

    "Extract base prefix of the current package"
    packageNamePart := package name copyUpTo: $-.

    friendPackageNames := organizer packageNames asOrderedCollection.
    friendPackageNames remove: package name ifAbsent: [ ].

    friendSelectors := Set new.

    friendPackageNames do: [ :eachPackageName |
        (packageNamePart, '*' match: eachPackageName)
            ifTrue: [
                | pkg classes |
                pkg := organizer packageNamed: eachPackageName ifAbsent: [ nil ].
                pkg ifNotNil: [
                    classes := pkg definedClasses.
                    classes do: [ :cls |
                        cls selectors do: [ :selector |
                            friendSelectors add: selector ]]]]].

    friendSelectors do: [ :sel |
        (filter accepts: sel) ifTrue: [
            aBlock value: (NECGlobalEntry contents: sel node: nil) ]].


]
