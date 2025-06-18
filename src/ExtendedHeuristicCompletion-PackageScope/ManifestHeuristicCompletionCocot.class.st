"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestHeuristicCompletionCocot',
	#superclass : 'PackageManifest',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Manifest',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestHeuristicCompletionCocot class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#CoRepositoryPackagedScopedGlobalVariableFetcherTest #setUpThreePackages #false)) #'2025-02-12T11:58:24.179052+01:00') )
]
