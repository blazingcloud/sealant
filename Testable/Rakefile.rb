require 'rubygems'
require 'xcodebuild'
require 'rake/clean'

projectName = "Testable"
workspaceName = "Testable"
workspaceFile = "#{workspaceName}.xcworkspace"
installationFolder = "/tmp/#{projectName}.dst"

CLOBBER.include(installationFolder)

namespace "xc" do
    XcodeBuild::Tasks::BuildTask.new(namespace = projectName) do |t|
        t.scheme = projectName
        t.configuration = "Release"
        t.sdk = "iphoneos"
        t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
        t.workspace = workspaceFile
    end
    
    XcodeBuild::Tasks::BuildTask.new(namespace = :all) do |t|
        t.scheme = "All"
        t.configuration = "Debug"
        t.sdk = "iphonesimulator"
        t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
        t.workspace = workspaceFile
    end
    
    XcodeBuild::Tasks::BuildTask.new(namespace = :integration) do |t|
        t.scheme = "Integration Tests"
        t.configuration = "Debug"
        t.sdk = "iphonesimulator"
        t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
        t.workspace = workspaceFile
    end
    
    XcodeBuild::Tasks::BuildTask.new(namespace = :test) do |t|
        t.scheme = "Unit Specs"
        t.add_build_setting("TEST_AFTER_BUILD","YES")
        t.configuration = "Debug"
        t.sdk = "iphonesimulator"
        t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
        t.workspace = workspaceFile
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

task :clean => ["xc:all:clean", "xc:#{projectName}:clean"]

task :int => "integration"

namespace "integration" do
    
    kifBundlePath = "#{installationFolder}/Applications/Tests.app"
    
    task :resetSimulator do
        system "osascript 'Pods/Sealant/Scripts/reset-simulator.applescript'"
    end
    
    runOffline = ENV["RUN_KIF_TESTS_OFFLINE"]
    
    task :runOnSimulator do |t, args|
        system "waxsim -a"
        system "waxsim -e RUN_KIF_TESTS_OFFLINE=#{runOffline} '#{kifBundlePath}'"
    end
    
    task :run => ["resetSimulator", "runOnSimulator"]
end

desc "or int, Run Integration Tests in iOS Simulator,\n\t\t\t\t  RUN_KIF_TESTS_OFFLINE=0 to exclude offline run"
task :integration => ["developer", "xc:integration:install", "integration:run"]
