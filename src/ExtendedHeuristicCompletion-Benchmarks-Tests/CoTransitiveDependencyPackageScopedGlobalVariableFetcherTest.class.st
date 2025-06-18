Class {
	#name : 'CoTransitiveDependencyPackageScopedGlobalVariableFetcherTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcherTest >> setUp [ 

    | depClass transClass depPackage transPackage organizer dict deps |
    completionClass := CoMockClass new name: 'Local'.
    package := CoMockPackage new.
    package name: 'P1-Core'.
    package definedClasses: { completionClass }.
    completionClass package: package.

    depClass := CoMockClass new name: 'DepClass'.
    depPackage := CoMockPackage new.
    depPackage name: 'DepA'.
    depPackage definedClasses: { depClass }.
    depClass package: depPackage.

    transClass := CoMockClass new name: 'TransClass'.
    transPackage := CoMockPackage new.
    transPackage name: 'TransDep'.
    transPackage definedClasses: { transClass }.
    transClass package: transPackage.

    organizer := CoMockPackageOrganizer new.
    organizer packages: { package . depPackage . transPackage }.
    { package . depPackage . transPackage } do: [:p | p organizer: organizer ].

    dict := Dictionary new.
    { 'DepClass'. 'TransClass'. 'DGlobal' } do: [:e | dict at: e put: e ].
    systemNavigation := CoMockSystemNavigation new
        globals: dict;
        yourself.

    deps := Dictionary new.
    deps at: package name put: { depPackage name }.
    deps at: depPackage name put: { transPackage name }.
    deps at: transPackage name put: #().
    CoTransitiveDependencyPackageScopedGlobalVariableFetcher class
        instVarNamed: 'dependencies' put: deps.

    fetcher := CoTransitiveDependencyPackageScopedGlobalVariableFetcher new.
    fetcher packages: { package . depPackage . transPackage }.
    fetcher systemNavigation: systemNavigation.
    fetcher completionClass: completionClass.
    fetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: 'D').

    expectedElements := {
        NECGlobalEntry contents: 'DepClass' node: nil .
        NECGlobalEntry contents: 'TransClass' node: nil .
        NECGlobalEntry contents: 'DGlobal' node: nil }

]

{ #category : 'running' }
CoTransitiveDependencyPackageScopedGlobalVariableFetcherTest >> testIncludeTransitiveDependencies [ 

    | fetched |
    fetched := self fetcher next: 3.
    fetched withIndexDo: [:each :index | self assertEntry: each equals: (expectedElements at: index) ].
    self assert: fetched size equals: expectedElements size
]
