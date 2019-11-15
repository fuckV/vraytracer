# vRayTracer

Simple raytracer in [vlang](https://vlang.io), learning the language as I go along so plenty of poor design choices, some for educational purposes. Based on [Ray Tracing in One Weekend](https://github.com/RayTracing/raytracinginoneweekend).

### Current output

![raytrace output](output.png)

Output is ppm but this is converted with imagemagick `convert output.ppm output.png`

### Building & Running use msvc

Compile with `v.exe -o bin/raytrace.exe -cc msvc raytrace.v`
Run with `raytrace.exe > output.ppm`
Argument:
--help `Show usage information`
--width `The width of the generated image,default 1920`
--height `The height of the generated image,default 1080`
--rays `The number of rays raytraced for each pixel of the image,default 1000`
--bouncedepth `The maximum amount of bounces the rays are allowed to do,default 50`

### Todo

* Code is a complete and utter mess.
  - Move Ray into module
  - Ray tracer module
* Take scene input from file
* Camera pos/fov
* Focal distance

#### Waiting on vlang for 
* Use Interfaces once working
* Use None instead of error once working
* Ensure overloading is used everywhere once working //TODO

### Complete

* PPM output
* Fuzz
* Albedo
* Reflection
* Scattering
* Lambertian material
* Metal material
* Dialectric material
* Command line arguments to image size (thanks [spytheman](https://github.com/spytheman).)
