Class {
	#name : 'CoAutononousSinglePackageScopedGlobalVariableFetcherTest',
	#superclass : 'CoMiniTestCase',
	#category : 'HeuristicCompletion-Cocot-PackageScope',
	#package : 'HeuristicCompletion-Cocot',
	#tag : 'PackageScope'
}

{ #category : 'one local one global' }
CoAutononousSinglePackageScopedGlobalVariableFetcherTest >> setUpOneLocalThenGlobal [ 

	| a b c |
	completionClass := CoMockClass new name: 'CoInP1'. 
	a := CoMockClass new name: 'AInP1'.
	b := CoMockClass new name: 'AAInP1'.
	c := CoMockClass new name: 'AA'.
	package := CoMockPackage new. 
	package definedClasses: { a . b . c . completionClass }.
			
	systemNavigation := CoMockSystemNavigation new
		globals: OrderedCollection <- {'Ab' . 'B' . 'AIGlobal' . 'AInP1' . 'AAInP1'. 'AA' } ;
		yourself.

	fetcher := CoSinglePackageScopedGlobalVariableFetcher new. 
	fetcher packages: { package }.
	fetcher systemNavigation: systemNavigation.
	fetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: 'AI').

	expectedElements := {
		NECGlobalEntry contents: 'AInP1' node: nil .
		NECGlobalEntry contents: 'AIGlobal' node: nil }
]

{ #category : 'two locals one global' }
CoAutononousSinglePackageScopedGlobalVariableFetcherTest >> setUpTwoLocalThenGlobal [ 

	| a b c a1 |
	completionClass := CoMockClass new name: 'CoInP1'. 
	a := CoMockClass new name: 'AInP1'.
	a1 := CoMockClass new name: 'AI2nP1'.
	
	b := CoMockClass new name: 'AAInP1'.
	c := CoMockClass new name: 'AA'.
	package := CoMockPackage new. 
	package definedClasses: { a1 . a . b . c . completionClass }.
			
	systemNavigation := CoMockSystemNavigation new
		globals: OrderedCollection <- {'Ab' . 'B' . 'AIGlobal' . 'AInP1' . . 'AI2nP1' . 'AAInP1'. 'AA' } ;
		yourself.

	fetcher := CoSinglePackageScopedGlobalVariableFetcher new. 
	fetcher packages: { package }.
	fetcher systemNavigation: systemNavigation.
	fetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: 'AI').

	expectedElements := {
		NECGlobalEntry contents: 'AI2nP1' node: nil .
		NECGlobalEntry contents: 'AInP1' node: nil .
		NECGlobalEntry contents: 'AIGlobal' node: nil }
]

{ #category : 'one local one global' }
CoAutononousSinglePackageScopedGlobalVariableFetcherTest >> testFirstPackageLevelThenGlobal [

	| fetchedElements expected |
	self setUpOneLocalThenGlobal. 
	fetchedElements := self fetcher next: 2.
	expected := { self firstExpectedElement . self secondExpectedElement }.
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expected at: index) ].
	self assert: fetchedElements size equals: expected size
]

{ #category : 'two locals one global' }
CoAutononousSinglePackageScopedGlobalVariableFetcherTest >> testFirstPackageLevelWithTwoClassesThenGlobal [

	| fetchedElements |
	self setUpTwoLocalThenGlobal. 
	fetchedElements := self fetcher next: 3.
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expectedElements at: index) ].
	self assert: fetchedElements size equals: expectedElements size
]

{ #category : 'one local one global' }
CoAutononousSinglePackageScopedGlobalVariableFetcherTest >> testResetShouldRestartGenerator [

	| fetchedElements |
	self setUpOneLocalThenGlobal. 
	self fetcher upToEnd; reset.
	fetchedElements := self fetcher next: expectedElements size + 1.
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expectedElements at: index) ].
	self assert: fetchedElements size equals: expectedElements size
]
