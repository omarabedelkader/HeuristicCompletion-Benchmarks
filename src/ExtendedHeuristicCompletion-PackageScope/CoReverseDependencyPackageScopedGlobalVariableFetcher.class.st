"
I am a fetcher looking for globals in an environment.
"
Class {
	#name : 'CoReverseDependencyPackageScopedGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'packages',
		'completionClass',
		'reverseDependencies'
	],
	#classInstVars : [
		'dependencies',
		'reverseDependencies'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-PackageScope',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'PackageScope'
}

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher class >> computeReverseDependenciesOf: aPackageName [

	| allPackages |
	allPackages := PackageOrganizer default packages.
	^ (allPackages 
      select: [:pkg | (self dependenciesOf: pkg name) includes: aPackageName ])
    collect: [:pkg | pkg name]

]

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher class >> initialize [

	dependencies := Dictionary new.
	reverseDependencies := Dictionary new 
]

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher class >> reverseDependenciesOf: aPackageName [ 
    ^ reverseDependencies at: aPackageName ifAbsentPut: [ 
        self computeReverseDependenciesOf: aPackageName 
    ]
]

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> completionClass [

	^ completionClass
]

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> completionClass: anObject [

	completionClass := anObject
]

{ #category : 'enumerating' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> dependenciesOf: aString [

	^ self class dependenciesOf: aString
]

{ #category : 'enumerating' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> entriesDo: aBlock [
    | string case closeClassNames keys organizer dependentClassNames dependentPackages |
    completionClass isNil ifTrue: [
        ^ self systemNavigation
            allGlobalNamesStartingWith: filter completionString
            do: [ :e | aBlock value: (NECGlobalEntry contents: e node: astNode) ]
            caseSensitive: NECPreferences caseSensitive
    ].

    string := filter completionString.
    case := NECPreferences caseSensitive.
    organizer := completionClass package organizer.

    "First, include classes from the current package"
    closeClassNames := completionClass package definedClasses collect: [ :each | each name ].
    closeClassNames do: [ :closeClassName |
        (closeClassName beginsWith: string caseSensitive: case) ifTrue: [
            aBlock value: (NECGlobalEntry contents: closeClassName node: nil)
        ]
    ].

    "Then include dependent classes from reverse dependencies"
    dependentClassNames := OrderedCollection new.
    dependentPackages := self dependenciesOf: completionClass package name.
    dependentPackages do: [ :packageName |
        dependentClassNames addAll: 
            ((organizer packageNamed: packageName ifAbsent: [ nil ]) 
                ifNotNil: [ :pkg | pkg definedClasses collect: [ :each | each name ] ] 
                ifNil: [ #() ])
    ].

    dependentClassNames do: [ :closeClassName |
        (closeClassName beginsWith: string caseSensitive: case) ifTrue: [
            aBlock value: (NECGlobalEntry contents: closeClassName node: nil)
        ]
    ].

    "Avoid duplicates from systemNavigation environment"
    keys := self systemNavigation environment keys asOrderedCollection.
    closeClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].
    dependentClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].

    keys do: [ :globalName |
        (globalName beginsWith: string caseSensitive: case) ifTrue: [
            aBlock value: (NECGlobalEntry contents: globalName node: astNode)
        ]
    ].
]

{ #category : 'enumerating' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> packages: aCollection [

	packages := aCollection
]
