'From Squeak3.9 of 7 November 2006 [latest update: #7067] on 30 November 2008 at 8:43:43 am'!
Object subclass: #DayList
	instanceVariableNames: 'days start end current'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RLB3'!

!DayList methodsFor: 'public' stamp: 'rlb3 2/10/2008 04:24'!
listDays
	| isStarted |
	isStarted := false.
	[current = end and: isStarted]
		whileFalse: [current := days next.
			(current = start)
				ifTrue: [isStarted := true].
			(isStarted)
				ifTrue: [Transcript show: current].
			(current ~= end and: isStarted)
				ifTrue: [Transcript show: $,;
						 space].
			(days peek isNil)
				ifTrue: [days reset]].
	Transcript cr!
]style[(8 3 10 4 9 4 5 4 7 3 3 6 9 17 7 4 4 11 7 3 6 14 9 4 4 7 10 14 10 7 7 7 7 4 3 6 9 15 10 7 2 21 4 26 4 11 10 3)f2b,f2,f2cblue;i,f2,f2cblue;i,f2,f2cmagenta;,f2,f2cmagenta;,f2,f2cmagenta;,f2,f2cblue;i,f2,f2cmagenta;,f2,f2cmagenta;,f2,f2cmagenta;,f2,f2cmagenta;,f2,f2cblue;i,f2,f2cmagenta;,f2,f2cblue;i,f2,f2cmagenta;,f2,f2cmagenta;,f2,f2cmagenta;,f2,f2cmagenta;,f2,f2cblue;i,f2,f2cmagenta;,f2,f2c255152000,f2,f2cmagenta;,f2,f2cmagenta;,f2,f2cmagenta;,f2! !

!DayList methodsFor: 'public' stamp: 'rlb3 2/9/2008 23:13'!
start: startDay end: endDay 
	start := startDay.
	end := endDay.! !


!DayList methodsFor: 'initialize-release' stamp: 'rlb3 2/10/2008 04:04'!
initialize
	days := #('sun' 'mon' 'tues' 'wed' 'thurs' 'fri' 'sat' ) readStream.
	start := 'sun'.
	end := 'sat'.
	current := ''! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DayList class
	instanceVariableNames: ''!

!DayList class methodsFor: 'examples' stamp: 'rlb3 2/10/2008 14:54'!
example1
	| d |
	Transcript open.
	d := self new.
	d start: 'wed' end: 'tues'.
	d listDays!
]style[(8 3 2 4 16 2 1 4 4 7 1 8 5 6 6 3 1 9)f2b,f2,f2cblue;i,f2,f1,f2,f2cblue;i,f2,f2cmagenta;,f2,f2cblue;i,f2,f2c255152000,f2,f2c255152000,f2,f2cblue;i,f2! !
