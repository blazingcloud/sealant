Best Practices Setting up New Project
==================

Prerequisites
-------------

### Applications
Check [Xcode](https://developer.apple.com/xcode/) installation with Command Line Tools and Simulator

Check [CoverStory](http://code.google.com/p/coverstory/) installation

### Command Line
Check [Homebrew](http://mxcl.github.com/homebrew/) installation

    brew doctor

Check git installation

    brew install git

Check [rvm](https://rvm.io) installation

    rvm list

Check ruby-1.9 alias pointing to one of available Ruby installations

    rvm alias list
    rvm alias create ruby-1.9 ruby-1.9.3-p<ANY_PATCH_LEVEL_AVAILABLE>
    
Install [WaxSim](https://github.com/blazingpair/WaxSim) to launch iOS Simulator from command line

    cd /tmp
    git clone https://github.com/blazingpair/WaxSim
    cd WaxSim
    xcodebuild install DSTROOT=/
    
### Setup project folder `<ProjectName>` and ruby gems
    
Create .rmvrc by running the following command

    rvm --rvmrc --create 1.9@<ProjectName>
    cat .rvmrc
    
Edit .rvmrc to uncomment section for bundler, result will look similar to this [.rvmrc](https://github.com/blazingcloud/sealant/blob/master/Testable/.rvmrc)

Copy Gemfile from example: [Gemfile](https://github.com/blazingcloud/sealant/blob/master/Testable/Gemfile)

    cat Gemfile

Load .rvmrc, which should install bundler and all gems listed in Gemfile

    cd .

Create New Xcode Project `<ProjectName>`
-------------

In Xcode create new project <ProjectName> with ARC, Unit Tests and Storyboard

### Install Cocoapods

Create Podfile with one pod for the main target:

>platform :ios, :deployment_target => '6.0'

>pod 'TestFlightSDK'

>link_with ['`<ProjectName>`']

Install pod and create workspace:

    pod install
    
This will create XCode `<ProjectName>` workspace. Open workspace in XCode and use it instead of opening project file.

### Create [App Specs](https://github.com/blazingcloud/sealant/blob/master/Testable/App Specs) target and folder for Specs

In Xcode 
*   rename `<ProjectName>Tests` target to "App Specs"
*   rename `<ProjectName>Tests.m` file to SanityTests.m, fix failing test as in [SanityTests.m](https://github.com/blazingcloud/sealant/blob/master/Testable/App Specs/SanityTests.m)
*   copy contents of `<ProjectName>Tests.h` file to SanityTests.m and delete `<ProjectName>Tests.h`
*   rename `<ProjectName>Test-Info.plist` to "App Specs-Info.plist" and change references to it in App Specs Target Build Settings
*   delete `<ProjectName>Tests/Localized.strings`

rename to `<ProjectName>Tests` file folder to "App Specs":

    mv <ProjectName>Tests "App Specs"
    
*   run App Specs in Simulator by pressing **⌘U** while main target `<ProjectName>` is selected,  SanityTests should pass.

Update Podfile with Kiwi, Hamcrest and Sealant pods exclusively for spec target:

>target :spec, :exclusive => true do

>    pod 'Kiwi', :podspec => 'https://gist.github.com/raw/4541144/latest_kiwi_with_hamcrest.podspec'

>    pod 'Sealant', :git => 'ssh://git@github.com/blazingcloud/sealant.git'

>    link_with ['App Specs']

>end

Update pods:

    pod update
    
In Xcode
*   remove FRAMEWORK_SEARCH_PATHS from App Specs target build settings, as it is defined by Pods
*   remove SenTestingKit.framework as it is included by Pods
*   run App Specs in Simulator by pressing **⌘U**, you might need to create XCode scheme with the same name for App Specs target

### Create [Unit Specs](https://github.com/blazingcloud/sealant/blob/master/Testable/Unit Specs) target and folder for Specs

In Xcode
*   select File > New > Target... 
*   pick Cocoa Unit Tests
*   name it "Unit Specs"
*   delete newly added Localized.strings

update Podfile to link specs exclusively with App Specs and Unit Specs:

>    link_with ['App Specs', 'Unit Specs']

instead of just 

>    link_with ['App Specs']

Update pods:

    pod update
    
In Xcode
*   remove FRAMEWORK_SEARCH_PATHS from Unit Specs target build settings, as it is defined by Pods
*   remove SenTestingKit.framework as it is included by Pods
*   remove Unit_Specs.h and Unit_Specs.m
*   Create [SanitySpec.m](https://github.com/blazingcloud/sealant/blob/master/Testable/Unit Specs/SanitySpec.m) with simple assertion and add it to Unit Specs target
*   run Unit Specs in Simulator by pressing **⌘U**, you might need to create XCode scheme with the same name for Unit Specs target
*   run Unit Specs and App Specs in Simulator, the SanitySpec should pass
*   in Xcode Manage Schemes menu
 *   create Xcode scheme for App Specs target with default name `App Specs`
 *   mark main target and test targets as Shared
 *   hide Pods schemes
 *   edit main target scheme, select Test step and add Unit Specs to existing App Specs, so when you run tests on main target it launches both Unit Specs and App Specs

### Create [Integration Tests](https://github.com/blazingcloud/sealant/blob/master/Testable/Integration Tests) target with [KIF](https://github.com/square/KIF)

In Xcode
*   Duplicate `<ProjectName>` main target to Integration Tests
*   create folder Integration Tests
*   duplicate main target `<ProjectName>`-Info.plist to `Integration Tests Info.plist`
*   change Integration Tests target build settings to use `Integration Tests Info.plist`
*   change product name for Integration Tests to Tests

Add KIF pod to Podfile
>target :integration do
>    pod 'KIF'
>    link_with 'Integration Tests'
>end

Update pods:

    pod update
    
In Xcode
*   run Integration Tests in Simulator by pressing **⌘R**, you might need to create XCode scheme with the same name for Integration Tests target
*   continue setting up KIF with a sample scenario as described in https://github.com/square/KIF#example
*   or use this example [Integration Tests](https://github.com/blazingcloud/sealant/blob/master/Testable/Integration Tests)

### Setup CoverStory
In Xcode
*   Edit "Unit Specs" scheme by pressing **⌘<**
*   Edit Test step and add Post-action to run shell script

>osascript $PROJECT_DIR/Pods/Sealant/Scripts/ShowCoverage.applescript

*   Select Provide build settings from `<ProjectName>` target

### Add Rakefile
For the convenience of running tests from the command line
Customize example [Rakefile.rb](/blazingcloud/sealant/blob/master/Testable/Rakefile.rb) and save it in the workspace root directory

