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

    rvm alias create ruby-1.9 ruby-1.9.3-p<ANY_PATCH_LEVEL_AVAILABLE>
    
### Setup project folder `<ProjectName>` and ruby gems
    
Create .rmvrc by running the following command

    rvm --rvmrc --create 1.9@<ProjectName>
    cat .rvmrc
    
Edit .rvmrc to uncomment section for bundler, result will look similar to this [.rvmrc](.rvmrc)

Copy Gemfile from example: [Gemfile](Gemfile)

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

### Create [App Specs](App Specs) target and folder

In Xcode 
*   rename `<ProjectName>Tests` target to "App Specs"
*   rename `<ProjectName>Tests.m` file to SanityTests.m, fix failing test as in [SanityTests.m](App Specs/SanityTests.m)
*   rename `<ProjectName>Test-Info.plist` to "App Specs-Info.plist"
*   delete `<ProjectName>Tests/Localized.strings`

rename to `<ProjectName>Tests` file folder to "App Specs":

    mv <ProjectName>Tests "App Specs"

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
*   run App Specs in Simulator by Command-U, you might need to create XCode scheme with the same name for App Specs target

### Create [Unit Specs](Unit Specs) target and folder

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
*   Create [SanitySpec.m](Unit Specs/SanitySpec.m) with simple assertion
*   run Unit Specs in Simulator by Command-U, you might need to create XCode scheme with the same name for Unit Specs target
*   add [SanitySpec.m](Unit Specs/SanitySpec.m) to both targets: Unit Spec and App Spec
*   add [SanityTests.m](App Specs/SanityTests.m) to both targets: Unit Spec and App Spec
*   run Unit Specs and App Specs in Simulator

### [Integration Tests](Integration Tests)

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
*   run Integration Tests in Simulator by Command-R, you might need to create XCode scheme with the same name for Integration Tests target
*   continue setting up KIF with a sample scenario as described in https://github.com/square/KIF#example
*   or use this example [Integration Tests](Integration Tests)

### Setup CoverStory
In Xcode
*   Edit "Unit Specs" scheme by `⌘<`
*   Edit Test step and add Post-action to run shell script
>osascript $PROJECT_DIR/Pods/Sealant/Scripts/ShowCoverage.applescript
*   Select Provide build settings from `<ProjectName>` target

