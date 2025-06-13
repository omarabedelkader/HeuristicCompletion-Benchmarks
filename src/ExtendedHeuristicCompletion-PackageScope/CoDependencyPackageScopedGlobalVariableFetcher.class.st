"
`CoDependencyPackageScopedGlobalVariableFetcher` is a global variable fetcher that provides code completion suggestions based on the **direct dependencies** of the current package. It scopes the completion results to what the current class or package is legally allowed to see, helping enforce **modular visibility** and **project-level encapsulation**.

### Core Responsibilities

- **Respects Direct Dependencies**: It fetches and caches the list of directly dependent packages for a given package using `StDependencyChecker`.
- **Scoped Suggestions**: Completion suggestions include:
  1. Classes defined in the current package,
  2. Classes from directly dependent packages,
  3. Remaining global variables from the environment (excluding duplicates).
- **Caching for Efficiency**: Dependencies are memoized per package to avoid recomputation.

### How It Works

1. **Dependency Resolution**:
   - Uses a class-side cache (`dependencies`) to store the direct dependencies of each package.
   - Fetches dependencies on-demand via `computeDependenciesOf:` if not already cached.

2. **Completion Logic in `entriesDo:`**:
   - If `completionClass` is not set, it defaults to fetching all globals from the environment.
   - Otherwise:
     - Adds classes defined in the current package.
     - Adds classes from directly dependent packages.
     - Avoids duplicates by removing already-added names from the global environment list.
     - Finally, adds global environment entries that match the filter and weren’t already included.

3. **Package Organizer Awareness**:
   - Uses the `PackageOrganizer` to resolve actual package instances by name and retrieve their defined classes.

### Use Case

Use this fetcher when:
- You want completions to be **strictly scoped to direct dependencies**, such as in highly modular systems or layered architectures.
- You're building tooling that mimics real code accessibility—helping developers **stay within their allowed boundaries**.
- You care about **completion relevance** in the context of modular design.

### Notes

- Unlike transitive fetchers, this one **does not recurse** through dependency trees—it sticks to direct dependencies only.
- It also avoids mutating or over-filtering the global environment, honoring a clear separation of fetcher concerns vs environment concerns.

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
	#category : 'ExtendedHeuristicCompletion-PackageScope-CandidatesForPharoInclusion',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'CandidatesForPharoInclusion'
}

{ #category : 'accessing' }
CoDependencyPackageScopedGlobalVariableFetcher class >> computeDependenciesOf: aPackageName [
	
	^ StDependencyChecker new dependenciesOf: aPackageName
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

	| string case homePackageClassNames keys organizer dependentClassNames dependentPackages |
	completionClass isNil ifTrue: [ ^ self fallbackEntriesDo: aBlock ].

	string := filter completionString.
	case := NECPreferences caseSensitive.
	organizer := completionClass package organizer.

	"First package level"
	homePackageClassNames := completionClass package definedClasses collect: [ :each | each name ].
	homePackageClassNames do: [ :closeClassName |
		(closeClassName beginsWith: string caseSensitive: case) ifTrue: [
			aBlock value: (NECGlobalEntry contents: closeClassName node: nil) ] ].


	dependentClassNames := OrderedCollection new.
	dependentPackages := self dependenciesOf: completionClass package name. 

	dependentPackages do: [ :packageName |
		dependentClassNames addAll:
			((organizer packageNamed: packageName ifAbsent: [  ])
				 definedClasses collect: [ :each | each name ]) ].
	self flag: #todo.
	"should we not sort dependentClassNames?"
	
	dependentClassNames do: [ :closeClassName |
		(closeClassName beginsWith: string caseSensitive: case) ifTrue: [
			aBlock value: (NECGlobalEntry contents: closeClassName node: nil) ] ].

	"if we blindly iterate the global environment i.e., delegating to the rest of the configuration,
	it may happen that the global fetcher will return a class already seen. 
	So we manage the global lookup here.
	It may mean that the global fetcher could be working on keys and that it could 
	be customized to support the semantics we want. This way we would avoid to redefine it locally."
	keys := self systemNavigation environment keys asOrderedCollection.
	homePackageClassNames do: [ :e | keys remove: e ifAbsent: [  ] ].
	dependentClassNames do: [ :e | keys remove: e ifAbsent: [  ] ].
	keys do: [ :globalName |
		(globalName beginsWith: string caseSensitive: case) ifTrue: [
			aBlock value: (NECGlobalEntry contents: globalName node: astNode) ] ]
	


]

{ #category : 'enumerating' }
CoDependencyPackageScopedGlobalVariableFetcher >> fallbackEntriesDo: aBlock [ 

	^ self systemNavigation
		allGlobalNamesStartingWith: filter completionString
		do: [ :e | aBlock value: (NECGlobalEntry contents: e node: astNode) ]
		caseSensitive: NECPreferences caseSensitive
]

{ #category : 'enumerating' }
CoDependencyPackageScopedGlobalVariableFetcher >> packages: aCollection [

	packages := aCollection
]
