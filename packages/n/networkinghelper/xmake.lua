package("networkinghelper")
    set_homepage("https://github.com/SFGrenade/NetworkingHelper/")
    set_description("A helper to use zeromq and protobuf together")
    set_license("MPL-2.0")

    set_urls("https://github.com/SFGrenade/NetworkingHelper-Cpp/archive/refs/tags/v$(version).tar.gz",
             "https://github.com/SFGrenade/NetworkingHelper-Cpp.git")

    add_versions("0.2", "fdaaae8d3348aebcd4d53db40db1191c5f432eeffb6bcc76a216a95987f88d83")

    add_deps("bitsery")
    add_deps("nng")

    add_configs("shared", {description = "Build shared library.", default = true, type = "boolean", readonly = true})

    on_load("windows", "macosx", "linux", function (package)
        if package:gitref() or package:version():gt("0.2") then
            package:add("deps", "hedley")
        end
        if package:config("shared") then
            package:add("defines", "NETWORKINGHELPER_IS_SHARED")
        end
    end)

    on_install("windows", "macosx", "linux", function (package)
        local configs = {
            kind = package:config("shared") and "shared" or "static",
        }
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        if package:gitref() or package:version():ge("0.2") then
            assert(package:check_cxxsnippets({test = [[
                void test() {
                    NetworkingHelper::ReqRep network( "tcp://127.0.0.1:13337", false );
                    network.run();
                }
            ]]}, {configs = {languages = "c++14"}, includes = "networkingHelper/reqRep.hpp"}))
        else
            assert(package:check_cxxsnippets({test = [[
                void test() {
                    NetworkingHelper::ReqRep network( "tcp://127.0.0.1", 13337, false );
                    network.run();
                }
            ]]}, {configs = {languages = "c++14"}, includes = "networkingHelper/reqRep.hpp"}))
        end
    end)
