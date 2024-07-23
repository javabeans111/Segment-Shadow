# Segment-Shadow
Segments on floor cast shadows

In Unity, to do point light shadow, there are 3 methods:
1. use 6 spot lights to simulate , expensive and not acurate;
2. use new point light shadow, expensive;
3. use fake shadow, this method is one of them;

The Core idea is to draw a segment on the floor, and test if the pixel is in the shadow.

The criteria is : if the pixel and the camera are on the opposite sides of each other.

Try opening SegmentShadow.unity, and dragging the "SphereCenter" gameobject around to see the effect.
