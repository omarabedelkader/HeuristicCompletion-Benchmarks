"
```smalltalk

| packageNames rows totClasses totDefined totMethods packageCount |
packageNames := #(
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
).

rows := packageNames collect: [ :name |
	| pkg |
	pkg := PackageOrganizer default packageNamed: name.
	pkg ifNil: [
		self inform: 'Package ', name, ' is not loaded.'.
		^{ name . 0 . 0 . 0 }   ""keep list lengths equal""
	] ifNotNil: [
		{
			name .
			pkg classes size .
			pkg definedClasses size .
			pkg methods size
		}
	]
].

totClasses := rows inject: 0 into: [:sum :r | sum + (r at: 2)].
totDefined := rows inject: 0 into: [:sum :r | sum + (r at: 3)].
totMethods := rows inject: 0 into: [:sum :r | sum + (r at: 4)].

rows := rows copyWith: { 'TOTAL' . totClasses . totDefined . totMethods }.
Transcript
	cr; show: 'Package'; tab; show: 'Classes'; tab; show: 'Defined'; tab; show: 'Methods'; cr.
rows do: [:row |
	Transcript
		show: row first; tab;
		show: row second; tab;
		show: row third; tab;
		show: row fourth; cr ].

rows inspect.

""How many packages?""
packageCount := packageNames size.   ""← **this is the number you want**""

```
"
Class {
	#name : 'CooPackageMetrics',
	#superclass : 'Object',
	#category : 'ExtendedHeuristicCompletion-Analyser',
	#package : 'ExtendedHeuristicCompletion-Analyser'
}

{ #category : 'examples' }
CooPackageMetrics class >> iceberg [ 
    <script>
    (self runForPackageNames: #(
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

{ #category : 'examples' }
CooPackageMetrics class >> moose [ 
    <script>
    (self runForPackageNames: #(
'Moose-Blueprint-Invocations-Models'
		   'Moose-Blueprint-Models' 'Moose-Blueprint-Models-Tests'
		   'Moose-Blueprint-Visualization-Models'
		   'Moose-Configuration' 'Moose-Core' 'Moose-Core-Generator'
		   'Moose-Core-Tests' 'Moose-Core-Tests-Entities'
		   'Moose-Importers'
		'Moose-Importers-Tests'
		   'Moose-Query'
		'Moose-Query-Extensions'
		'Moose-Query-Test'
		   'Moose-SmalltalkImporter'
		'Moose-SmalltalkImporter-Core-Tests'
		   'Moose-SmalltalkImporter-KGB-Tests'
		   'Moose-SmalltalkImporter-LAN-Tests'
		   'Moose-TestResources-KGB-P10InteractedReferee'
		   'Moose-TestResources-KGB-P11FullReferee'
		   'Moose-TestResources-KGB-P12FullReferencer'
		   'Moose-TestResources-KGB-P13FullReferencer'
		   'Moose-TestResources-KGB-P14FullReferee'
		   'Moose-TestResources-KGB-P1FullReferencer'
		   'Moose-TestResources-KGB-P2InteractedReferencerReferee'
		   'Moose-TestResources-KGB-P3InteractedReferencer'
		   'Moose-TestResources-KGB-P4FullInteracted'
		   'Moose-TestResources-KGB-P5FullReferee'
		   'Moose-TestResources-KGB-P6InteractedReferee'
		   'Moose-TestResources-KGB-P7ReferencerReferee'
		   'Moose-TestResources-KGB-P8FullReferencer'
		   'Moose-TestResources-KGB-P9FullReferencer'
		   'Moose-TestResources-KGB-PExtensions'
		   'Moose-TestResources-LAN' 'Moose-TestResources-LCOM'
		   'Moose-TestResources-PackageBlueprint-P1'
		   'Moose-TestResources-PackageBlueprint-P2'
		   'Moose-TestResources-PackageBlueprint-P3'
		   'Moose-TestResources-PackageBlueprint-P4'
		   'Moose-TestResources-Reference-Core'
		   'Moose-TestResources-Reference-External'
		   'Moose-TestResources-Reference-PackageOne'
		   'Moose-TestResources-Reference-PackageTwo'
		   'Moose-WelcomeBrowser' 'MooseIDE-Analysis' 'MooseIDE-AttributedText'
		   'MooseIDE-ButterflyMap' 'MooseIDE-ButterflyMap-Tests'
		   'MooseIDE-ClassBlueprint' 'MooseIDE-CoUsageMap'
		   'MooseIDE-CoUsageMap-Tests' 'MooseIDE-Core' 'MooseIDE-Core-Reporter'
		   'MooseIDE-CriticBrowser' 'MooseIDE-CriticBrowser-Tests'
		   'MooseIDE-Dependency' 'MooseIDE-Duplication'
		   'MooseIDE-Export' 'MooseIDE-Famix' 'MooseIDE-LayerVisualization'
		   'MooseIDE-Meta' 'MooseIDE-NewTools' 'MooseIDE-NewTools-Tests'
		   'MooseIDE-QueriesBrowser' 'MooseIDE-QueriesBrowser-Tests'
		   'MooseIDE-QueriesDashboard' 'MooseIDE-Spotter'
		   'MooseIDE-Spotter-Tests' 'MooseIDE-Tagging' 'MooseIDE-Tagging-Tests'
		   'MooseIDE-Tests' 'MooseIDE-Visualization'
    )) inspect.
]

{ #category : 'examples' }
CooPackageMetrics class >> roassal [ 
    <script>
    (self runForPackageNames: #(    'Roassal'
    'Roassal-Animation'
    'Roassal-Animation-Tests'
    'Roassal-BaselineMap'
    'Roassal-BaselineMap-Tests'
    'Roassal-Builders'
    'Roassal-Chart'
    'Roassal-Chart-Examples'
    'Roassal-Chart-Tests'
    'Roassal-Class-Examples'
    'Roassal-Colors'
    'Roassal-DSM'
    'Roassal-Event'
    'Roassal-Examples'
    'Roassal-Experimental'
    'Roassal-Exporters'
    'Roassal-Exporters-Examples'
    'Roassal-Exporters-Tests'
    'Roassal-FlameGraph-Examples'
    'Roassal-Global-Tests'
    'Roassal-Inspector'
    'Roassal-Inspector-Tests'
    'Roassal-Interaction'
    'Roassal-Interaction-Tests'
    'Roassal-LayoutStudio'
    'Roassal-LayoutStudio-Tests'
    'Roassal-Layouts'
    'Roassal-Layouts-Tests'
    'Roassal-Layouts-Util'
    'Roassal-Legend'
    'Roassal-Legend-Examples'
    'Roassal-Menu'
    'Roassal-Mondrian'
    'Roassal-Pie'
    'Roassal-Pie-Examples'
    'Roassal-SVG'
    'Roassal-SVG-Examples'
    'Roassal-SVG-Tests'
    'Roassal-Shapes'
    'Roassal-Shapes-Tests'
    'Roassal-Spec'
    'Roassal-Spec-Examples'
    'Roassal-Spec-Morphic'
    'Roassal-Spec-Tests'
    'Roassal-Sunburst'
    'Roassal-Sunburst-Examples'
    'Roassal-TreeMap'
    'Roassal-TreeMap-Examples'
    'Roassal-UML'
    'Roassal-UML-Calypso'
    'Roassal-UML-Examples'
    'Roassal-UML-Tests')) inspect.
]

{ #category : 'analyzing' }
CooPackageMetrics class >> runForPackageNames: packageNames [ 
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

{ #category : 'examples' }
CooPackageMetrics class >> seaside [ 
    <script>
    (self runForPackageNames: #(     'Seaside-Ajaxifier-Core'
    'Seaside-Canvas'
    'Seaside-Component'
    'Seaside-Continuation'
    'Seaside-Core'
    'Seaside-Development'
    'Seaside-Email'
    'Seaside-Environment'
    'Seaside-Examples'
    'Seaside-Flow'
    'Seaside-JSON-Core'
    'Seaside-Pharo-Canvas'
    'Seaside-Pharo-Continuation'
    'Seaside-Pharo-Core'
    'Seaside-Pharo-Development'
    'Seaside-Pharo-Email'
    'Seaside-Pharo-Environment'
    'Seaside-Pharo-Flow'
    'Seaside-Pharo-JSON-Core'
    'Seaside-Pharo-Tools-Web'
    'Seaside-Pharo-Welcome'
    'Seaside-Pharo100-Tools-Spec2'
    'Seaside-Pharo90-REST-Core'
    'Seaside-REST-Core'
    'Seaside-RenderLoop'
    'Seaside-Session'
    'Seaside-Tests-Canvas'
    'Seaside-Tests-Component'
    'Seaside-Tests-Core'
    'Seaside-Tests-Environment'
    'Seaside-Tests-Flow'
    'Seaside-Tests-Functional'
    'Seaside-Tests-Pharo-Canvas'
    'Seaside-Tests-Pharo-Continuation'
    'Seaside-Tests-Pharo-Core'
    'Seaside-Tests-Pharo-Functional'
    'Seaside-Tests-RenderLoop'
    'Seaside-Tests-Session'
    'Seaside-Tools-Core'
    'Seaside-Tools-Web'
    'Seaside-Welcome'
    'Seaside-Widgets'
    'Seaside-Zinc-Core'
    'Seaside-Zinc-Pharo')) inspect.
]

{ #category : 'examples' }
CooPackageMetrics class >> spec [ 
    <script>
    (self runForPackageNames: #(   'Spec2-Adapters-Morphic' 'Spec2-Adapters-Morphic-ListView'
   'Spec2-Adapters-Morphic-Tests' 'Spec2-Adapters-Stub'
   'Spec2-Backend-Tests' 'Spec2-Code' 'Spec2-Code-Backend-Tests'
   'Spec2-Code-Commands' 'Spec2-Code-Diff' 'Spec2-Code-Diff-Morphic'
   'Spec2-Code-Diff-Tests' 'Spec2-Code-Morphic' 'Spec2-Code-Tests'
   'Spec2-CommandLine' 'Spec2-Commander2' 'Spec2-Commander2-Tests'
   'Spec2-Commands' 'Spec2-CommonWidgets' 'Spec2-Core'
   'Spec2-Dialogs' 'Spec2-Dialogs-Tests' 'Spec2-Examples'
   'Spec2-Interactions' 'Spec2-Layout' 'Spec2-ListView'
   'Spec2-ListView-Tests' 'Spec2-Microdown' 'Spec2-Morphic'
   'Spec2-Morphic-Backend-Tests' 'Spec2-Morphic-Examples'
   'Spec2-Morphic-Tests' 'Spec2-Tests' 'Spec2-Transmission')) inspect.
]
