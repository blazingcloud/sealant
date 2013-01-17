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

Create New Project `<ProjectName>`
-------------

In Xcode create new project <ProjectName> with ARC, Unit Tests and Storyboard

### Create [App Specs](App Specs) target and folder

In Xcode 
*   rename `<ProjectName>Tests` target to "App Specs"
*   rename `<ProjectName>Tests.m` file to SanityTests.m, fix failing test as in [SanityTests.m](App Specs/SanityTests.m)
*   rename `<ProjectName>Test-Info.plist` to "App Specs-Info.plist"
*   delete `<ProjectName>Tests/Localized.strings`

rename to `<ProjectName>Tests` file folder to "App Specs"


### Install Cocoapods

Create Podfile with one pod for the main target:

>platform :ios, :deployment_target => '6.0'

>pod 'TestFlightSDK'

>link_with ['`<ProjectName>`']

Install pod and create workspace:

    pod install
    
This will create XCode `<ProjectName>` workspace. Open workspace in XCode and use it instead of opening project file.

Update Podfile with Kiwi, Hamcrest and Sealant pods exclusively for spec target:

>target :spec, :exclusive => true do

>    pod 'Kiwi with OCHamcrest', :podspec => 'https://gist.github.com/raw/4541144/latest_kiwi_with_hamcrest.podspec'

>    pod 'Sealant', :git => 'ssh://git@github.com/blazingcloud/sealant.git'

>    link_with ['App Specs']

>end

Update pods:

    pod update
    
In Xcode
*   remove FRAMEWORK_SEARCH_PATHS from App Specs target build settings, as it is defined by Pods
*   remove SenTestingKit.framework as it is included by Pods

### Create [Unit Specs](Unit Specs) target and folder

