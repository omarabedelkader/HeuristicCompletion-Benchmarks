Class {
	#name : 'CoPackageScopedGlobalSelectorFetcher',
	#superclass : 'CoGlobalSelectorFetcher',
	#instVars : [
		'package',
		'completionClass',
		'organizer'
	],
	#classVars : [
		'Dependencies'
	],
	#category : 'ExtendedHeuristicCompletion-PackageScope-Message',
	#package : 'ExtendedHeuristicCompletion-PackageScope-Message'
}

{ #category : 'accessing' }
CoPackageScopedGlobalSelectorFetcher class >> computeDependenciesOf: aPackageName [
	
	^ StDependencyChecker new dependenciesOf: aPackageName
]

{ #category : 'accessing' }
CoPackageScopedGlobalSelectorFetcher class >> dependenciesOf: aPackageName [

	^ self dependencyCache at: aPackageName ifAbsentPut: [ self computeDependenciesOf: aPackageName ]
]

{ #category : 'accessing' }
CoPackageScopedGlobalSelectorFetcher class >> dependencyCache [

	^ Dependencies ifNil: [ Dependencies := Dictionary new ]
]

{ #category : 'accessing' }
CoPackageScopedGlobalSelectorFetcher class >> resetCache [
	<script>
	Dependencies := nil
]

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

{ #category : 'enumerating' }
CoPackageScopedGlobalSelectorFetcher >> dependenciesOf: aString [
	
	^ self class dependenciesOf: aString
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
