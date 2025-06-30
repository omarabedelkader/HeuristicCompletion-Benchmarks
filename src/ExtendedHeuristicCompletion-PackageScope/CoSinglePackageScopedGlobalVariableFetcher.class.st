"
I am a fetcher looking for globals in an environment.
"
Class {
	#name : 'CoSinglePackageScopedGlobalVariableFetcher',
	#superclass : 'CoPackageScopedGlobalVariableFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-CandidatesForPharoInclusion',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'CandidatesForPharoInclusion'
}

{ #category : 'enumerating' }
CoSinglePackageScopedGlobalVariableFetcher >> entriesDo: aBlock [

	completionClass isNil ifTrue: [ ^ self ].
	self packageLocalClasses: aBlock
	
	
]
