require(File.join(ENV['gubg'], 'shared'))
include GUBG

task :default => :help
task :help do
    puts("The following tasks can be specified:")
    puts("* declare: installs bash, vim and git scripts to GUBG.shared")
    puts("* define: creates symbolic link to the installed vim scripts and .inputrc")
end

task :declare do
    build_ok_fn = 'gubg.build.ok'
    install_ok_fn = 'gubg.install.ok'
    Dir.chdir(shared_dir('extern')) do
        git_clone('https://github.com/nodejs', 'node') do
            if !File.exist?(build_ok_fn)
                sh './configure'
                sh 'make -j 8'
                sh "touch #{build_ok_fn}"
            end
            if !File.exist?(install_ok_fn)
                link_unless_exists(File.join(Dir.pwd, 'out', 'Release', 'node'), shared('bin', 'node'))
                link_unless_exists(File.join(Dir.pwd, 'deps','npm','bin','npm'), shared('bin', 'npm'))
                publish('deps/npm/bin', pattern: %w[npm* *.js], dst: 'bin/node_modules/npm/bin')
                publish('deps/npm/node_modules', pattern: '**/*', dst: 'bin/node_modules')
                publish('deps/npm/lib', pattern: '**/*', dst: 'bin/node_modules/npm/lib')
                publish('deps/npm', pattern: '*.json', dst: 'bin/node_modules/npm')
                sh "touch #{install_ok_fn}"
            end
        end
    end
end

task :define => :declare do
end

task :test do
end
