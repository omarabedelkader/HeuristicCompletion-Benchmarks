"
I am a fetcher looking for globals in an environment.
"
Class {
	#name : 'CoDependencyPackageScopedGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'packages',
		'completionClass'
	],
	#classInstVars : [
		'dependencies'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-PackageScope',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'PackageScope'
}

{ #category : 'accessing' }
CoDependencyPackageScopedGlobalVariableFetcher class >> computeDependenciesOf: aPackageName [
	
	Transcript show: '.';cr. 
	^ StDependencyChecker new computeImageDependencies dependenciesOf:
		  aPackageName
]

{ #category : 'accessing' }
CoDependencyPackageScopedGlobalVariableFetcher class >> dependenciesOf: aPackageName [

	^ dependencies at: aPackageName ifAbsentPut: [ self computeDependenciesOf: aPackageName ]
]

{ #category : 'accessing' }
CoDependencyPackageScopedGlobalVariableFetcher class >> initialize [ 
	
	dependencies := Dictionary new
]

{ #category : 'accessing' }
CoDependencyPackageScopedGlobalVariableFetcher >> completionClass [

	^ completionClass
]

{ #category : 'accessing' }
CoDependencyPackageScopedGlobalVariableFetcher >> completionClass: anObject [

	completionClass := anObject
]

{ #category : 'enumerating' }
CoDependencyPackageScopedGlobalVariableFetcher >> dependenciesOf: aString [

	^ self class dependenciesOf: aString
]

{ #category : 'enumerating' }
CoDependencyPackageScopedGlobalVariableFetcher >> entriesDo: aBlock [

	| string case closeClassNames keys organizer dependentClassNames dependentPackages |
	completionClass isNil ifTrue: [ "can we call another fetcher?"
		^ self systemNavigation
			  allGlobalNamesStartingWith: filter completionString
			  do: [ :e |
			  aBlock value: (NECGlobalEntry contents: e node: astNode) ]
			  caseSensitive: NECPreferences caseSensitive ].

	string := filter completionString.
	case := NECPreferences caseSensitive.
	organizer := completionClass package organizer.

	"First package level "
	closeClassNames := completionClass package definedClasses collect: [
		                   :each | each name ].
	closeClassNames do: [ :closeClassName |
		(closeClassName beginsWith: string caseSensitive: case) ifTrue: [
			aBlock value: (NECGlobalEntry contents: closeClassName node: nil) ] ].

	"Package of the project e.g that starts with the same tag bfore the - 
	ExtendedHeuristicCompletion-PackageScope -> HeuristicCompletion"

	dependentClassNames := OrderedCollection new.
	dependentPackages := self dependenciesOf: completionClass package name. 

	dependentPackages do: [ :packageName |
		dependentClassNames addAll:
			((organizer packageNamed: packageName ifAbsent: [  ])
				 definedClasses collect: [ :each | each name ]) ].

	dependentClassNames do: [ :closeClassName |
		(closeClassName beginsWith: string caseSensitive: case) ifTrue: [
			aBlock value: (NECGlobalEntry contents: closeClassName node: nil) ] ].

	keys := self systemNavigation environment keys asOrderedCollection.
	closeClassNames do: [ :e | keys remove: e ifAbsent: [  ] ].
	dependentClassNames do: [ :e | keys remove: e ifAbsent: [  ] ].
	"we could not use remove: ifAbsent: but this would hide something. 
	Because I do not get why the navigation should not contain the same objects than before."

	"Same as above this is the not the job of the fetcher to filter.
	This is a pity because we cannot reuse the logic of systemNavigation because we should not 
	modify the global environment."
	keys do: [ :globalName |
		(globalName beginsWith: string caseSensitive: case) ifTrue: [
			aBlock value: (NECGlobalEntry contents: globalName node: astNode) ] ]
]

{ #category : 'enumerating' }
CoDependencyPackageScopedGlobalVariableFetcher >> packages: aCollection [

	packages := aCollection
]
