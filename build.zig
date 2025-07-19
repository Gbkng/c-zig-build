const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});


    // The `.cache` directory is needed for generation of cdb files. Those files
    // are required for generation of the `compile_commands.json`.
    try std.fs.cwd().makePath(".cache");

    const cc_flags = &.{
        "-std=c23",
        "-Wall",
        "-Wextra",
        "-Werror",
        // below is for generation of compile_commands.json
        // ref: https://github.com/ziglang/zig/issues/9323#issuecomment-1646590552
        "-gen-cdb-fragment-path",
        ".cache/cdb",
    };

    const foolib = b.addLibrary(.{
        .linkage = .static,
        .name = "foo",
        .root_module = b.createModule(.{
            .root_source_file = null,
            .target = target,
            .optimize = optimize,
        }),
    });
    foolib.addCSourceFiles(.{
        .files = &.{
            "src/foo.c",
        },
        .flags = cc_flags,
    });
    b.installArtifact(foolib);

    const exe = b.addExecutable(.{
        .name = "main",
        .target = target,
        .optimize = optimize,
    });
    exe.addCSourceFiles(.{
        .files = &.{
            "src/bin/main.c",
        },
        .flags = cc_flags,
    });
    exe.addIncludePath(b.path("src"));
    exe.linkSystemLibrary("ncurses");
    exe.linkLibrary(foolib);
    exe.linkLibC();
    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}
