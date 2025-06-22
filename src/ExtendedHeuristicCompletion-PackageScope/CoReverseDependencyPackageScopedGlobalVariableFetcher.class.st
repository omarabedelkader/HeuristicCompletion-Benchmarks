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
	#superclass : 'CoAbstractPackageDependentScopeGlobalVariableFetcher',
	#instVars : [
		'reverseDependencies'
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

{ #category : 'enumerating' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> entriesDo: aBlock [

	| closeClassNames keys dependentClassNames dependentPackages |
	completionClass isNil ifTrue: [ ^ self ].
	
	organizer := package organizer.

	self packageLocalClasses: aBlock.

	"Then include dependent classes from reverse dependencies"
	dependentClassNames := OrderedCollection new.
	dependentPackages := self reverseDependenciesOf:  package name.
	dependentPackages do: [ :packageName |
			dependentClassNames addAll:
				((organizer packageNamed: packageName ifAbsent: [ nil ])
					 ifNotNil: [ :pkg | pkg definedClasses collect: [ :each | each name ] ]
					 ifNil: [ #(  ) ]) ].

	dependentClassNames do: [ :depclassName |
			(filter accept: depclassName) ifTrue: [
				aBlock value: (NECGlobalEntry contents: depclassName node: nil) ] ].

	"Avoid duplicates from systemNavigation environment"
	keys := self systemNavigation environment keys asOrderedCollection.
	closeClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].
	dependentClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].

	keys do: [ :globalName |
			(filter accepts: globalName) ifTrue: [
				aBlock value: (NECGlobalEntry contents: globalName node: astNode) ] ]
]

{ #category : 'accessing' }
CoReverseDependencyPackageScopedGlobalVariableFetcher >> reverseDependenciesOf: aPackageName [

	| allPackages dependentPackages |
	allPackages := PackageOrganizer default packages. 

	dependentPackages := allPackages select: [ :pack|
			                     | dependencies |
			                     dependencies := self dependenciesOf: pack name.
			                     dependencies includes: aPackageName ].

	^ dependentPackages collect: [ :pkg | pkg name ]
]
