"
I am a fetcher looking for globals in an environment.
"
Class {
	#name : 'CoPackageScopedGlobalVariableFetcher',
	#superclass : 'CoGlobalFetcher',
	#instVars : [
		'packages',
		'completionClass'
	],
	#category : 'HeuristicCompletion-Cocot-PackageScope',
	#package : 'HeuristicCompletion-Cocot',
	#tag : 'PackageScope'
}

{ #category : 'accessing' }
CoPackageScopedGlobalVariableFetcher >> completionClass [

	^ completionClass
]

{ #category : 'accessing' }
CoPackageScopedGlobalVariableFetcher >> completionClass: anObject [

	completionClass := anObject
]

{ #category : 'enumerating' }
CoPackageScopedGlobalVariableFetcher >> entriesDo: aBlock [

	| string case closeClassNames keys organizer packageNamePart friendClassNames friendPackageNames | 
	completionClass isNil
		ifTrue: [
				"can we call another fetcher?" 
					^ self systemNavigation
							allGlobalNamesStartingWith: filter completionString
							do: [ :e | aBlock value: (NECGlobalEntry contents: e node: astNode) ]
							caseSensitive: (NECPreferences caseSensitive) ].
	
	string := filter completionString.
	case := NECPreferences caseSensitive.
	organizer := completionClass package organizer.

	"First package level "
	closeClassNames := completionClass package definedClasses collect: [ :each | each name ].
	
	"It is the job of the filter to filter
	no need to something like (closeClassName beginsWith: string caseSensitive: case) 
										ifTrue: ["
	closeClassNames do: [ :closeClassName | 
		aBlock value: (NECGlobalEntry contents: closeClassName node: nil) ].
	
	"Package of the project e.g that starts with the same tag bfore the - 
	HeuristicCompletion-Cocot -> HeuristicCompletion"
	
	self flag: #toAskGuille.
	"Why if the test ask for two and get two classes putting a halt here stops the program. 
	I thought it would be never executed in this scenario."
	
	
	packageNamePart := completionClass package name copyUpTo: $-.
	
	friendClassNames := OrderedCollection new. 
	friendPackageNames := organizer packageNames asOrderedCollection.
	friendPackageNames remove: completionClass package name. 
	friendPackageNames do: [ :packageName | (packageNamePart, '*' match: packageName)
			ifTrue: [ 
				friendClassNames addAll: ((organizer packageNamed: packageName ifAbsent: [ ])definedClasses collect: [ :each |each name ])]]. 
	
	friendClassNames do: [ :closeClassName | 
		aBlock value: (NECGlobalEntry contents: closeClassName node: nil) ].
	
	
	"Global"
	"forced to copy the keys but let us try."
	keys := self systemNavigation environment keys asOrderedCollection.
	closeClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].
	friendClassNames do: [ :e | keys remove: e ifAbsent: [ ] ].
	"we could not use remove: ifAbsent: but this would hide something. 
	Because I do not get why the navigation should not contain the same objects than before."
	
	"Same as above this is the not the job of the fetcher to filter.
	This is a pity because we cannot reuse the logic of systemNavigation because we should not 
	modify the global environment."
	keys do: [ :globalName | aBlock value: (NECGlobalEntry contents: globalName node: astNode) ]
		
	
]

{ #category : 'enumerating' }
CoPackageScopedGlobalVariableFetcher >> packages: aCollection [

	packages := aCollection
]
