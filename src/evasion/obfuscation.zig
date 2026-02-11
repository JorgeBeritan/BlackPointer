// Por ahora solo guardamos el valor de los hashes de lo que precisamos
// Principalmente lo hacemos asi para que el binario final nunca tenga
// strings que puedan delatar que funciones estamos usando asi evadimos las firmas.

pub const Kernel32Hash: u32 = 1883303541;
pub const VirtualAllocHash: u32 = 1490734039;
