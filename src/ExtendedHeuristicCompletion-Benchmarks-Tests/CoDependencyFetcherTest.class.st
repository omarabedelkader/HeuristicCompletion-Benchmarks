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
CoDependencyFetcherTest >> testDirectDependencyFetcherSkipsWhenCompletionClassIsNil [

        | dependencyMap mainPackage filter fetcher collected |
        dependencyMap := Dictionary newFrom: { 'MainPkg' -> #( 'DepOne' ) }.

        mainPackage := CoDependencyFetcherTestPackageStub new.
        mainPackage name: 'MainPkg'.

        filter := CoDependencyFetcherTestFilterStub new.

        fetcher := CoDependencyFetcherTestDirectFetcher new.
        fetcher dependencyMap: dependencyMap.
        fetcher instVarNamed: #package put: mainPackage.
        fetcher instVarNamed: #filter put: filter.

        collected := OrderedCollection new.
        fetcher entriesDo: [ :entry | collected add: entry contents ].

        self assert: collected isEmpty.
        self assert: filter seenNames isEmpty
]

{ #category : 'tests' }
CoDependencyFetcherTest >> testDirectDependencyFetcherSortsMultipleDependencies [
        | dependencyMap depOnePackage depTwoPackage organizer mainPackage filter fetcher collected |
        dependencyMap := Dictionary newFrom: { 'MainPkg' -> #( 'DepOne' 'DepTwo' ) }.

        depOnePackage := CoDependencyFetcherTestPackageStub new.
        depOnePackage
                name: 'DepOne';
                definedClasses: { (CoDependencyFetcherTestDefinedClassStub named: 'ZetaClass') }.

        depTwoPackage := CoDependencyFetcherTestPackageStub new.
        depTwoPackage
                name: 'DepTwo';
                definedClasses: { (CoDependencyFetcherTestDefinedClassStub named: 'AlphaClass') }.

        organizer := CoDependencyFetcherTestOrganizerStub new.
        organizer
                packages:
                        (Dictionary newFrom:
                                 { 'DepOne' -> depOnePackage.
                                 'DepTwo' -> depTwoPackage }).

        mainPackage := CoDependencyFetcherTestPackageStub new.
        mainPackage name: 'MainPkg'.

        filter := CoDependencyFetcherTestFilterStub new.
        filter acceptedNames: #( 'AlphaClass' 'ZetaClass' ).

        fetcher := CoDependencyFetcherTestDirectFetcher new.
        fetcher dependencyMap: dependencyMap.
        fetcher instVarNamed: #completionClass put: Object.
        fetcher instVarNamed: #package put: mainPackage.
        fetcher instVarNamed: #organizer put: organizer.
        fetcher instVarNamed: #filter put: filter.

        collected := OrderedCollection new.
        fetcher entriesDo: [ :entry | collected add: entry contents ].

        self assert: collected asArray equals: #( 'AlphaClass' 'ZetaClass' ).
        self
                assert: filter seenNames asArray
                equals: #( 'AlphaClass' 'ZetaClass' )
]

{ #category : 'tests' }
CoDependencyFetcherTest >> testReverseDependencyFetcherFallsBackToGlobals [

        | reverseMap organizer mainPackage filter systemNavigation fetcher collected |
        reverseMap := Dictionary newFrom: { 'MainPkg' -> #(  ) }.

        organizer := CoDependencyFetcherTestOrganizerStub new.
        organizer packages: Dictionary new.

        mainPackage := CoDependencyFetcherTestPackageStub new.
        mainPackage
                name: 'MainPkg';
                organizer: organizer.

        filter := CoDependencyFetcherTestFilterStub new.
        filter acceptedNames: #( 'GlobalB' ).

        systemNavigation := CoDependencyFetcherTestSystemNavigationStub new.
        systemNavigation
                environment:
                        (CoDependencyFetcherTestEnvironmentStub
                                 withKeys: (OrderedCollection with: 'GlobalA' with: 'GlobalB')).

        fetcher := CoDependencyFetcherTestReverseFetcher new.
        fetcher reverseDependencyMap: reverseMap.
        fetcher instVarNamed: #completionClass put: Object.
        fetcher instVarNamed: #package put: mainPackage.
        fetcher instVarNamed: #filter put: filter.
        fetcher instVarNamed: #systemNavigation put: systemNavigation.

        collected := OrderedCollection new.
        fetcher entriesDo: [ :entry | collected add: entry contents ].

        self assert: collected asArray equals: #( 'GlobalB' ).
        self assert: filter seenNames asArray equals: #( 'GlobalA' 'GlobalB' )
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

{ #category : 'tests' }
CoDependencyFetcherTest >> testReverseDependencyFetcherSkipsWhenCompletionClassIsNil [
        | reverseMap mainPackage filter fetcher collected |
        reverseMap := Dictionary newFrom: { 'MainPkg' -> #( 'DependentPkg' ) }.

        mainPackage := CoDependencyFetcherTestPackageStub new.
        mainPackage name: 'MainPkg'.

        filter := CoDependencyFetcherTestFilterStub new.

        fetcher := CoDependencyFetcherTestReverseFetcher new.
        fetcher reverseDependencyMap: reverseMap.
        fetcher instVarNamed: #package put: mainPackage.
        fetcher instVarNamed: #filter put: filter.

        collected := OrderedCollection new.
        fetcher entriesDo: [ :entry | collected add: entry contents ].

        self assert: collected isEmpty.
        self assert: filter seenNames isEmpty
]
