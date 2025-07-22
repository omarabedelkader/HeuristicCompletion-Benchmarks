Class {
	#name : 'CooPackageClassLister',
	#superclass : 'Object',
	#category : 'ExtendedHeuristicCompletion-Analyser',
	#package : 'ExtendedHeuristicCompletion-Analyser'
}

{ #category : 'as yet unclassified' }
CooPackageClassLister class >> iceberg [ 
    <script>
    (self listClassesFor: #(
        'Iceberg'
        'Iceberg-Libgit'
        'Iceberg-Libgit-Filetree'
        'Iceberg-Libgit-Tonel'
        'Iceberg-Metacello-Integration'
        'Iceberg-Plugin'
        'Iceberg-Plugin-Github'
        'Iceberg-Plugin-Migration'
        'Iceberg-Plugin-Pharo'
        'Iceberg-TipUI'
        'Iceberg-TipUI-SnapShotBrowser'
    )) inspect.
]

{ #category : 'as yet unclassified' }
CooPackageClassLister class >> listClassesFor: packageNames [
    | allClassNames |
    allClassNames := packageNames
        flatCollect: [:packageName |
            (PackageOrganizer default packageNamed: packageName)
                definedClasses collect: [:eachClass | eachClass name]].
    allClassNames do: [:className |
        Transcript show: '- ',className; cr ]
]
