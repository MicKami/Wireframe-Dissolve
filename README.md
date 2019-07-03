# Wireframe-Dissolve
A really cool shader effect prototype made in Unity.

It is using geometry shader stage to calculate wireframe and triangle position.
We then use the specified radius and distance to our Empty GameObject to compute alpha of a final pixel.

![](https://i.imgur.com/RXHlHk2.gif)

To try it yourself download the project, open Unity and try to move the Empty GameObject and tweak the parameters on the Plane itself.

### Note:
- It was made in unity 2018.3.6 and is not guaranteed to work in any other version.
- As geometry shaders dont really work with surface shaders and shadergraph there is no lighting, shadows etc support.
