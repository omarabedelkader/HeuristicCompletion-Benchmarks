Class {
	#name : 'CoPackageScopedGlobalSelectorFetcher',
	#superclass : 'CoGlobalSelectorFetcher',
	#instVars : [
		'package',
		'completionClass',
		'organizer'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'accessing' }
CoPackageScopedGlobalSelectorFetcher >> completionClass [ 
    ^ completionClass
]

{ #category : 'accessing' }
CoPackageScopedGlobalSelectorFetcher >> completionClass: aClass [ 

    completionClass := aClass.
    completionClass ifNotNil: [
        package := completionClass package.
        organizer := package organizer ].
]

{ #category : 'accessing' }
CoPackageScopedGlobalSelectorFetcher >> packageLocalSelectors: aBlock [ 
    | selectors |
    selectors := OrderedCollection new.
    package definedClasses do: [ :cls | selectors addAll: cls selectors ].
    selectors do: [ :sel |
        (filter accepts: sel) ifTrue: [
            aBlock value: ((NECGlobalEntry contents: sel node: nil)
                            fetcher: self;
                            yourself) ] ].
    ^ selectors
]
