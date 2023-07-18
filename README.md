# YAMS - Yet Another Mission Script - DCS World

Mission scripting in DCS beyond anything fairly simple only leaves you with a handful of options these days, and those options dont really open the world of scripting to you. They can be difficult to understand because the documentation is hard to navigate. 

# Goals

The goal of this project is to provide a mission scripter a well documented set of tools with up to date examples, even if that set of tools is small to begin with.

Rather than solve every problem, the problems that get solved, should...

1. Be well documented, with clear examples
2. Have a low barrier to entry to achieve the goal of the feature
3. Yield a consistent syntax that allows the editor to fall into the 'pit of success' as much as possible
4. Minimize script dependencies on installation - must output a single script for consumption by mission editors

# Handcrafted Documentation

> :information_source: **Where are the docs?** [right here](https://seska451.github.io/yams) 

The documentation for this project is extremely important, as such I have made contribution to the documents a simple case of 
writing the docs inline with the code and running the build scripts. I have taken great care to make this visually clean, easily searchable, and most importantly, easy to contribute to.

The API Documentation is clearly marked and auto-generated from source code comments that support basic markdown features like quotes, formatting, code blocks, and tables.

Other documentation, like the [Getting Started Guide](https://yams-dcs.readthedocs.io/en/latest/getting-started/) is handcrafted, with images and markdown also.

# Contribution
If you do wish to contribute, firstly, thankyou for considering this project for your valuable time.

To respect that time well, there are some pre-requisites and ground rules to consider.
## Pre-requisites
This projects assumes you have the following ready to go:

- A working DCS World game accessible (not necessarily on the same machine)
- Lua 5.1
- Powershell
- Python 3.10+

## Submitting changes
Any ideas for change will come via the PR process, please fork this repository and submit a branch for PR review if you wish to suggest changes, ideally, having made an issue and discussed it first.

Changes need to be fully documented and tested before being committed to `main`. Please do not bring in external dependencies, unless there is a compelling reason to do so.
Remember that #4 design goal here is to minimize script dependencies.

## Process

The process is simple enough:
1. Make code changes
2. Run `.\build.ps1`
3. Push to your branch
4. Submit for PR.

The build script will do just enough to ensure there isn't any large mistakes going on. It will also start the 
documentation server locally for you to review your changes. If you change and save a markdown file,
it will hot reload it.

## DCS World Editing 'Nuances'

Unfortunately, DCS makes it fiddly to run & test scripts, making for a disjointed workflow.

Part of the issue is not being able to reload scripts at runtime. There may be a workaround for this that I am unaware of. If so, please open an issue and let me know.
