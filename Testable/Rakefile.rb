require 'rubygems'
require 'xcodebuild'
require 'rake/clean'
CLOBBER.include('/tmp/Testable.dst/')

namespace "xc" do
    XcodeBuild::Tasks::BuildTask.new(namespace = :Testable) do |t|
        t.scheme = "Testable"
        t.configuration = "Release"
        t.sdk = "iphoneos"
        t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
        t.workspace = "Testable.xcworkspace"
    end
    
    XcodeBuild::Tasks::BuildTask.new(namespace = :all) do |t|
        t.scheme = "All"
        t.configuration = "Debug"
        t.sdk = "iphonesimulator"
        t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
        t.workspace = "Testable.xcworkspace"
    end
    
    XcodeBuild::Tasks::BuildTask.new(namespace = :integration) do |t|
        t.scheme = "Integration Tests"
        t.configuration = "Debug"
        t.sdk = "iphonesimulator"
        t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
        t.workspace = "Testable.xcworkspace"
    end
    
    XcodeBuild::Tasks::BuildTask.new(namespace = :test) do |t|
        t.scheme = "Unit Specs"
        t.add_build_setting("TEST_AFTER_BUILD","YES")
        t.configuration = "Debug"
        t.sdk = "iphonesimulator"
        t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
        t.workspace = "Testable.xcworkspace"
    end
end

desc "Show current Developer directory"
task :developer do
    system "echo current Developer directory: `xcode-select -print-path`"
    system "xcodebuild -showsdks | grep iphone"
    system "xcodebuild -list -workspace *.xcworkspace"
    system "xcodebuild -list"
end

desc "Run unit specs"
task :default => ["developer", "xc:test:build"]

task :clean => ["xc:all:clean", "xc:Testable:clean"]

task :int => "integration"

namespace "integration" do
    
    appDist = '/tmp/Testable.dst/Applications/Tests.app'
    
    task :resetSimulator do
        system "osascript 'Pods/Sealant/Scripts/reset-simulator.applescript'"
    end
    
    runOffline = ENV["RUN_KIF_TESTS_OFFLINE"]
    
    task :runOnSimulator do |t, args|
        system "waxsim -a"
        system "waxsim -e RUN_KIF_TESTS_OFFLINE=#{runOffline} '#{appDist}'"
    end
    
    task :run => ["resetSimulator", "runOnSimulator"]
end

desc "or int, Run Integration Tests in iOS Simulator,\n\t\t\t\t  RUN_KIF_TESTS_OFFLINE=0 to exclude offline run"
task :integration => ["developer", "xc:integration:install", "integration:run"]
