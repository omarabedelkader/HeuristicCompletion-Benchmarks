"
`CoTransitiveDependencyPackageScopedGlobalVariableFetcher` is a specialized global variable fetcher that provides intelligent code completion suggestions by including **all classes defined in the transitive dependencies** of the current package. It aims to mimic the actual visibility scope of code in modular systems, going beyond direct dependencies.

- **Transitive Dependency Resolution**: It computes not just direct dependencies of a package, but recursively gathers all packages that the current package depends on, directly or indirectly.
- **Scoped Completion**: It filters completion results based on classes from:
  1. The current package,
  2. All transitive dependencies,
  3. Finally, the global environment (excluding previously suggested ones to avoid duplicates).
- **Efficient Caching**: Dependency computation results are cached in a class-side dictionary to avoid recomputation across fetches.

### How It Works

1. **Dependency Resolution**:
   - When `entriesDo:` is called, it determines the package of the current `completionClass`.
   - It uses a depth-first search (DFS)-like approach to compute transitive dependencies via `StDependencyChecker`.
   - These are cached using `dependenciesOf:` for reuse.

2. **Completion Logic**:
   - Collects and filters class names from:
     - The current package,
     - Each dependent package (transitively),
     - And finally from the global environment.
   - Suggestions from dependencies are prioritized before falling back to globals.

3. **De-duplication**:
   - It ensures that classes already suggested from local or dependent packages are not repeated when pulling from the global environment.
"
Class {
	#name : 'CoTransitiveDependencyPackageScopedGlobalVariableFetcher',
	#superclass : 'CoAbstractPackageDependentScopeGlobalVariableFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-CandidatesForPharoInclusion',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'CandidatesForPharoInclusion'
}

{ #category : 'enumerating' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcher >> entriesDo: aBlock [
	| localClassNames dependentClassNames dependentPackages keys |
	completionClass isNil ifTrue: [ ^ self ].

	"1) Add classes from current package"
	localClassNames := package definedClasses collect: [ :each | each name ].
	localClassNames do: [ :className |
		(filter accepts: className)
			ifTrue: [ aBlock value: ((NECGlobalEntry contents: className node: nil) fetcher: self ; yourself) ] ].

	"2) Add classes from transitive dependencies"
	dependentPackages := self dependenciesOf: package name.
	dependentClassNames := dependentPackages inject: OrderedCollection new into: [ :acc :pkgName |
		| pkg |
		pkg := organizer packageNamed: pkgName ifAbsent: [ nil ].
		self flag: #todo. "why this test"
		pkg isNil ifFalse: [
			acc addAll: (pkg definedClasses collect: [ :each | each name ])
		].
		acc
	].

	dependentClassNames do: [ :className |
		(filter accepts: className)
			ifTrue: [ aBlock value: (NECGlobalEntry contents: className node: nil) ] ].

	"3) Exclude them from the environment so we don't suggest duplicates"
	keys := self systemNavigation environment keys asOrderedCollection.
	localClassNames do: [ :nm | keys remove: nm ifAbsent: [] ].
	dependentClassNames do: [ :nm | keys remove: nm ifAbsent: [] ].

	"4) Finally, fill in standard global suggestions"
	keys do: [ :gName |
		(filter accepts: gName)
			ifTrue: [ aBlock value: ((NECGlobalEntry contents: gName node: astNode) fetcher: self ; yourself) ] ]
]
