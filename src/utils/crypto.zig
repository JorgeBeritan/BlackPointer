// Ambas funciones son una representacion del algoritmo de hashing DJB2
// Pero una sirve para el hashing de WideString osea utf-16 y otra para string normales
// osea utf-8

pub fn calcHash(buffer: []const u16) u32 {
    // Basicamente con un valor predeterminado que es el 5381
    // Hacemos un left-shift osea movemos 5 bit a la izquiera despues sumamos
    // el modulo del hash y volvemos a sumar el modulo del hash pero en u32
    // en el medio tenemos un pequeño codigo que nos sirve principalmente para
    // convertir el texto en minusculas y asi no hay problemas de capitalize.

    var hash: u32 = 5381;

    for (buffer) |c| {
        var char = c;
        if (char >= 'A' and char <= 'Z') {
            char += 32;
        }
        if (char == 0) break;

        hash = ((hash << 5) +% hash) +% @as(u32, char);
    }

    return hash;
}

pub fn calcHashU8(buffer: []const u8) u32 {
    // Basicamente con un valor predeterminado que es el 5381
    // Hacemos un left-shift osea movemos 5 bit a la izquiera despues sumamos
    // el modulo del hash y volvemos a sumar el modulo del hash pero en u32
    // en el medio tenemos un pequeño codigo que nos sirve principalmente para
    // convertir el texto en minusculas y asi no hay problemas de capitalize.

    var hash: u32 = 5381;
    for (buffer) |c| {
        var char = c;
        if (char >= 'A' and char <= 'Z') {
            char += 32;
        }
        hash = ((hash << 5) +% hash) +% @as(u32, char);
    }
    return hash;
}
