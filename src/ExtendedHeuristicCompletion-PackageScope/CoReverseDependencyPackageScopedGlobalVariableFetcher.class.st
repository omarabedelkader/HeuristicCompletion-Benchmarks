"
`CoReverseDependencyPackageScopedGlobalVariableFetcher` is a specialized global variable fetcher that focuses on **reverse dependencies**—that is, it suggests globals defined in packages that **depend on the current package**. This is useful in tooling scenarios where you want completions to reflect the usage context of a package, especially when reverse lookup is meaningful (e.g., plugin discovery, usage impact analysis).

### Core Responsibilities

- **Reverse Dependency Lookup**: It identifies all packages that list the current package as a dependency.
- **Scoped Global Suggestions**: Completion suggestions include:
  1. Classes from the current package,
  2. Classes defined in reverse-dependent packages,
  3. Remaining globals from the environment, de-duplicated.
- **Cached Dependency Resolution**: Like its sibling fetchers, it caches dependency results for efficiency.

### Real-World Example: Who Depends on This?

```smalltalk
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

This script finds and prints all packages that **depend on** `NECompletion`. It uses `CoDependencyPackageScopedGlobalVariableFetcher` to get each package's dependencies, then filters for the ones that include the target.

### Completion Logic Overview

When `entriesDo:` is triggered:
1. **If `completionClass` is `nil`**, it falls back to suggesting all globals matching the input string.
2. **Otherwise**, it:
   - Collects classes from the current package.
   - Resolves and collects classes from reverse-dependent packages.
   - Avoids duplicate suggestions by removing already-suggested class names from the global environment.
   - Finally, includes standard globals (minus duplicates).

### Why Use This?

This fetcher is valuable when:
- You're building tools that operate from the perspective of the **package being depended on** (e.g., a shared library or service package).
- You want completions that include usage-context-relevant classes, like clients or plugins.

It complements forward-based fetchers (like transitive or direct dependency-based ones) by providing the **inverse view**—what depends on me?
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
	#category : 'ExtendedHeuristicCompletion-PackageScope-Variables',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Variables'
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
