Class {
	#name : 'CoDependencyFetcherTest',
	#superclass : 'CoMiniTestCase',
	#category : 'ExtendedHeuristicCompletion-Benchmarks-Tests',
	#package : 'ExtendedHeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'tests' }
CoDependencyFetcherTest >> testDirectDependencyFetcherFiltersEntries [

        | dependencyMap dependencyPackage organizer mainPackage filter fetcher collected |
        dependencyMap := Dictionary newFrom: { 'MainPkg' -> #( 'DepOne' ) }.

        dependencyPackage := CoDependencyFetcherTestPackageStub new.
        dependencyPackage
                name: 'DepOne';
                definedClasses:
                        { (CoDependencyFetcherTestDefinedClassStub named: 'DepClassA').
                        (CoDependencyFetcherTestDefinedClassStub named: 'DepClassB') }.

        organizer := CoDependencyFetcherTestOrganizerStub new.
        organizer packages: (Dictionary newFrom: { 'DepOne' -> dependencyPackage }).

        mainPackage := CoDependencyFetcherTestPackageStub new.
        mainPackage name: 'MainPkg'.

        filter := CoDependencyFetcherTestFilterStub new.
        filter acceptedNames: #( 'DepClassB' ).

        fetcher := CoDependencyFetcherTestDirectFetcher new.
        fetcher dependencyMap: dependencyMap.
        fetcher instVarNamed: #completionClass put: Object.
        fetcher instVarNamed: #package put: mainPackage.
        fetcher instVarNamed: #organizer put: organizer.
        fetcher instVarNamed: #filter put: filter.

        collected := OrderedCollection new.
        fetcher entriesDo: [ :entry | collected add: entry contents ].

        self assert: collected asArray equals: #( 'DepClassB' ).
        self
                assert: filter seenNames asArray
                equals: #( 'DepClassA' 'DepClassB' )
]

{ #category : 'tests' }
CoDependencyFetcherTest >> testReverseDependencyFetcherMergesDependenciesWithGlobals [

        | reverseMap dependentPackage organizer mainPackage filter systemNavigation fetcher collected |
        reverseMap := Dictionary newFrom: { 'MainPkg' -> #( 'DependentPkg' ) }.

        dependentPackage := CoDependencyFetcherTestPackageStub new.
        dependentPackage
                name: 'DependentPkg';
                definedClasses:
                        { (CoDependencyFetcherTestDefinedClassStub named: 'DependentClass') }.

        organizer := CoDependencyFetcherTestOrganizerStub new.
        organizer packages: (Dictionary newFrom: { 'DependentPkg' -> dependentPackage }).

        mainPackage := CoDependencyFetcherTestPackageStub new.
        mainPackage
                name: 'MainPkg';
                organizer: organizer.

        filter := CoDependencyFetcherTestFilterStub new.
        filter acceptedNames: #( 'DependentClass' 'GlobalA' ).

        systemNavigation := CoDependencyFetcherTestSystemNavigationStub new.
        systemNavigation
                environment:
                        (CoDependencyFetcherTestEnvironmentStub
                                 withKeys: (OrderedCollection with: 'GlobalA' with: 'GlobalB')).

        fetcher := CoDependencyFetcherTestReverseFetcher new.
        fetcher reverseDependencyMap: reverseMap.
        fetcher instVarNamed: #completionClass put: Object.
        fetcher instVarNamed: #package put: mainPackage.
        fetcher instVarNamed: #organizer put: organizer.
        fetcher instVarNamed: #filter put: filter.
        fetcher instVarNamed: #systemNavigation put: systemNavigation.

        collected := OrderedCollection new.
        fetcher entriesDo: [ :entry | collected add: entry contents ].

        self assert: collected asArray equals: #( 'DependentClass' 'GlobalA' ).
        self
                assert: filter seenNames asArray
                equals: #( 'DependentClass' 'GlobalA' 'GlobalB' )
]
