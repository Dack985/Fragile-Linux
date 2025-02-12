Fragile Linux: A Modified Fork of Suicide Linux

This project is a fork of the official Suicide Linux (originally by tiagoad), which I’ve modified and renamed Fragile Linux. The goal behind this modification is to create an experience where users can make a few mistakes without the system immediately self-destructing, but still retain the fear-driven atmosphere that Suicide Linux provides.

What’s New in Fragile Linux
More Lives: Unlike the original, users now have 5 lives before the system deletes itself. This allows a bit of leniency, but the sense of fragility is still maintained.
Life Counter: I've implemented a feature that prints out the number of remaining lives to the user whenever they make an incorrect command. This keeps them aware of how many mistakes they have left before the system’s inevitable demise.
Bashrc Banner: I’ve added a custom banner to the Bash shell for a more immersive experience when users open a terminal.
Future Improvements
While the current version is functional, I plan to expand it further in the future. At the moment, the main issue is that the counter is stored only within the session, meaning the counter will reset every time a user opens a new terminal. In the future, I intend to store the counter in a persistent file, preventing users from bypassing the countdown by opening new terminal sessions.

Additional Features
I’ve also included a few additional echo statements throughout the program to add more personality and flair to the user experience. These tweaks help enhance the program's overall impact.

