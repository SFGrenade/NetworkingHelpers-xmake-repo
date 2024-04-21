package("boostnng")
    set_homepage("https://github.com/SFGrenade/BoostNng-Cpp/")
    set_description("A helper to use zeromq and protobuf together")
    set_license("MPL-2.0")

    set_urls("https://github.com/SFGrenade/BoostNng-Cpp/archive/refs/tags/v$(version).tar.gz",
             "https://github.com/SFGrenade/BoostNng-Cpp.git")

    add_deps("boost")
    add_deps("nng")

    on_install("windows", "macosx", "linux", function (package)
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test() {
                BoostNng::ReqRep network( "tcp://127.0.0.1:13337", false );
                network.run();
            }
        ]]}, {configs = {languages = "c++17"}, includes = "boostNng/reqRep.hpp"}))
    end)
