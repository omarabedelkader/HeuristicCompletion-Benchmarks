Class {
	#name : 'CooPackageClassListerTest',
	#superclass : 'TestCase',
	#category : 'ExtendedHeuristicCompletion-Analyser',
	#package : 'ExtendedHeuristicCompletion-Analyser'
}

{ #category : 'tests' }
CooPackageClassListerTest >> testListClassesForDataPackage [

	| packageName collector oldTranscript lines printedNames expectedNames |
	packageName := 'ExtendedHeuristicCompletion-Analyser-Data'.
	collector := Transcript.
	oldTranscript := Transcript.
	Transcript := collector.
	[ CooPackageClassLister listClassesFor: { packageName } ] ensure: [
		Transcript := oldTranscript ].
	lines := collector contents lines reject: [ :each | each isEmpty ].
	printedNames := lines collect: [ :line | line allButFirst: 2 ].
	expectedNames := (PackageOrganizer default packageNamed: packageName)
		                 definedClasses collect: [ :cls | cls name ].
	self
		assert: printedNames asOrderedCollection
		equals: expectedNames asOrderedCollection
]
