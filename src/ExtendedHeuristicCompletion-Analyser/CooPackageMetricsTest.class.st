Class {
	#name : 'CooPackageMetricsTest',
	#superclass : 'TestCase',
	#category : 'ExtendedHeuristicCompletion-Analyser',
	#package : 'ExtendedHeuristicCompletion-Analyser'
}

{ #category : 'tests' }
CooPackageMetricsTest >> testTotalsForMultiplePackages [ 


        | names metrics pkg1 pkg2 analyser1 analyser2 total expected |
        names := { 'ExtendedHeuristicCompletion-Analyser-Data'. 'ExtendedHeuristicCompletion-Analyser-Data2' }.
        metrics := CooPackageMetrics runForPackageNames: names.
        pkg1 := PackageOrganizer default packageNamed: names first.
        pkg2 := PackageOrganizer default packageNamed: names second.
        analyser1 := PackageAnalyser new.
        analyser1 runAnalysisForPackage: pkg1.
        analyser2 := PackageAnalyser new.
        analyser2 runAnalysisForPackage: pkg2.
        expected := {
                'TOTAL'.
                pkg1 classes size + pkg2 classes size.
                pkg1 definedClasses size + pkg2 definedClasses size.
                pkg1 methods size + pkg2 methods size.
                (analyser1 internalUserRatio + analyser2 internalUserRatio) / names size asFloat.
                analyser1 internalUserCount + analyser2 internalUserCount.
                analyser1 externalReferences size + analyser2 externalReferences size }.
        total := metrics last.
        self assert: metrics size equals: names size + 1.
        self assert: total equals: expected
]
