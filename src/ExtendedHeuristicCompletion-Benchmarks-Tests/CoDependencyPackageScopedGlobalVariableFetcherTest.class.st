Class {
	#name : 'CoDependencyPackageScopedGlobalVariableFetcherTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CoDependencyPackageScopedGlobalVariableFetcherTest >> setUp [ 
	

    | localClass dep1 dep2 depPackage organizer dict |
	super setUp.
    completionClass := CoMockClass new name: 'LocalClass'.
    localClass := CoMockClass new name: 'OtherLocal'.
    package := CoMockPackage new.
    package name: 'P1-Core'.
    package definedClasses: { localClass . completionClass }.
    { localClass . completionClass } do: [:cl | cl package: package ].

    dep1 := CoMockClass new name: 'DepOne'.
    dep2 := CoMockClass new name: 'DepTwo'.
    depPackage := CoMockPackage new.
    depPackage name: 'Dep-Pkg'.
    depPackage definedClasses: { dep1 . dep2 }.
    { dep1 . dep2 } do: [:cl | cl package: depPackage ].

    organizer := CoMockPackageOrganizer new.
    organizer packages: { package . depPackage }.
    { package . depPackage } do: [:p | p organizer: organizer ].

    dict := Dictionary new.
    { 'DepOne'. 'DepTwo'. 'DGlobal' } do: [:each | dict at: each put: each ].
    systemNavigation := CoMockSystemNavigation new
        globals: dict;
        yourself.

    fetcher := CoDependencyPackageScopedGlobalVariableFetcher new.
    fetcher packages: { package . depPackage }.
    fetcher systemNavigation: systemNavigation.
    fetcher completionClass: completionClass.
    fetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: 'D').

    CoDependencyPackageScopedGlobalVariableFetcher class
        instVarNamed: 'dependencies'
        put: (Dictionary new
                at: package name put: { depPackage name };
                yourself).

    expectedElements := {
        NECGlobalEntry contents: 'DepOne' node: nil .
        NECGlobalEntry contents: 'DepTwo' node: nil .
        NECGlobalEntry contents: 'DGlobal' node: nil }
]

{ #category : 'running' }
CoDependencyPackageScopedGlobalVariableFetcherTest >> testDependenciesBeforeGlobals [ 

    | fetchedElements |
    fetchedElements := self fetcher next: 3.
    fetchedElements withIndexDo: [:each :index |
        self assertEntry: each equals: (expectedElements at: index) ].
    self assert: fetchedElements size equals: expectedElements size
]
