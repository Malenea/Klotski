# Klotski

A basic integration of an algorithm to solve a Klotski

## Getting Started

Clone the project and run pod install to install the necessary frameworks to run the project.

### Prerequisites

This project is in swift and is run through xcode.

### Installing

Just clone the repository

```
$> git clone https://github.com/malenea/Klotski
```

Then run pod install to install the required frameworks, if it's your first time working with Cocoapods, install it first

```
$> sudo gem install cocoapods

$> pod install
```

## What is the game about

### Game explanations

Basically the Kloski is a puzzle game with different shapes and size blocks on a 4 x 5 board.
The board looks like this:

```
*----*
|ABBC|     Each letter identifies a block, so the block A is a 1 width, 2 height block,
|ABBC|     the G block is a single 1 width, 1 height block.
|DEEF|
|DGHF|     There's a 2 spaces exit at the bottom of the board, only the 2 width, 2 height
|I  J|     B block can go through it.
*-  -*
```

The goal is to bring the 2 width, 2 height block to the bottom where the exit is.

### Program explanations

The idea here is to check every single move per layout. A layout here is a board with its blocks
in a defined position.

So the initial layout would be the following:

```
*----*
|ABBC|
|ABBC|
|DEEF|
|DGHF|
|I  J|
*-  -*
```

If we move a single block, let's say J to the left, we obtain a new layout:

```
*----*
|ABBC|
|ABBC|
|DEEF|
|DGHF|
|I J |
*-  -*
```

So we create a tree, starting from the initial layout and we then expand the
branches with all the possible moves into new layouts.
So from the initial layout that would give us:

```
                *----*
                |ABBC|
                |ABBC|
                |DEEF|
                |DGHF|
                |I  J|
                *-  -*
                Initial

*----*     *----*     *----*     *----*
|ABBC|     |ABBC|     |ABBC|     |ABBC|
|ABBC|     |ABBC|     |ABBC|     |ABBC|
|DEEF|     |DEEF|     |DEEF|     |DEEF|
|DGHF|     |D HF|     |DG F|     |DGHF|
| I J|     |IG J|     |I HJ|     |I J |
*-  -*     *-  -*     *-  -*     *-  -*
I Right    G Down     H Down     J Left
```

Here we have 4 possible moves, which gives us 4 layouts.
We save each layout's configuration to keep a track of which layout has
already been visited. Because if we ever find one of the previous layouts
that would mean that we're just going round in circles, and thus doing
useless moves to get back to where we started.

The easiest way to do that would be to create an array of the visited layouts
and see if upon creating a new layout, it has already been visited.

```
var visitedLayouts: [String] = ["ABBCABBCDEEFDGHFI  J", n]

visitedLayouts.contains(myNewLayout)
```

Very simple but not very efficient as the more layouts you save, the more
iterations you need to make through the array to compare them.

So let's just create a hash set from it and find them with indexes.

```
var visitedLayouts: [String: Bool] = [:]

visitedLayouts["ABBCABBCDEEFDGHFI  J"] = true

var visitedLayouts["ABBCABBCDEEFDGHFI  J"] != nil {
  // This layout was already visited
}
```

Then we'll just loop through each layout, checking each possible movement for
each block.

If ever one of the branches leads to a dead end (meaning that no block can move
without being the copy of a previously visited layout) then we just "kill" that
branch. And we proceed with treating the others.

So long story short, we dig through the layouts, trying each solution.

For each iteration we check if the big block is in a winning position, meaning
just in front of the exit and if it's the case, we've got our solution.

Now all that's left is to take the solution's layout and go back all the way
back up to have the path.

To do so, we save each layout in a tree node, basically looking like this:

```
class LayoutNode<Layout> {
    var layout: Layout
    var children: [LayoutNode] = []
    weak var parent: LayoutNode?

    // MARK: Init functions
    init(_ layout: Layout) {
        self.layout = layout
    }
}
```

And voila...
We then display the result.

### Approach and things to be improved

Those are just ideas I've come across and didn't get time to test and
implement yet.

- Algorithm can be improved by threading it, basically the idea would be to
create a thread pool and allocate workers to share the search, allowing us to
divide the time it takes to find a solutions

- I've tried at first to create a full board that would be a double array
of nodes, which are basically classes that contain both the block and the
methods to know if the block can go in any direction. I've replaced it with
just methods to search for a block's neighbour from a double array of enum
which would represent the types of block and comparing it with a double array
of strings that are ids, to not mistake 2 similar blocks.
I'm sure though that a more effective and more readable way can be found.

- I didn't want to lose too much time on UI, so I just basically implemented
a page controller that would contain all the views of the different steps to
the solution and display them in the correct order with a Timer in a video
player kind of.
But since we have the methods, the board, it would be pretty easy to implement
a real board with blocks that move and constraints.

## Authors

* **Olivier Conan** - [Malenea](https://github.com/Malenea)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
