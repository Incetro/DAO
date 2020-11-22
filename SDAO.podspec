Pod::Spec.new do |spec|
    spec.name           = "SDAO"
    spec.version        = "2.3.1"
    spec.summary        = "Elegant DAO implementation written in Swift"

    spec.homepage       = "https://github.com/incetro/DAO.git"
    spec.license        = "MIT"
    spec.authors        = { "incetro" => "incetro@ya.ru" }
    spec.requires_arc   = true
    spec.swift_version  = "5.2"

    spec.ios.deployment_target     = "12.0"
    spec.osx.deployment_target     = "10.15"
    spec.watchos.deployment_target = "3.0"
    spec.tvos.deployment_target    = "12.4"

    spec.source                 = { git: "https://github.com/incetro/DAO.git", tag: "#{spec.version}"}
    spec.source_files           = "Sources/SDAO/**/*.{h,swift}"

    spec.dependency "Monreau" 
end
