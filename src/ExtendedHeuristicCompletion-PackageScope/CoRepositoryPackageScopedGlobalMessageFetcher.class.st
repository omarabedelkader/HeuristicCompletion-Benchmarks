Class {
	#name : 'CoRepositoryPackageScopedGlobalMessageFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'packages',
		'completionClass'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Message'
}

{ #category : 'accessing' }
CoRepositoryPackageScopedGlobalMessageFetcher >> completionClass [

	^ completionClass
]

{ #category : 'accessing' }
CoRepositoryPackageScopedGlobalMessageFetcher >> completionClass: anObject [

	completionClass := anObject
]

{ #category : 'enumerating' }
CoRepositoryPackageScopedGlobalMessageFetcher >> entriesDo: aBlock [

	| string case closeClassNames keys organizer
	  packageNamePart friendClassNames friendPackageNames |

	astNode ifNotNil: [ :node |
		node parent ifNotNil: [ :parent |
			(parent isMessage and: [ parent isKeyword ])
				ifTrue: [
					self systemNavigation
						allSelectorsStartingWith: parent selector , filter completionString
						do: [ :sel |
							aBlock value:
								((NECSelectorEntry
									contents: (sel copyFrom: parent selector size + 1 to: sel size)
									node: astNode)
									selector: sel) ] ] ] ].

	string := filter completionString.
	case := NECPreferences caseSensitive.
	organizer := completionClass package organizer.

	closeClassNames := completionClass package definedClasses
						collect: [ :each | each name ].
	closeClassNames do: [ :className |
		(className beginsWith: string caseSensitive: case)
			ifTrue: [ aBlock value:
						(NECGlobalEntry contents: className node: nil) ] ].
	packageNamePart := completionClass package name copyUpTo: $-.
	friendPackageNames := organizer packageNames asOrderedCollection.
	friendPackageNames remove: completionClass package name.

	friendClassNames := OrderedCollection new.
	friendPackageNames do: [ :pkgName |
		(packageNamePart , '*' match: pkgName)
			ifTrue: [ friendClassNames addAll:
						((organizer packageNamed: pkgName ifAbsent: [ ])
							definedClasses collect: [ :each | each name ]) ] ].

	friendClassNames do: [ :className |
		(className beginsWith: string caseSensitive: case)
			ifTrue: [ aBlock value:
						(NECGlobalEntry contents: className node: nil) ] ].

	keys := self systemNavigation environment keys asOrderedCollection.
	closeClassNames do: [ :n | keys remove: n ifAbsent: [ ] ].
	friendClassNames do: [ :n | keys remove: n ifAbsent: [ ] ].

	keys do: [ :globalName |
		(globalName beginsWith: string caseSensitive: case)
			ifTrue: [ aBlock value:
						(NECGlobalEntry contents: globalName node: astNode) ] ].

]

{ #category : 'accessing' }
CoRepositoryPackageScopedGlobalMessageFetcher >> packages [

	^ packages
]

{ #category : 'accessing' }
CoRepositoryPackageScopedGlobalMessageFetcher >> packages: anObject [

	packages := anObject
]
