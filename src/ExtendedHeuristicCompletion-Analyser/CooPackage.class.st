"
I'm an abstract class. see my subclasses
"
Class {
	#name : 'CooPackage',
	#superclass : 'Object',
	#category : 'ExtendedHeuristicCompletion-Analyser',
	#package : 'ExtendedHeuristicCompletion-Analyser'
}

{ #category : 'as yet unclassified' }
CooPackage class >> listClassesFor: packageNames [
    | allClassNames |
    allClassNames := packageNames
        flatCollect: [:packageName |
            (PackageOrganizer default packageNamed: packageName)
                definedClasses collect: [:eachClass | eachClass name]].
    allClassNames do: [:className |
        Transcript show: '- ',className; cr ]
]

{ #category : 'analyzing' }
CooPackage class >> runForPackageNames: packageNames [ 
    | rows totClasses totDefined totMethods totInternalRatio internalUserCount totExternalRefs |
    rows := packageNames collect: [ :name |
        | pkg analyser internalRatio internalCount externalCount |
        pkg := PackageOrganizer default packageNamed: name.
        pkg ifNil: [
            Transcript show: 'Package ', name, ' is not loaded.'; cr.
            { name . 0 . 0 . 0 . 0.0 . 0 . 0 }
        ] ifNotNil: [
            analyser := PackageAnalyser new.
            analyser runAnalysisForPackage: pkg.
            internalRatio := analyser internalUserRatio.
            internalCount := analyser internalUserCount.
            externalCount := analyser externalReferences size.
            {
                name .
                pkg classes size .
                pkg definedClasses size .
                pkg methods size .
                internalRatio .
                internalCount .
                externalCount
            }
        ]
    ].

    totClasses := rows inject: 0 into: [ :sum :r | sum + (r at: 2) ].
    totDefined := rows inject: 0 into: [ :sum :r | sum + (r at: 3) ].
    totMethods := rows inject: 0 into: [ :sum :r | sum + (r at: 4) ].
    totInternalRatio := rows inject: 0.0 into: [ :sum :r | sum + (r at: 5) ].
    internalUserCount := rows inject: 0 into: [ :sum :r | sum + (r at: 6) ].
    totExternalRefs := rows inject: 0 into: [ :sum :r | sum + (r at: 7) ].

    rows := rows copyWith: {
        'TOTAL'.
        totClasses.
        totDefined.
        totMethods.
        totInternalRatio / packageNames size asFloat.
        internalUserCount.
        totExternalRefs
    }.

    ^ rows
]
