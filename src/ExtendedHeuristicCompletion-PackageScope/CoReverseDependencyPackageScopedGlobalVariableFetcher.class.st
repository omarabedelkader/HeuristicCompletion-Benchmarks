"
I am a fetcher looking for globals in an environment.


```st
| targetPackageName reverseDependencies allPackages dependencyChecker |

targetPackageName := 'NECompletion'.

dependencyChecker := CoDependencyPackageScopedGlobalVariableFetcher new.
allPackages := PackageOrganizer default packages.

reverseDependencies := allPackages select: [:package |
    | dependencies |
    dependencies := dependencyChecker dependenciesOf: package name.
    dependencies includes: targetPackageName
].

reverseDependencies do: [:package |
    Transcript show: 'Package ', package name, ' depends on ', targetPackageName; cr.
].
```
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
		'dependencies'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Dependency',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Dependency'
}

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher class >> computeDependenciesOf: aPackageName [

	^ StDependencyChecker new dependenciesOf: aPackageName
]

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher class >> dependenciesOf: aPackageName [

	^ dependencies
		  at: aPackageName
		  ifAbsentPut: [ self computeDependenciesOf: aPackageName ]
]

{ #category : 'class initialization' }
CoReverseDependencyPackageScopedGlobalVariableFetcher class >> initialize [

	dependencies := Dictionary new
]

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> completionClass [

	^ completionClass
]

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> completionClass: anObject [

	completionClass := anObject
]

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> dependenciesOf: aString [

	^ self class dependenciesOf: aString
]

{ #category : 'enumerating' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> entriesDo: aBlock [

	| string case closeClassNames keys organizer dependentClassNames dependentPackages |
	completionClass isNil ifTrue: [
			^ self systemNavigation
				  allGlobalNamesStartingWith: filter completionString
				  do: [ :e |
				  aBlock value: (NECGlobalEntry contents: e node: astNode) ]
				  caseSensitive: NECPreferences caseSensitive ].

	string := filter completionString.
	case := NECPreferences caseSensitive.
	organizer := completionClass package organizer.

	"First, include classes from the current package"
	closeClassNames := completionClass package definedClasses collect: [
		                   :each | each name ].
	closeClassNames do: [ :closeClassName |
			(closeClassName beginsWith: string caseSensitive: case) ifTrue: [
				aBlock value: (NECGlobalEntry contents: closeClassName node: nil) ] ].

	"Then include dependent classes from reverse dependencies"
	dependentClassNames := OrderedCollection new.
	dependentPackages := self reverseDependenciesOf:
		                     completionClass package name.
	dependentPackages do: [ :packageName |
			dependentClassNames addAll:
				((organizer packageNamed: packageName ifAbsent: [ nil ])
					 ifNotNil: [ :pkg |
					 pkg definedClasses collect: [ :each | each name ] ]
					 ifNil: [ #(  ) ]) ].

	dependentClassNames do: [ :closeClassName |
			(closeClassName beginsWith: string caseSensitive: case) ifTrue: [
				aBlock value: (NECGlobalEntry contents: closeClassName node: nil) ] ].

	"Avoid duplicates from systemNavigation environment"
	keys := self systemNavigation environment keys asOrderedCollection.
	closeClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].
	dependentClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].

	keys do: [ :globalName |
			(globalName beginsWith: string caseSensitive: case) ifTrue: [
				aBlock value: (NECGlobalEntry contents: globalName node: astNode) ] ]
]

{ #category : 'enumerating' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> packages: aCollection [

	packages := aCollection
]

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> reverseDependenciesOf: aPackageName [

	| allPackages dependentPackages |
	allPackages := PackageOrganizer default packages. "self class packageOrganizer"

	dependentPackages := allPackages select: [ :package |
			                     | dependencies |
			                     dependencies := self dependenciesOf:
				                                     package name.
			                     dependencies includes: aPackageName ].

	^ dependentPackages collect: [ :pkg | pkg name ]
]
