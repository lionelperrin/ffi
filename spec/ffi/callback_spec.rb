require File.expand_path(File.join(File.dirname(__FILE__), "spec_helper"))

describe "Callback" do
#  module LibC
#    extend FFI::Library
#    callback :qsort_cmp, [ :pointer, :pointer ], :int
#    attach_function :qsort, [ :pointer, :int, :int, :qsort_cmp ], :int
#  end
#  it "arguments get passed correctly" do
#    p = MemoryPointer.new(:int, 2)
#    p.put_array_of_int32(0, [ 1 , 2 ])
#    args = []
#    cmp = proc do |p1, p2| args.push(p1.get_int(0)); args.push(p2.get_int(0)); 0; end
#    # this is a bit dodgey, as it relies on qsort passing the args in order
#    LibC.qsort(p, 2, 4, cmp)
#    args.should == [ 1, 2 ]
#  end
#
#  it "Block can be substituted for Callback as last argument" do
#    p = MemoryPointer.new(:int, 2)
#    p.put_array_of_int32(0, [ 1 , 2 ])
#    args = []
#    # this is a bit dodgey, as it relies on qsort passing the args in order
#    LibC.qsort(p, 2, 4) do |p1, p2|
#      args.push(p1.get_int(0))
#      args.push(p2.get_int(0))
#      0
#    end
#    args.should == [ 1, 2 ]
#  end
  module LibTest
    extend FFI::Library
    ffi_lib TestLibrary::PATH
    callback :cbVrS8, [ ], :char
    callback :cbVrU8, [ ], :uchar
    callback :cbVrS16, [ ], :short
    callback :cbVrU16, [ ], :ushort
    callback :cbVrS32, [ ], :int
    callback :cbVrU32, [ ], :uint
    callback :cbVrS64, [ ], :long_long
    callback :cbVrU64, [ ], :ulong_long
    callback :cbVrP, [], :pointer
    callback :cbCrV, [ :char ], :void
    callback :cbSrV, [ :short ], :void
    callback :cbIrV, [ :int ], :void
    callback :cbLrV, [ :long_long ], :void
    attach_function :testCallbackVrS8, :testClosureVrB, [ :cbVrS8 ], :char
    attach_function :testCallbackVrU8, :testClosureVrB, [ :cbVrU8 ], :uchar
    attach_function :testCallbackVrS16, :testClosureVrS, [ :cbVrS16 ], :short
    attach_function :testCallbackVrU16, :testClosureVrS, [ :cbVrU16 ], :ushort
    attach_function :testCallbackVrS32, :testClosureVrI, [ :cbVrS32 ], :int
    attach_function :testCallbackVrU32, :testClosureVrI, [ :cbVrU32 ], :uint
    attach_function :testCallbackVrS64, :testClosureVrL, [ :cbVrS64 ], :long_long
    attach_function :testCallbackVrU64, :testClosureVrL, [ :cbVrU64 ], :ulong_long
    attach_function :testCallbackVrP, :testClosureVrP, [ :cbVrP ], :pointer
    attach_function :testCallbackCrV, :testClosureBrV, [ :cbCrV, :char ], :void
    attach_variable :cbVrS8, :gvar_pointer, :cbVrS8
    attach_variable :pVrS8, :gvar_pointer, :pointer
    attach_function :testGVarCallbackVrS8, :testClosureVrB, [ :pointer ], :char

  end
  it "function with Callback plus another arg should raise error if no arg given" do
    lambda { LibTest.testCallbackCrV { |*a| }}.should raise_error
  end
  it "Callback returning :char (0)" do
    LibTest.testCallbackVrS8 { 0 }.should == 0
  end
  it "Callback returning :char (127)" do
    LibTest.testCallbackVrS8 { 127 }.should == 127
  end
  it "Callback returning :char (-128)" do
    LibTest.testCallbackVrS8 { -128 }.should == -128
  end
  # test wrap around
  it "Callback returning :char (128)" do
    LibTest.testCallbackVrS8 { 128 }.should == -128
  end
  it "Callback returning :char (255)" do
    LibTest.testCallbackVrS8 { 0xff }.should == -1
  end
  it "Callback returning :uchar (0)" do
    LibTest.testCallbackVrU8 { 0 }.should == 0
  end
  it "Callback returning :uchar (0xff)" do
    LibTest.testCallbackVrU8 { 0xff }.should == 0xff
  end
  it "Callback returning :uchar (-1)" do
    LibTest.testCallbackVrU8 { -1 }.should == 0xff
  end
  it "Callback returning :uchar (128)" do
    LibTest.testCallbackVrU8 { 128 }.should == 128
  end
  it "Callback returning :uchar (-128)" do
    LibTest.testCallbackVrU8 { -128 }.should == 128
  end
  it "Callback returning :short (0)" do
    LibTest.testCallbackVrS16 { 0 }.should == 0
  end
  it "Callback returning :short (0x7fff)" do
    LibTest.testCallbackVrS16 { 0x7fff }.should == 0x7fff
  end
  # test wrap around
  it "Callback returning :short (0x8000)" do
    LibTest.testCallbackVrS16 { 0x8000 }.should == -0x8000
  end
  it "Callback returning :short (0xffff)" do
    LibTest.testCallbackVrS16 { 0xffff }.should == -1
  end
  it "Callback returning :ushort (0)" do
    LibTest.testCallbackVrU16 { 0 }.should == 0
  end
  it "Callback returning :ushort (0x7fff)" do
    LibTest.testCallbackVrU16 { 0x7fff }.should == 0x7fff
  end
  it "Callback returning :ushort (0x8000)" do
    LibTest.testCallbackVrU16 { 0x8000 }.should == 0x8000
  end
  it "Callback returning :ushort (0xffff)" do
    LibTest.testCallbackVrU16 { 0xffff }.should == 0xffff
  end
  it "Callback returning :ushort (-1)" do
    LibTest.testCallbackVrU16 { -1 }.should == 0xffff
  end

  it "Callback returning :int (0)" do
    LibTest.testCallbackVrS32 { 0 }.should == 0
  end
  it "Callback returning :int (0x7fffffff)" do
    LibTest.testCallbackVrS32 { 0x7fffffff }.should == 0x7fffffff
  end
  # test wrap around
  it "Callback returning :int (-0x80000000)" do
    LibTest.testCallbackVrS32 { -0x80000000 }.should == -0x80000000
  end
  it "Callback returning :int (-1)" do
    LibTest.testCallbackVrS32 { -1 }.should == -1
  end

  it "Callback returning :uint (0)" do
    LibTest.testCallbackVrU32 { 0 }.should == 0
  end
  it "Callback returning :uint (0x7fffffff)" do
    LibTest.testCallbackVrU32 { 0x7fffffff }.should == 0x7fffffff
  end
  # test wrap around
  it "Callback returning :uint (0x80000000)" do
    LibTest.testCallbackVrU32 { 0x80000000 }.should == 0x80000000
  end
  it "Callback returning :uint (0xffffffff)" do
    LibTest.testCallbackVrU32 { 0xffffffff }.should == 0xffffffff
  end
  it "Callback returning :uint (-1)" do
    LibTest.testCallbackVrU32 { -1 }.should == 0xffffffff
  end

  it "Callback returning :long_long (0)" do
    LibTest.testCallbackVrS64 { 0 }.should == 0
  end
  it "Callback returning :long_long (0x7fffffffffffffff)" do
    LibTest.testCallbackVrS64 { 0x7fffffffffffffff }.should == 0x7fffffffffffffff
  end
  # test wrap around
  it "Callback returning :long_long (-0x8000000000000000)" do
    LibTest.testCallbackVrS64 { -0x8000000000000000 }.should == -0x8000000000000000
  end
  it "Callback returning :long_long (-1)" do
    LibTest.testCallbackVrS64 { -1 }.should == -1
  end
  it "Callback returning :pointer (nil)" do
    LibTest.testCallbackVrP { nil }.null?.should be_true
  end
  it "Callback returning :pointer (MemoryPointer)" do
    p = MemoryPointer.new :long
    LibTest.testCallbackVrP { p }.should == p
  end

  it "Callback global variable" do
    proc = Proc.new { 0x1e }
    LibTest.cbVrS8 = proc
    LibTest.testGVarCallbackVrS8(LibTest.pVrS8).should == 0x1e
  end
end
describe "Callback with primitive argument" do
  #
  # Test callbacks that take an argument, returning void
  #
  module LibTest
    extend FFI::Library
    ffi_lib TestLibrary::PATH
    callback :cbS8rV, [ :char ], :void
    callback :cbU8rV, [ :uchar ], :void
    callback :cbS16rV, [ :short ], :void
    callback :cbU16rV, [ :ushort ], :void
    callback :cbS32rV, [ :int ], :void
    callback :cbU32rV, [ :uint ], :void
    callback :cbS64rV, [ :long_long ], :void
    attach_function :testCallbackCrV, :testClosureBrV, [ :cbS8rV, :char ], :void
    attach_function :testCallbackU8rV, :testClosureBrV, [ :cbU8rV, :uchar ], :void
    attach_function :testCallbackSrV, :testClosureSrV, [ :cbS16rV, :short ], :void
    attach_function :testCallbackU16rV, :testClosureSrV, [ :cbU16rV, :ushort ], :void
    attach_function :testCallbackIrV, :testClosureIrV, [ :cbS32rV, :int ], :void
    attach_function :testCallbackU32rV, :testClosureIrV, [ :cbU32rV, :uint ], :void
    attach_function :testCallbackLrV, :testClosureLrV, [ :cbS64rV, :long_long ], :void
  end
  it "Callback with :char (0) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackCrV(0) { |i| v = i }
    v.should == 0
  end
  it "Callback with :char (127) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackCrV(127) { |i| v = i }
    v.should == 127
  end
  it "Callback with :char (-128) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackCrV(-128) { |i| v = i }
    v.should == -128
  end
  it "Callback with :char (-1) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackCrV(-1) { |i| v = i }
    v.should == -1
  end

  it "Callback with :uchar (0) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU8rV(0) { |i| v = i }
    v.should == 0
  end
  it "Callback with :uchar (127) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU8rV(127) { |i| v = i }
    v.should == 127
  end
  it "Callback with :uchar (128) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU8rV(128) { |i| v = i }
    v.should == 128
  end
  it "Callback with :uchar (255) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU8rV(255) { |i| v = i }
    v.should == 255
  end

  it "Callback with :short (0) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackSrV(0) { |i| v = i }
    v.should == 0
  end
  it "Callback with :short (0x7fff) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackSrV(0x7fff) { |i| v = i }
    v.should == 0x7fff
  end
  it "Callback with :short (-0x8000) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackSrV(-0x8000) { |i| v = i }
    v.should == -0x8000
  end
  it "Callback with :short (-1) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackSrV(-1) { |i| v = i }
    v.should == -1
  end

  it "Callback with :ushort (0) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU16rV(0) { |i| v = i }
    v.should == 0
  end
  it "Callback with :ushort (0x7fff) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU16rV(0x7fff) { |i| v = i }
    v.should == 0x7fff
  end
  it "Callback with :ushort (0x8000) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU16rV(0x8000) { |i| v = i }
    v.should == 0x8000
  end
  it "Callback with :ushort (0xffff) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU16rV(0xffff) { |i| v = i }
    v.should == 0xffff
  end

  it "Callback with :int (0) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackIrV(0) { |i| v = i }
    v.should == 0
  end
  it "Callback with :int (0x7fffffff) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackIrV(0x7fffffff) { |i| v = i }
    v.should == 0x7fffffff
  end
  it "Callback with :int (-0x80000000) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackIrV(-0x80000000) { |i| v = i }
    v.should == -0x80000000
  end
  it "Callback with :int (-1) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackIrV(-1) { |i| v = i }
    v.should == -1
  end

  it "Callback with :uint (0) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU32rV(0) { |i| v = i }
    v.should == 0
  end
  it "Callback with :uint (0x7fffffff) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU32rV(0x7fffffff) { |i| v = i }
    v.should == 0x7fffffff
  end
  it "Callback with :uint (0x80000000) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU32rV(0x80000000) { |i| v = i }
    v.should == 0x80000000
  end
  it "Callback with :uint (0xffffffff) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackU32rV(0xffffffff) { |i| v = i }
    v.should == 0xffffffff
  end

  it "Callback with :long_long (0) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackLrV(0) { |i| v = i }
    v.should == 0
  end
  it "Callback with :long_long (0x7fffffffffffffff) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackLrV(0x7fffffffffffffff) { |i| v = i }
    v.should == 0x7fffffffffffffff
  end
  it "Callback with :long_long (-0x8000000000000000) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackLrV(-0x8000000000000000) { |i| v = i }
    v.should == -0x8000000000000000
  end
  it "Callback with :long_long (-1) argument" do
    v = 0xdeadbeef
    LibTest.testCallbackLrV(-1) { |i| v = i }
    v.should == -1
  end
  
end unless true
