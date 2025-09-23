Class {
	#name : 'CoUnitPackageSelectorFetcher',
	#superclass : 'CoPackageScopedSelectorFetcher',
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'enumerating' }
CoUnitPackageSelectorFetcher >> entriesDo: aBlock [

	completionClass isNil ifTrue: [ ^ self ].
	self packageLocalSelectors: aBlock
]
