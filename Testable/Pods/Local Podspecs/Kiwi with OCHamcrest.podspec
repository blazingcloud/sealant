Pod::Spec.new do |s|
  s.name            = 'Kiwi with OCHamcrest'
  s.version         = '1.1.1.dev'
  s.summary         = 'BDD tools for iOS - Kiwi integrated with OCHamcrest matchers'
  s.homepage        = 'https://github.com/allending/Kiwi'
  s.authors         = { 'Allen Ding' => 'allen@allending.com', 'Luke Redpath' => 'luke@lukeredpath.co.uk' }
  s.license         = { :type => 'MIT', :file => 'License.txt' }
  s.source          = { :git => 'https://github.com/allending/Kiwi.git'}
  s.source_files    = FileList['Classes/*.{h,m}'].exclude(/KWStringPrefixMatcher/).exclude(/KWStringContainsMatcher/)
  s.framework       = 'SenTestingKit'
  # HC_SHORTHAND is defined for project test target for naming convenience
  s.xcconfig        = { 
    'FRAMEWORK_SEARCH_PATHS' => '"$(SDKROOT)/Developer/Library/Frameworks" "$(DEVELOPER_LIBRARY_DIR)/Frameworks"',
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) HC_SHORTHAND'
  }
  # Cocoapods use above xcconfig to compile this Pod as well as project test target that uses this Pod
  # we need to undefine HC_SHORTHAND to avoid compiler warnings when building Pod static library
  s.prefix_header_contents = '#undef HC_SHORTHAND'
  s.dependency 'OCHamcrest'
  def s.post_install(target)
    # Fix an Hamcrest integration by using Hamcrest matcher, instead of the minimal version of matcher protocol
    header = (pod_destroot + 'Classes/KWHCMatcher.h')
    header_contents = File.read(header)
    header_contents.gsub!(/@protocol.+@end/m,'#import <HCMatcher.h>')
    File.write(header, header_contents)
    # Remove uses of minimal version of matcher protocol
    header = (pod_destroot + 'Classes/Kiwi.h')
    header_contents = File.read(header)
    header_contents.gsub!(/#import "KWStringPrefixMatcher.h"/,'')
    header_contents.gsub!(/#import "KWStringContainsMatcher.h"/,'')
    File.write(header, header_contents)
  end
end
