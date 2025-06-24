"
I am a fetcher looking for globals in an environment.
"
Class {
	#name : 'CoSinglePackageScopedGlobalVariableFetcher',
	#superclass : 'CoPackageScopedGlobalVariableFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Variables',
	#package : 'ExtendedHeuristicCompletion-PackageScope',
	#tag : 'Variables'
}

{ #category : 'enumerating' }
CoSinglePackageScopedGlobalVariableFetcher >> entriesDo: aBlock [

	completionClass isNil ifTrue: [ ^ self ].
	self packageLocalClasses: aBlock
	
	
]
