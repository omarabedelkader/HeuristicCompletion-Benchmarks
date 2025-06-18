Class {
	#name : 'CoReverseDependencyPackageScopedGlobalVariableFetcherTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CoReverseDependencyPackageScopedGlobalVariableFetcherTest >> setUp [ 

    | local clientClass clientPackage organizer dict deps |
    completionClass := CoMockClass new name: 'Local'.
    package := CoMockPackage new.
    package name: 'P1-Core'.
    package definedClasses: { completionClass }.
    completionClass package: package.

    clientClass := CoMockClass new name: 'ClientClass'.
    clientPackage := CoMockPackage new.
    clientPackage name: 'Client'.
    clientPackage definedClasses: { clientClass }.
    clientClass package: clientPackage.

    organizer := CoMockPackageOrganizer new.
    organizer packages: { package . clientPackage }.
    { package . clientPackage } do: [:p | p organizer: organizer ].

    dict := Dictionary new.
    { 'ClientClass' } do: [:each | dict at: each put: each ].
    systemNavigation := CoMockSystemNavigation new
        globals: dict;
        yourself.

    deps := Dictionary new.
    deps at: package name put: #().
    deps at: clientPackage name put: { package name }.
    CoReverseDependencyPackageScopedGlobalVariableFetcher class
        instVarNamed: 'dependencies' put: deps.

    fetcher := CoReverseDependencyPackageScopedGlobalVariableFetcher new.
    fetcher packages: { package . clientPackage }.
    fetcher systemNavigation: systemNavigation.
    fetcher completionClass: completionClass.
    fetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: 'Cli').

    expectedElements := { NECGlobalEntry contents: 'ClientClass' node: nil }

]

{ #category : 'running' }
CoReverseDependencyPackageScopedGlobalVariableFetcherTest >> testReverseDependentPackages [ 

    | fetched |
    fetched := self fetcher upToEnd.
    fetched withIndexDo: [:each :index | self assertEntry: each equals: (expectedElements at: index) ].
    self assert: fetched size equals: expectedElements size
]
