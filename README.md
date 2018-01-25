# rl_roadFighter
Matlab code for the 2017/18 UEDIN course on Reinforcement Learning (http://www.inf.ed.ac.uk/teaching/courses/rl/index.html)

INTRODUCTION:
-------------

The code in this repository is inspired by the classic 80's computer game "Road Fighter" (https://www.youtube.com/watch?v=6ZzTIbj5oK4), and the similar application presented in the work by Benjamin Rosman and Subramanian Ramamoorthy (2010) titled "A Game-Theoretic Procedure for Learning Hierarchically Structured Strategies" (http://homepages.inf.ed.ac.uk/s0896970/papers/icra10.pdf). Much like the old analogue games (https://www.youtube.com/watch?v=Gv50niofauU) on which Road Fighter might have been based, the Markov Decision Processes you can model with this tool-set involve a user controlled "car" rolling over a terrain as the latter is pulled downwards. The aim of the user, as we define it, would be to reach the end of the level with the minimum damage to the car. Preventing us from this are unpaved pieces of terrain and other, stationary, cars.

Since the car is always in motion, the user's choices of action at each time-step are restricted to going "left and up", "up", or "right and up". Transitions can be stochastic, so the user cannot always predict where the car's next location will be, though it will depend on their current state and the action they took. Though the original game did not feature a discrete time and state-space (arguably), we consider a grid-world, with a discrete number of rows and columns. The columns are numbered from 1, starting on the left-hand side. The rows are numbered from 1, starting at the top of the map. A time-step will signify the time it takes to transition from one discrete state to the next.

The car starts at the bottom row (with index equal to the number of rows), in any one of the columns (randomly selected or predefined), and moves up a single row at each time-step, in the direction informed by the user's choice. The possible directions are: 1 column to the left (column index -1); the same column (column index remains unchanged); and 1 column to the right (column index +1). If the car were to transition outside the boundaries of the map (by, for example, going up-left in column 1) this will instead result in the column index remaining the same in the next time-step (we can't move outside the map). The episode ends when we reach the top row (with an index of 1), which will always be in a number of time-steps equal to the number of rows minus 1.

As the car travels up the grid map, it will receive rewards based on the state it lands onto (so the reward function depends only on the next state). The reward experienced from moving into a discrete state on the grid, depends only on the type of terrain at that state (paved road, or unpaved) and on whether there is a car located there. If the car crashes into an environment car on unpaved road, it will be penalised with the sum of the negative reward for driving onto unpaved road and for crashing with another car. Crashing into a car does not affect transitions, and does not act as an absorbing state.

We will be interested in computing optimal policies for a specific grid-world, initially, and a class of problems (random maps and or environment cars), later on in the course.



GETTING STARTED:
----------------

Download or, preferably, git clone (details on git clone here: https://help.github.com/articles/cloning-a-repository/) the repository onto your computer. I will announce any potential changes to the code on Piazza, though.

Assuming you have Matlab set up and running, add the main folder ("RL_roadWarrior") and all subfolders to the Matlab path. You can do this at the start of every session by right clicking on the main folder and selecting "Add to Path -> Selected Folders and Subfolders", by setting up a start file and restarting Matlab (https://uk.mathworks.com/help/matlab/matlab_env/add-folders-to-matlab-search-path-at-startup.html?requestedDomain=true), or by manually editing the path (https://uk.mathworks.com/help/matlab/matlab_env/add-remove-or-reorder-folders-on-the-search-path.html).

Make sure that you don't have other files on the path with the same name as files in the repository, since this can occasionally cause the wrong file to be called.

Matlab uses indexing that starts from number 1, rather than 0.

Generally, there are 3 kinds of files here, all of them together commonly referred to as m-files ('.m'): functions, classes, and scripts. You will typically use functions for most input/output operations, and use classes to instantiate the rare object (our only class here is 'GridMap'). Use scripts to run a sequence of operations. A script can call another script, though care needs to be taken to maintain consistency between declared variables. For more information on getting started with Matlab, have a look at the resources on the course page lecture list (http://www.inf.ed.ac.uk/teaching/courses/rl/lecturelist.html).

Before going through the different files in the repository, run the m-file script "startHere.m". This is an example of using the code in the repository. If everything is properly set up, you should see some output on the Matlab command window, as well as a demonstration of the 'car' moving in an example grid-world. At the end of the demonstration, the whole map will be printed on screen, along with the car's trajectory. Your car, its starting square, and its trajectory, are marked with a turquoise square, rhombus, and small circles, respectively. Environment cars are marked with red rhombuses. The paved road is white, while the unpaved squares are brown-green.



startHere.m:
----------

The file begins by defining some constants (really just variables which we don't intend to change) for the 3 available actions. It then proceeds to define some size parameters for an examined test case, our discount factor \gamma, and the reward values. We further define the probability that our action is ignored and a uniformly random next state is selected (with a caveat for transitions outside the map), and the probability, for each row, that no environment car is randomly generated on that row.

Next, we call "generateMiniMaps" which creates a number of GridMaps from their templates in "defineMDP/miniMaps". These are used as building blocks to generate a test scenario by randomly stacking one on top of the other. The commented section below that command can be interchanged with it to let you experiment with a custom map.

We proceed to set the time-step to 0, and give examples of episode length, and accessing the car's/agent's start location in a GridMap object.

Matrices are then generated for the environment car locations, and the MDP's reward function. Note that the states are being defined by the coordinates of the grid-square on the map.

Combining "viewableGridMap" with "refreshScreen" is what lets us view only a few lines above the car as it advances forward.

The last part of the script repeatedly generates a random action and calls "actionMoveAgent" to get the reward signal and next state, while keeping track of the current time-step and saving a history of our trajectory for printing.



GENERAL LAYOUT:
---------------

The code can be broadly broken down into 4 categories, each allocated a folder in the repository: defining an MDP ("defineMDP"); interacting with an MDP ("interactMDP"); print statements ("screenOutput"); and utilities ("utilities"). The latter contains the function "randomWeightedSelect" for sampling indices given a probability vector.