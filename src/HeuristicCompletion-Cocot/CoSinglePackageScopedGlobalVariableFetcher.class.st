"
I am a fetcher looking for globals in an environment.
"
Class {
	#name : 'CoSinglePackageScopedGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'packages'
	],
	#category : 'HeuristicCompletion-Cocot-Experiments',
	#package : 'HeuristicCompletion-Cocot',
	#tag : 'Experiments'
}

{ #category : 'enumerating' }
CoSinglePackageScopedGlobalVariableFetcher >> entriesDo: aBlock [

	| string case closeClassNames keys | 
	string := filter completionString.
	case := NECPreferences caseSensitive.

	closeClassNames := packages first definedClasses collect: [ :each | each name ].
	
	"It is the job of the filter to filter
	no need to something like (closeClassName beginsWith: string caseSensitive: case) 
										ifTrue: ["
	closeClassNames do: [ :closeClassName | 
		aBlock value: (NECGlobalEntry contents: closeClassName node: astNode) ].
	
	"forced to copy the keys but let us try."
	keys := self systemNavigation keys.
	closeClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].
	"we could not use remove: ifAbsent: but this would hide something. 
	Because I do not get why the navigation should not contain the same objects than before."
	
	"Same as above this is the not the job of the fetcher to filter"
	keys do: [ :globalName | aBlock value: (NECGlobalEntry contents: globalName node: astNode) ]
		
	
]

{ #category : 'enumerating' }
CoSinglePackageScopedGlobalVariableFetcher >> packages: aCollection [

	packages := aCollection
]
