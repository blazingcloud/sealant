Best Practices Setting up New Project
==================

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

Copy Gemfile from example: [Gemfile]

    cat Gemfile
