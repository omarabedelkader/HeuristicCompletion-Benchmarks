Class {
	#name : 'CoLateralPackageGlobalVariableFetcherTest',
	#superclass : 'CoMiniTestCase',
	#instVars : [
		'repoPackage',
		'lateralPackage'
	],
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CoLateralPackageGlobalVariableFetcherTest >> setUp [ 

    | otherClass repoClass organizer dict |
    completionClass := CoMockClass new name: 'LocalClass'.
    package := CoMockPackage new.
    package name: 'P1-Core'.
    package definedClasses: { completionClass }.
    completionClass package: package.

    repoClass := CoMockClass new name: 'RepoClass'.
    repoPackage := CoMockPackage new.
    repoPackage name: 'P1-Util'.
    repoPackage definedClasses: { repoClass }.
    repoClass package: repoPackage.

    lateralPackage := CoMockPackage new.
    lateralPackage name: 'Other-Pkg'.
    otherClass := CoMockClass new name: 'OtherClass'.
    lateralPackage definedClasses: { otherClass }.
    otherClass package: lateralPackage.

    organizer := CoMockPackageOrganizer new.
    organizer packages: { package . repoPackage . lateralPackage }.
    { package . repoPackage . lateralPackage } do: [:p | p organizer: organizer ].

    dict := Dictionary new.
    { 'OtherClass'. 'RepoClass'. 'OutsideGlobal' } do: [:g | dict at: g put: g ].
    systemNavigation := CoMockSystemNavigation new
        globals: dict;
        yourself.

    fetcher := CoLateralPackageGlobalVariableFetcher new.
    fetcher completionClass: completionClass.
    fetcher systemNavigation: systemNavigation.
    fetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: 'O').

    expectedElements := {
        NECGlobalEntry contents: 'OtherClass' node: nil .
        NECGlobalEntry contents: 'OutsideGlobal' node: nil }
]

{ #category : 'running' }
CoLateralPackageGlobalVariableFetcherTest >> testOnlyLateralGlobals [ 

    | fetched |
    fetched := self fetcher upToEnd.
    fetched withIndexDo: [:each :index | self assertEntry: each equals: (expectedElements at: index) ].
    self assert: fetched size equals: expectedElements size
]
