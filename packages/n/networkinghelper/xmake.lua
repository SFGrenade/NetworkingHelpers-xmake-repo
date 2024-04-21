package("networkinghelper")
    set_homepage("https://github.com/SFGrenade/NetworkingHelper-Cpp/")
    set_description("A helper to use nng and bitsery together")
    set_license("MPL-2.0")

    set_urls("https://github.com/SFGrenade/NetworkingHelper-Cpp/archive/refs/tags/v$(version).tar.gz",
             "https://github.com/SFGrenade/NetworkingHelper-Cpp.git")

    add_versions("0.2", "fdaaae8d3348aebcd4d53db40db1191c5f432eeffb6bcc76a216a95987f88d83")

    add_deps("bitsery")
    add_deps("nng")

    on_install("windows", "macosx", "linux", function (package)
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test() {
                NetworkingHelper ::ReqRep network( "tcp://127.0.0.1:13337", false );
                network.run();
            }
        ]]}, {configs = {languages = "c++17"}, includes = "networkingHelper/reqRep.hpp"}))
    end)
