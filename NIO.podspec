Pod::Spec.new do |spec|
    spec.name           = "NIO"
    spec.version        = "2.1.0"
    spec.summary        = "Elegant DAO implementation written in Swift"

    spec.homepage       = "https://github.com/incetro/NIO.git"
    spec.license        = "MIT"
    spec.authors        = { "incetro" => "incetro@ya.ru" }
    spec.requires_arc   = true

    spec.ios.deployment_target     = "10.3"
    spec.osx.deployment_target     = "10.12"
    spec.watchos.deployment_target = "3.0"
    spec.tvos.deployment_target    = "10.2"

    spec.source                 = { git: "https://github.com/incetro/NIO.git", tag: "#{spec.version}"}
    spec.source_files           = "Sources/Nio/**/*.{h,swift}"

    spec.dependency "Reflex"
    spec.dependency "Monreau"
    spec.dependency "Transformer"
end