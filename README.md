Silhouette in Unity3D
=====================

So this (probably outrageous) method involves drawing the silhouette at 50% gray before everything on a black background, then drawing the ground, multiplying it by OneMinusDstColor, then drawing everything else. The problem with this is that the background has to be cleared to black first, so you can't use a skybox. However, you can draw the skybox after the terrain (but behind the terrain) using a custom skybox shader.

