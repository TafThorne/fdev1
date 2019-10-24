# fdev1
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FTafThorne%2Ffdev1.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2FTafThorne%2Ffdev1?ref=badge_shield)

Dockerfile that sets up a basic gcc Debian environment with a number of
libraries configured.

The Docker Image is listed on Docker Hub:
https://hub.docker.com/r/tafthorne/fdev1/

To pull the image:

 docker pull tafthorne/fdev1

An overview of the included libraries is given below.

## Using This Image
The expected way to use this image is to navigate to the working directory
where your source code resides and start an interactive session.

  docker run -ti --volume="${PWD}:/shared" -w "/shared" tafthorne/fdev1

Then within the running container you can call make or gcc as if it were a
native tool.  The libraries added to this image will be in the global include
path.

## GNU GCC

The GNU Compiler Collection is a compiling system that supports several
languages.  This project focuses more on the C and C++ usage.

For details about the base image for this project please see either the
project page or the Docker Hub entry.
* https://github.com/docker-library/gcc/
* https://hub.docker.com/_/gcc/

## CppUTest

CppUTest is a unit testing and mocking framework for C/C++.  For further
details please see their project page.
* http://cpputest.github.io/

## spdlog

spdlog is a fast, header only C++ logging library.  For further details please
see their project page.
* https://github.com/gabime/spdlog

## Contributing

Please see the notes in CONTRIBUTING.md.



## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FTafThorne%2Ffdev1.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2FTafThorne%2Ffdev1?ref=badge_large)