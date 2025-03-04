Class {
	#name : 'CoAutononousPackageScopedGlobalVariableFetcherTest',
	#superclass : 'CoMiniTestCase',
	#instVars : [
		'package1',
		'package2',
		'package3'
	],
	#category : 'HeuristicCompletion-Cocot-PackageScope',
	#package : 'HeuristicCompletion-Cocot',
	#tag : 'PackageScope'
}

{ #category : 'one local one global' }
CoAutononousPackageScopedGlobalVariableFetcherTest >> setUpThreePackages [
	" we have
	
		2 packages 
			P1A : Ai12 Ai13 A11 AA1 CoInP1
			P2A : Ai2 Ai23 AA2
			P2A : Ai3 A33 Blop
	
	and two globals
			
		"
	
	
	| ai12 ai13 a11 aa1 ai2 ai23 aa2 ai3 a33 blop classesInP1 classesInP2 classesInP3 organizer dict |
	completionClass := CoMockClass new name: 'CoInP1'. 
	ai12 := CoMockClass new name: 'Ai12'.
	ai13 := CoMockClass new name: 'Ai13'.
	a11 := CoMockClass new name: 'A11'.
	aa1 := CoMockClass new name: 'AA1'.
	
	ai2 := CoMockClass new name: 'Ai2'.
	ai23 := CoMockClass new name: 'Ai23'.
	aa2 := CoMockClass new name: 'AA2'.
	
	ai3 := CoMockClass new name: 'Ai3'.
	a33 := CoMockClass new name: 'A33'.
	blop := CoMockClass new name: 'Blop'.
		
	package1 := CoMockPackage new. 
	package1 name: 'P1-Core1'.
	classesInP1 := { ai12 . ai13 . a11 . aa1 . completionClass}.
	package1 definedClasses: classesInP1.
	classesInP1 do: [:cl | cl package: package1]. 
	
	package2 := CoMockPackage new. 
	package2 name: 'P1-Core2'.
	classesInP2 :=  { ai2 . ai23 . aa2}.
	package2 definedClasses: classesInP2.
	classesInP2 do: [:cl | cl package: package2]. 
	
	
	package3 := CoMockPackage new. 
	package3 name: 'P1-Test'.
	classesInP3 :=  { ai3 . a33 . blop}.
	package3 definedClasses: classesInP3.
	classesInP3 do: [:cl | cl package: package3]. 
	
	organizer := CoMockPackageOrganizer new.
	organizer packages: { package1 . package2. package3 }.
	 { package1 . package2. package3 } do: [ :p | p organizer: organizer ].
	
	
	"We need an environment with keys. We create a dummy dictionary with keys and just the same as value"
	dict := Dictionary new. 
	{'AiGlobal1' . 'AiGlobal2' . 'Ai12' .  'Ai13' . 'A11' .'Aa1' . 'Ai2' . 'Ai23' . 'Aa2' . 'Ai3' . 'A33' . 'Blop'}
		do: [ :each | dict at: each put: each ].
		
	systemNavigation := CoMockSystemNavigation new
		globals: dict;
		yourself.

	fetcher := CoPackageScopedGlobalVariableFetcher new. 
	fetcher packages: { package1 . package2 . package3 }.
	fetcher completionClass: completionClass.
	fetcher systemNavigation: systemNavigation.
	fetcher filter: (CoBeginsWithFilter caseSensitive: false filterString: 'Ai').

	expectedElements := {
		NECGlobalEntry contents: 'Ai12' node: nil .
		NECGlobalEntry contents: 'Ai13' node: nil .
		NECGlobalEntry contents: 'Ai2' node: nil .
		NECGlobalEntry contents: 'Ai23' node: nil .
		NECGlobalEntry contents: 'Ai3' node: nil .
		NECGlobalEntry contents: 'AiGlobal1' node: nil .
		NECGlobalEntry contents: 'AiGlobal2' node: nil .
		}
]

{ #category : 'one local one global' }
CoAutononousPackageScopedGlobalVariableFetcherTest >> testFirstPackageOfCompletionClass [

	| fetchedElements expected |
	self setUpThreePackages. 
	fetchedElements := self fetcher next: 2.
	expected := { self firstExpectedElement . self secondExpectedElement }.
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expected at: index) ].
	self assert: fetchedElements size equals: expected size
]

{ #category : 'one local one global' }
CoAutononousPackageScopedGlobalVariableFetcherTest >> testFirstPackageOfCompletionClassThenAllProjectLevelPackage [

	| fetchedElements expected |
	self setUpThreePackages. 
	fetchedElements := self fetcher next: 5.
	expected  := expectedElements first: 5. 
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expected at: index) ].
	self assert: fetchedElements size equals: expected size
]

{ #category : 'one local one global' }
CoAutononousPackageScopedGlobalVariableFetcherTest >> testFirstPackageOfCompletionClassThenAllProjectLevelPackageThenGlobals [

	| fetchedElements expected |
	self setUpThreePackages. 
	fetchedElements := self fetcher next: 7.
	expected  := expectedElements first: 7. 
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expected at: index) ].
	self assert: fetchedElements size equals: expected size
]

{ #category : 'one local one global' }
CoAutononousPackageScopedGlobalVariableFetcherTest >> testFirstPackageOfCompletionClassThenProjectLevelPackage [

	| fetchedElements expected |
	self setUpThreePackages. 
	fetchedElements := self fetcher next: 3.
	expected  := expectedElements first: 3. 
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expected at: index) ].
	self assert: fetchedElements size equals: expected size
]

{ #category : 'one local one global' }
CoAutononousPackageScopedGlobalVariableFetcherTest >> testNoClassesInPackage [
	"Tests the behavior if a package has no classes that match 'Ai'."

	| localPackage localFetcher localSystemNavigation fetchedElements |
	localPackage := CoMockPackage new.
	localPackage name: 'Empty-Package'.
	localPackage definedClasses: #(  ).

	localSystemNavigation := CoMockSystemNavigation new
		                         globals: { 'AiGlobal1'. 'AiGlobal2' };
		                         yourself.

	localFetcher := CoPackageScopedGlobalVariableFetcher new.
	localFetcher
		packages: { localPackage };
		completionClass: nil;
		systemNavigation: localSystemNavigation;
		filter: (CoBeginsWithFilter caseSensitive: false filterString: 'Ai').

	fetchedElements := localFetcher upToEnd.

	"Because the package is empty and we have no 'completionClass', 
	 the default logic might just revert to the global fetcher or return the 2 globals."

	self assert: fetchedElements size equals: 2.
	self
		assert: (fetchedElements collect: #contents) asSet
		equals: #( 'AiGlobal1' 'AiGlobal2' ) asSet
]

{ #category : 'one local one global' }
CoAutononousPackageScopedGlobalVariableFetcherTest >> testRequestMoreThanAvailableOnlyReturnAvailable [

	| fetchedElements expected |
	self setUpThreePackages. 
	fetchedElements := self fetcher next: 10.
	
	"There is more than 7 classes starting with Ai"
	self assert: fetchedElements size equals: 7.
	
	expected  := expectedElements first: 7. 
	fetchedElements withIndexDo: [ :each :index |
		self assertEntry: each equals: (expected at: index) ].
	self assert: fetchedElements size equals: expected size
]
