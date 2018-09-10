# FALLING WORDS

## Problem Statement

### Idea

The task is to write a small language game. The player will see a word in language „one“ on the screen. While this word is displayed, a word in language „two“ will fall down on the screen. The player will have to choose if the falling word is the correct translation or a wrong translation. The player needs to answer, before the word reaches the bottom of the screen. A counter that gives the player feedback should be included.

### Room for creativity

It is up to the applicant to implement how the player chooses correct or wrong. There must be a clear scenario how the game ends, the criteria for that is up to the candidate. In what way correct/wrong/no answer is counted can also be freely chosen, but there must be some visual feedback.

## Solution

The application implements the solution using Swift 4.0 and a deployment target 11.2

It uses the MVVM pattern along with these libraries

- RxSwift
- RxCocoa
- RealmSwift
- Alamofire
- RxAlamofire

## Setting up

Run `pod install` from the root directory.

Then open `FallingWords.xcworkspace` to view the project

## Information

### Time invested

This project took about 8 hours to setup and implement

### Time distribution

- **Concept**  20%
- **Models**  5%
- **Controllers**  5%
- **View Models**  50%
- **View State**  10%
- **Stores**  5%
- **Helpers**  5%

### Decisions made to solve certain aspects of the game

- To make the animation behave properly if an answer was pressed mid way between the animation, I had to stop the animation which triggerred the `complete` callback. This was called anyhow and I need to access the current state of the ViewModel. Which meant I had to directly access it via the ViewModel.

### Decisions made because of restricted time

- I save all the items using Realm to a DB. May be not call the API request and call it only x amount of time has passed.
- When a button is clicked, I disable all the buttons. This could have been done better with Rx
- Restart once finished is missing
- The score count does not immediately. It is only shown updated on the next question
- No tests

### What would be the first thing to improve or add if there had been more time

- Write tests
- Restart Game once finished
- Performance improvements
