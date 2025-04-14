Class {
	#name : 'CoTransitiveDependencyPackageScopedGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'packages',
		'completionClass'
	],
	#classInstVars : [
		'dependencies'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Dependency',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Dependency'
}

{ #category : 'class initialization' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcher class >> computeDependenciesOf: aPackageName [
	"Compute direct dependencies, then expand transitively."
	
	| directDeps toVisit visited allDeps |
	directDeps := StDependencyChecker new dependenciesOf: aPackageName.
	toVisit := directDeps asOrderedCollection.
	visited := Set new.
	allDeps := Set new: directDeps size.

	[toVisit isEmpty] whileFalse: [
		| next |
		next := toVisit removeFirst.
		visited add: next.
		allDeps add: next.
		
		(StDependencyChecker new dependenciesOf: next) do: [ :dep |
			(visited includes: dep) ifFalse: [
				toVisit add: dep ] ] ].

	^ allDeps asArray
]

{ #category : 'class initialization' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcher class >> dependenciesOf: aPackageName [
	^ dependencies 
		at: aPackageName
		ifAbsentPut: [ self computeDependenciesOf: aPackageName ]
]

{ #category : 'class initialization' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcher class >> initialize [
	dependencies := Dictionary new
]

{ #category : 'accessing' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcher >> completionClass [

	^ completionClass
]

{ #category : 'accessing' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcher >> completionClass: anObject [

	completionClass := anObject
]

{ #category : 'accessing' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcher >> dependenciesOf: aString [

	^ self class dependenciesOf: aString
]

{ #category : 'enumerating' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcher >> entriesDo: aBlock [
	| string case localClassNames dependentClassNames dependentPackages organizer keys |
	completionClass isNil ifTrue: [
		"Fallback to the global environment in case we do not have a target class"
		^ self systemNavigation 
				allGlobalNamesStartingWith: filter completionString
				do: [ :e | aBlock value: (NECGlobalEntry contents: e node: astNode) ]
				caseSensitive: NECPreferences caseSensitive 
	].
	

	string := filter completionString.
	case := NECPreferences caseSensitive.
	organizer := completionClass package organizer.

	"1) Add classes from current package"
	localClassNames := completionClass package definedClasses collect: [ :each | each name ].
	localClassNames do: [ :className |
		(className beginsWith: string caseSensitive: case) 
			ifTrue: [ aBlock value: (NECGlobalEntry contents: className node: nil) ] ].

	"2) Add classes from transitive dependencies"
	dependentPackages := self dependenciesOf: completionClass package name.
	dependentClassNames := dependentPackages inject: OrderedCollection new into: [ :acc :pkgName |
		| pkg |
		pkg := organizer packageNamed: pkgName ifAbsent: [ nil ].
		pkg isNil ifFalse: [
			acc addAll: (pkg definedClasses collect: [ :each | each name ])
		].
		acc
	].

	dependentClassNames do: [ :className |
		(className beginsWith: string caseSensitive: case)
			ifTrue: [ aBlock value: (NECGlobalEntry contents: className node: nil) ] ].

	"3) Exclude them from the environment so we don't suggest duplicates"
	keys := self systemNavigation environment keys asOrderedCollection.
	localClassNames do: [ :nm | keys remove: nm ifAbsent: [] ].
	dependentClassNames do: [ :nm | keys remove: nm ifAbsent: [] ].

	"4) Finally, fill in standard global suggestions"
	keys do: [ :gName |
		(gName beginsWith: string caseSensitive: case)
			ifTrue: [ aBlock value: (NECGlobalEntry contents: gName node: astNode) ] ]
]

{ #category : 'accessing' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcher >> packages [

	^ packages
]

{ #category : 'accessing' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcher >> packages: anObject [

	packages := anObject
]
