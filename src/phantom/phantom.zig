const std = @import("std");

// Tipo de variables base para la API de windows

pub const BOOL = c_int;
pub const BOOLEAN = u8;
pub const SIZE_T = usize;
pub const UINT = u32;
pub const USHORT = u16;
pub const BYTE = u8;
pub const WORD = u16;
pub const DWORD = u32;
pub const HANDLE = *anyopaque;
pub const HWND = *anyopaque;
pub const PWSTR = ?[*:0]u16;
pub const PVOID = *anyopaque;
pub const LPVOID = ?*anyopaque;
pub const LPCVOID = ?*const anyopaque;
pub const LPWSTR = [*:0]u16;
pub const LPCSTR = [*:0]u8;
pub const LPCWSTR = [*:0]const u16;
pub const LONG = i32;
pub const ULONG = u32;
pub const ULONG_PRT = usize;
pub const NTSTATUS = i32;
pub const KPRIORITY = i32;

pub const TRUE: BOOL = 1;
pub const FALSE: BOOL = 0;

// Punteros a estructuras
pub const PPEB_LDR_DATA = *PEB_LDR_DATA;
pub const PRTL_USER_PROCESS_PARAMETERS = *RTL_USER_PROCESS_PARAMETERS;

// Constantes que pueden servir en CreateProcessW

pub const CREATE_NEW_CONSOLE: DWORD = 0x00000010;
pub const CREATE_NO_WINDOW: DWORD = 0x08000000;
pub const DETACHED_PROCESS: DWORD = 0x00000008;
pub const NORMAL_PRIORITY_CLASS: DWORD = 0x00000020;

// Constantes que pueden servir para VirtualAlloc

pub const MEM_COMMIT: u32 = 0x00001000;
pub const MEM_RESERVE: u32 = 0x00002000;
pub const PAGE_READWRITE: u32 = 0x04;
pub const MEM_RELEASE: u32 = 0x00008000;

// Constantes para OpenProcess

pub const PROCESS_VM_READ: u32 = 0x0010;
pub const PROCESS_VM_WRITE: u32 = 0x0020;
pub const PROCESS_ALL_ACCESS: u32 = 0x001F0FFF;

// Constantes necesarias para NtQueryInformationProcess despues seran mas

pub const ProcessBasicInformation = 0;

// Estructuras necesarias

pub const UNICODE_STRING = extern struct { Length: USHORT, MaximunLength: USHORT, Buffer: PWSTR };

pub const LIST_ENTRY = extern struct { Flink: *LIST_ENTRY, Blink: *LIST_ENTRY };

pub const PEB_LDR_DATA = extern struct {
    Length: ULONG,
    Initialized: BOOLEAN,
    SsHandle: PVOID,
    InLoadOrderModuleList: LIST_ENTRY,
    InMemoryOrderModuleList: LIST_ENTRY,
    InInitializationOrderModuleList: LIST_ENTRY,
    EntryInProgress: PVOID,
    ShutdownInProgress: BOOLEAN,
    ShutdownThreadId: HANDLE,
};

pub const RTL_USER_PROCESS_PARAMETERS = extern struct {
    MaximunLength: ULONG,
    Length: ULONG,
    Flags: ULONG,
    DebugFlags: ULONG,
    ConsoleHandle: HANDLE,
    ConsoleFlags: ULONG,
    StandardInput: HANDLE,
    StandardOutput: HANDLE,
    StandardError: HANDLE,
    CurrentDirectory: CURDIR,
    DllPath: UNICODE_STRING,
    ImagePathName: UNICODE_STRING,
    CommandLine: UNICODE_STRING,
    Environment: PVOID,
};

pub const CURDIR = extern struct {
    DosPath: UNICODE_STRING,
    Handle: HANDLE,
};

// Esta estructura esta incompleta y necesito ajustar algunos type-data en algunos atributos
pub const LDR_DATA_TABLE_ENTRY = extern struct {
    InLoadOrderLinks: LIST_ENTRY,
    InMemoryOrderLinks: LIST_ENTRY,
    InInitializationOrderLinks: LIST_ENTRY,
    DllBase: PVOID,
    EntryPoint: PVOID,
    SizeOfImage: ULONG,
    Padding: [4]u8,
    FullDllName: UNICODE_STRING,
    BaseDllName: UNICODE_STRING,
};

pub const SECURITY_ATTRIBUTES = extern struct {
    nLength: DWORD,
    lpSecurityDescriptor: LPVOID,
    bInheritHandle: BOOL,
};

pub const STARTUPINFOW = extern struct {
    cb: DWORD,
    lpReserved: ?LPWSTR,
    lpDesktop: ?LPWSTR,
    lpTitle: ?LPWSTR,
    dwX: DWORD,
    dwY: DWORD,
    dwXSize: DWORD,
    dwYSize: DWORD,
    dwXCountChars: DWORD,
    dwYCountChars: DWORD,
    dwFillAttribute: DWORD,
    dwFlags: DWORD,
    wShowWindow: WORD,
    cbReserved2: WORD,
    lpReserved2: ?*BYTE,
    hStdInput: ?HANDLE,
    hStdOutput: ?HANDLE,
    hStdError: ?HANDLE,
};

pub const PROCESS_INFORMATION = struct {
    hProcess: HANDLE,
    hThread: HANDLE,
    dwProcessId: DWORD,
    dwThreadId: DWORD,
};

pub const PROCESS_BASIC_INFORMATION = extern struct {
    ExitStatus: NTSTATUS,
    PebBaseAddress: ?*anyopaque,
    AffinityMask: ULONG_PRT,
    BasePriority: KPRIORITY,
    UniqueProcessId: ULONG_PRT,
    InheritedFromUniqueProcessId: ULONG_PRT,
};

pub const PEB = extern struct {
    InheritAddressSpace: BOOLEAN,
    ReadImageFileException: BOOLEAN,
    BeingDebugged: BOOLEAN,
    BitField: BYTE,
    Mutant: HANDLE,
    ImageBaseAddress: PVOID,
    Ldr: PPEB_LDR_DATA,
    ProcessParameters: PRTL_USER_PROCESS_PARAMETERS,
    SubSystemData: PVOID,
    ProcessHeap: HANDLE,
    FastPebLock: PVOID,
    AtlThunkSListPtr: PVOID,
    IFEOKey: PVOID,
    CrossProcessFlags: ULONG,
    UserSharedInfoPtr: PVOID,
    SystemReserved: ULONG,
    ApiSetMap: PVOID,
    TlsExpansionCounter: ULONG,
    TlsBitMap: PVOID,
    TlsBitMapBits: [2]ULONG,
    ReadOnlyShareMemoryBase: PVOID,
    SharedMemoryBinaryId: PVOID,
    ReadOnlyStaticServerData: PVOID,
    AnsiCodePageData: PVOID,
    OemCodePageDataa: PVOID,
    UnicodeCaseTableData: PVOID,
    NumberOfProcessors: ULONG,
    NtGlobalFlag: ULONG,
};

// Estructuras necesarias para el mapeo de las cabeceras de PE

pub const IMAGE_DOS_HEADER = extern struct {
    e_magic: WORD,
    e_cblp: WORD,
    e_cp: WORD,
    e_crlc: WORD,
    e_cparhdr: WORD,
    e_minalloc: WORD,
    e_maxalloc: WORD,
    e_ss: WORD,
    e_sp: WORD,
    e_csum: WORD,
    e_ip: WORD,
    e_cs: WORD,
    e_lfarlc: WORD,
    e_ovno: WORD,
    e_res: [4]WORD,
    e_oemid: WORD,
    e_oeminfo: WORD,
    e_res2: [10]WORD,
    e_lfanew: LONG,
};

pub const IMAGE_EXPORT_DIRECTORY = extern struct { Characteristic: DWORD, TimeDataStamp: DWORD, MajorVersion: WORD, MinorVersion: WORD, Name: DWORD, Base: DWORD, NumberOfFunctions: DWORD, NumberOfNames: DWORD, AddressOfFunctions: DWORD, AddressOfNames: DWORD, AddressOfNameOrdinals: DWORD };
// Funciones de la API de windows

pub extern "kernel32" fn CreateProcessW(
    lpApplicationName: ?LPCWSTR,
    lpCommandLine: ?LPWSTR,
    lpProcessAttributes: ?*SECURITY_ATTRIBUTES,
    lpThreadAttributes: ?*SECURITY_ATTRIBUTES,
    bInheritHandles: BOOL,
    dwCreationFlags: DWORD,
    lpEnvironment: LPVOID,
    lpCurrentDirectory: ?LPCWSTR,
    lpStartupInfo: *STARTUPINFOW,
    lpProcessInformation: *PROCESS_INFORMATION,
) callconv(.winapi) BOOL;

pub extern "kernel32" fn CloseHandle(
    hObject: HANDLE,
) callconv(.winapi) BOOL;

pub extern "kernel32" fn WaitForSingleObject(
    hHandle: HANDLE,
    dwMilliseconds: DWORD,
) callconv(.winapi) DWORD;

pub extern "user32" fn MessageBoxW(hWnd: ?HWND, lpText: LPCWSTR, lpCaption: LPCWSTR, uType: UINT) callconv(.winapi) DWORD;

pub extern "kernel32" fn VirtualAlloc(lpAddress: LPVOID, dwSize: SIZE_T, flAllocationType: DWORD, flProtect: DWORD) callconv(.winapi) LPVOID;

pub extern "kernel32" fn VirtualFree(lpAddress: LPVOID, dwSize: SIZE_T, dwFreeType: DWORD) callconv(.winapi) BOOL;

pub extern "kernel32" fn OpenProcess(dwDesiredAccess: DWORD, bInheritHandle: BOOL, dwProcessId: DWORD) callconv(.winapi) HANDLE;

pub extern "kernel32" fn ReadProcessMemory(hProcess: HANDLE, lpBaseAddress: LPCVOID, lpBuffer: LPVOID, nSize: SIZE_T, lpNumberOfBytesRead: ?*SIZE_T) callconv(.winapi) BOOL;

pub extern "kernel32" fn WriteProcessMemory(hProcess: HANDLE, lpBaseAddress: LPVOID, lpBuffer: LPCVOID, nSize: SIZE_T, lpNumerofBytesWritten: ?*SIZE_T) callconv(.winapi) BOOL;

pub extern "kernel32" fn GetCurrentProcessId() callconv(.winapi) DWORD;

pub extern "kernel32" fn GetLastError() callconv(.winapi) DWORD;

pub extern "ntdll" fn NtQueryInformationProcess(ProcessHandle: HANDLE, ProcessInformationClass: i32, ProcessInformation: PVOID, ProcessInformationLength: ULONG, ReturnLength: ?*ULONG) callconv(.winapi) NTSTATUS;

pub const INFINITE: DWORD = 0xFFFFFFFF;

// Algunos inicializadores para facilitarme la vida

pub fn initStartupInfo() STARTUPINFOW {
    return STARTUPINFOW{
        .cb = @sizeOf(STARTUPINFOW),
        .lpReserved = null,
        .lpDesktop = null,
        .lpTitle = null,
        .dwX = 0,
        .dwY = 0,
        .dwXSize = 0,
        .dwYSize = 0,
        .dwXCountChars = 0,
        .dwYCountChars = 0,
        .dwFillAttribute = 0,
        .dwFlags = 0,
        .wShowWindow = 0,
        .cbReserved2 = 0,
        .lpReserved2 = null,
        .hStdInput = null,
        .hStdOutput = null,
        .hStdError = null,
    };
}

pub fn initProcessInfo() PROCESS_INFORMATION {
    return PROCESS_INFORMATION{
        .hProcess = undefined,
        .hThread = undefined,
        .dwProcessId = undefined,
        .dwThreadId = undefined,
    };
}

// Implementacion de mi propio peb()

pub fn getPEB() *PEB {
    return asm volatile ("movq %%gs:0x60, %[ret]"
        : [ret] "=r" (-> *PEB),
    );
}

// Al final este raro de prueba resulto ser la solucion

pub const VirtualAllocFn = *const fn (lpAddress: LPVOID, dwSize: SIZE_T, flAllocationType: DWORD, flProtect: DWORD) callconv(.winapi) LPVOID;
