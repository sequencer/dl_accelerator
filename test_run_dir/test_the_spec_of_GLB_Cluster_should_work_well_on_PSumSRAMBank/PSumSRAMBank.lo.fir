circuit PSumSRAMBank :
  module PSumSRAMBank :
    input clock : Clock
    input reset : UInt<1>
    output io_dataPath_inIOs_ready : UInt<1>
    input io_dataPath_inIOs_valid : UInt<1>
    input io_dataPath_inIOs_bits : UInt<20>
    input io_dataPath_outIOs_ready : UInt<1>
    output io_dataPath_outIOs_valid : UInt<1>
    output io_dataPath_outIOs_bits : UInt<20>
    input io_ctrlPath_writeOrRead : UInt<1>
    input io_ctrlPath_doEn : UInt<1>
    output io_ctrlPath_done : UInt<1>
    input io_ctrlPath_startIdx : UInt<10>
    output io_debugIO_idx : UInt<10>
    output io_debugIO_idxInc : UInt<1>
    output io_debugIO_idxCount : UInt<10>
    output io_debugIO_currentData : UInt<20>
    output io_debugIO_meetOneZero : UInt<1>
    output io_debugIO_theState : UInt<2>
  
    mem theSRAM : @[GLBCluster.scala 55:57]
      data-type => UInt<20>
      depth => 768
      read-latency => 1
      write-latency => 1
      reader => _T_24
      writer => _T_12
      read-under-write => undefined
    reg waitForRead : UInt<1>, clock with :
      reset => (UInt<1>("h0"), waitForRead) @[GLBCluster.scala 67:44]
    reg nextValidReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), nextValidReg) @[GLBCluster.scala 70:45]
    reg doDoneReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), doDoneReg) @[GLBCluster.scala 71:42]
    node _T_18 = and(io_dataPath_outIOs_ready, nextValidReg) @[GLBCluster.scala 77:35]
    node doReadWire = _T_18 @[GLBCluster.scala 61:40 GLBCluster.scala 77:16]
    node _T = and(doReadWire, waitForRead) @[GLBCluster.scala 72:60]
    node writeOrRead = io_ctrlPath_writeOrRead @[GLBCluster.scala 57:41 GLBCluster.scala 32:15]
    node doEnWire = io_ctrlPath_doEn @[GLBCluster.scala 60:38 GLBCluster.scala 36:12]
    node _T_11 = and(doEnWire, io_dataPath_inIOs_valid) @[GLBCluster.scala 84:29]
    node doWriteWire = _T_11 @[GLBCluster.scala 62:41 GLBCluster.scala 84:17]
    node _T_1 = mux(writeOrRead, doWriteWire, _T) @[GLBCluster.scala 72:22]
    reg _T_4 : UInt<5>, clock with :
      reset => (UInt<1>("h0"), _T_4) @[Counter.scala 29:33]
    node _T_5 = eq(_T_4, UInt<5>("h17")) @[Counter.scala 37:24]
    node _T_6 = add(_T_4, UInt<1>("h1")) @[Counter.scala 38:22]
    node _T_7 = tail(_T_6, 1) @[Counter.scala 38:22]
    node _GEN_0 = mux(_T_5, UInt<1>("h0"), _T_7) @[Counter.scala 40:21]
    node doIdxIncWire = _T_1 @[GLBCluster.scala 68:42 GLBCluster.scala 72:16]
    node _GEN_1 = mux(doIdxIncWire, _GEN_0, _T_4) @[Counter.scala 71:17]
    node _T_8 = and(doIdxIncWire, _T_5) @[Counter.scala 72:20]
    node _T_2 = io_ctrlPath_startIdx @[GLBCluster.scala 25:30 GLBCluster.scala 31:12]
    node _T_9 = add(_T_2, _T_4) @[GLBCluster.scala 37:25]
    node _T_10 = tail(_T_9, 1) @[GLBCluster.scala 37:25]
    node _T_3 = _T_10 @[GLBCluster.scala 26:37 GLBCluster.scala 37:13]
    node _GEN_2 = validif(doIdxIncWire, _T_3) @[GLBCluster.scala 86:25]
    node _GEN_3 = validif(doIdxIncWire, clock) @[GLBCluster.scala 86:25]
    node _GEN_4 = mux(doIdxIncWire, UInt<1>("h1"), UInt<1>("h0")) @[GLBCluster.scala 86:25]
    node _GEN_5 = validif(doIdxIncWire, UInt<1>("h1")) @[GLBCluster.scala 86:25]
    node writeInData = io_dataPath_inIOs_bits @[GLBCluster.scala 63:41 GLBCluster.scala 83:17]
    node _GEN_6 = validif(doIdxIncWire, writeInData) @[GLBCluster.scala 86:25]
    node _T_13 = eq(waitForRead, UInt<1>("h0")) @[GLBCluster.scala 74:56]
    node _T_14 = and(doEnWire, _T_13) @[GLBCluster.scala 74:53]
    node _T_15 = mux(writeOrRead, UInt<1>("h0"), _T_14) @[GLBCluster.scala 74:21]
    node _T_16 = eq(waitForRead, UInt<1>("h0")) @[GLBCluster.scala 75:50]
    node _T_17 = mux(writeOrRead, waitForRead, _T_16) @[GLBCluster.scala 75:23]
    node _T_19 = eq(waitForRead, UInt<1>("h0")) @[GLBCluster.scala 78:54]
    node _T_20 = and(doReadWire, _T_19) @[GLBCluster.scala 78:51]
    node _GEN_7 = validif(_T_20, _T_3) @[GLBCluster.scala 78:32]
    node _T_21 = _GEN_7 @[GLBCluster.scala 78:32 GLBCluster.scala 78:32]
    node _T_22 = or(_T_21, UInt<10>("h0")) @[GLBCluster.scala 78:32]
    node _T_23 = bits(_T_22, 9, 0) @[GLBCluster.scala 78:32]
    node _GEN_8 = mux(_T_20, UInt<1>("h1"), UInt<1>("h0")) @[GLBCluster.scala 78:32]
    node _GEN_9 = validif(_T_20, _T_23) @[GLBCluster.scala 78:32]
    node _GEN_10 = validif(_T_20, clock) @[GLBCluster.scala 78:32]
    node readOutData = theSRAM._T_24.data @[GLBCluster.scala 64:41 GLBCluster.scala 78:17]
    node _T_25 = mux(waitForRead, readOutData, UInt<1>("h0")) @[GLBCluster.scala 79:26]
    node nextValid = _T_15 @[GLBCluster.scala 69:39 GLBCluster.scala 74:15]
    io_dataPath_inIOs_ready <= doWriteWire @[GLBCluster.scala 85:21]
    io_dataPath_outIOs_valid <= nextValidReg @[GLBCluster.scala 76:21]
    io_dataPath_outIOs_bits <= _T_25 @[GLBCluster.scala 79:20]
    io_ctrlPath_done <= doDoneReg @[GLBCluster.scala 33:20]
    io_debugIO_idx <= _T_3 @[GLBCluster.scala 92:17]
    io_debugIO_idxInc <= doIdxIncWire @[GLBCluster.scala 93:20]
    io_debugIO_idxCount <= _T_4 @[GLBCluster.scala 45:25]
    io_debugIO_currentData is invalid
    io_debugIO_meetOneZero is invalid
    io_debugIO_theState is invalid
    theSRAM._T_24.addr <= _GEN_9 @[GLBCluster.scala 78:32]
    theSRAM._T_24.en <= _GEN_8 @[GLBCluster.scala 55:57 GLBCluster.scala 78:32]
    theSRAM._T_24.clk <= _GEN_10 @[GLBCluster.scala 78:32]
    theSRAM._T_12.addr <= _GEN_2
    theSRAM._T_12.en <= _GEN_4 @[GLBCluster.scala 55:57]
    theSRAM._T_12.clk <= _GEN_3
    theSRAM._T_12.data <= _GEN_6
    theSRAM._T_12.mask <= _GEN_5
    waitForRead <= mux(reset, UInt<1>("h0"), _T_17) @[GLBCluster.scala 75:17]
    nextValidReg <= nextValid @[GLBCluster.scala 70:45]
    doDoneReg <= mux(reset, UInt<1>("h0"), _T_8) @[GLBCluster.scala 34:13]
    _T_4 <= mux(reset, UInt<5>("h0"), _GEN_1) @[Counter.scala 38:13 Counter.scala 40:29]