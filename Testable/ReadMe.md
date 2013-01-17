Best Practices Setting up New Project
==================

Prerequisites
-------------

Check [Homebrew](http://mxcl.github.com/homebrew/) installation

    brew doctor

Check git installation

    brew install git

Check [rvm](https://rvm.io) installation

    rvm list

    rvm alias create ruby-1.9 ruby-1.9.3-p<ANY_PATCH_LEVEL_AVAILABLE>

Create .rmvrc

    rvm --rvmrc --create 1.9@<ProjectName>
    cat .rvmrc
    
Edit .rvmrc to uncomment section for bundler, result will look similar to this [.rvmrc](.rvmrc)

Copy Gemfile from example: [Gemfile](Gemfile)

    cat Gemfile

Load .rvmrc, which should install bundler and all gems listed in Gemfile

    cd .

Create New Project
-------------

In Xcode create new project <ProjectName> with ARC, Unit Tests and Storyboard

### [App Specs](App Specs)

In Xcode 
*   rename `<ProjectName>`Tests target to "App Specs"
*   rename <ProjectName>Tests.m file to SanityTests.m, fix failing test as in [SanityTests.m](App Specs/SanityTests.m)
*   rename <ProjectName>Test-Info.plist to "App Specs-Info.plist"
*   delete <ProjectName>Tests/Localized.strings
