const std = @import("std");
const crypt = @import("utils/crypto.zig");
const resolver = @import("evasion/api_resolver.zig");
const VirtualAllocFn = @import("phantom/phantom.zig").VirtualAllocFn;
const phantom = @import("phantom/phantom.zig");
const kernel32 = @import("evasion/obfuscation.zig").Kernel32Hash;
const VirtualAllocHash = @import("evasion/obfuscation.zig").VirtualAllocHash;

pub fn main() !void {
    //var stdout: std.fs.File.Writer = std.fs.File.stdout().writer(&.{});
    //const writer: *std.Io.Writer = &stdout.interface;

    const addr_kernel = resolver.pebWalking(kernel32);
    const pVirtualAlloc = resolver.getProcAddresByHash(addr_kernel.?, VirtualAllocHash);

    if (pVirtualAlloc) |func| {
        //try writer.print("Direccion Cruda: 0x{x}\n", .{@intFromPtr(func)});

        const VirtualAlloc = @as(VirtualAllocFn, @ptrCast(func));
        const shellcode_len: usize = 1024;

        const allocated_mem = VirtualAlloc(null, shellcode_len, phantom.MEM_COMMIT | phantom.MEM_RESERVE, phantom.PAGE_READWRITE);

        if (allocated_mem) |mem| {
            _ = mem;
            //try writer.print("\n [SUCCESS] Memoria alojada en: 0x{x}\n", .{@intFromPtr(mem)});
        } else {
            //try writer.print("\n[ERROR] VirtualAllocFallo\n", .{});
        }
    }
}
