;buildInfoPackage: chisel3, version: 3.3-SNAPSHOT, scalaVersion: 2.12.10, sbtVersion: 1.3.2
circuit PSumSRAMBank : 
  module PSumSRAMBank : 
    input clock : Clock
    input reset : UInt<1>
    output io : {dataPath : {flip inIOs : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<20>}, outIOs : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<20>}}, ctrlPath : {flip writeOrRead : UInt<1>, flip doEn : UInt<1>, done : UInt<1>, flip startIdx : UInt<10>}, debugIO : {idx : UInt<10>, idxInc : UInt<1>, idxCount : UInt<10>, currentData : UInt<20>, meetOneZero : UInt<1>, theState : UInt<2>, waitForRead : UInt<1>, doReadWire : UInt<1>}}
    
    smem onePSumSRAMBank : UInt<20>[768] @[GLBCluster.scala 131:57]
    wire writeOrRead : UInt<1> @[GLBCluster.scala 133:41]
    wire doEnWire : UInt<1> @[GLBCluster.scala 136:38]
    wire doReadWire : UInt<1> @[GLBCluster.scala 137:40]
    wire doWriteWire : UInt<1> @[GLBCluster.scala 138:41]
    wire writeInData : UInt<20> @[GLBCluster.scala 139:41]
    wire readOutData : UInt<20> @[GLBCluster.scala 140:41]
    reg waitForRead : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[GLBCluster.scala 143:44]
    wire doIdxIncWire : UInt<1> @[GLBCluster.scala 144:42]
    wire nextValid : UInt<1> @[GLBCluster.scala 145:39]
    reg nextValidReg : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[GLBCluster.scala 146:45]
    reg doDoneReg : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[GLBCluster.scala 147:42]
    node _T = and(doReadWire, waitForRead) @[GLBCluster.scala 148:60]
    node _T_1 = mux(writeOrRead, doWriteWire, _T) @[GLBCluster.scala 148:22]
    doIdxIncWire <= _T_1 @[GLBCluster.scala 148:16]
    wire _T_2 : UInt<10> @[GLBCluster.scala 101:30]
    wire _T_3 : UInt<10> @[GLBCluster.scala 102:37]
    reg _T_4 : UInt<5>, clock with : (reset => (reset, UInt<5>("h00"))) @[Counter.scala 29:33]
    when doIdxIncWire : @[Counter.scala 71:17]
      node _T_5 = eq(_T_4, UInt<5>("h017")) @[Counter.scala 37:24]
      node _T_6 = add(_T_4, UInt<1>("h01")) @[Counter.scala 38:22]
      node _T_7 = tail(_T_6, 1) @[Counter.scala 38:22]
      _T_4 <= _T_7 @[Counter.scala 38:13]
      when _T_5 : @[Counter.scala 40:21]
        _T_4 <= UInt<1>("h00") @[Counter.scala 40:29]
        skip @[Counter.scala 40:21]
      skip @[Counter.scala 71:17]
    node _T_8 = and(doIdxIncWire, _T_5) @[Counter.scala 72:20]
    _T_2 <= io.ctrlPath.startIdx @[GLBCluster.scala 107:12]
    writeOrRead <= io.ctrlPath.writeOrRead @[GLBCluster.scala 108:15]
    io.ctrlPath.done <= doDoneReg @[GLBCluster.scala 109:20]
    doDoneReg <= _T_8 @[GLBCluster.scala 110:13]
    doEnWire <= io.ctrlPath.doEn @[GLBCluster.scala 112:12]
    node _T_9 = add(_T_2, _T_4) @[GLBCluster.scala 113:25]
    node _T_10 = tail(_T_9, 1) @[GLBCluster.scala 113:25]
    _T_3 <= _T_10 @[GLBCluster.scala 113:13]
    writeInData <= io.dataPath.inIOs.bits @[GLBCluster.scala 163:17]
    node _T_11 = and(doEnWire, io.dataPath.inIOs.valid) @[GLBCluster.scala 164:29]
    doWriteWire <= _T_11 @[GLBCluster.scala 164:17]
    io.dataPath.inIOs.ready <= doWriteWire @[GLBCluster.scala 165:21]
    when doIdxIncWire : @[GLBCluster.scala 166:24]
      write mport _T_12 = onePSumSRAMBank[_T_3], clock
      _T_12 <= writeInData
      skip @[GLBCluster.scala 166:24]
    node _T_13 = eq(waitForRead, UInt<1>("h00")) @[GLBCluster.scala 151:56]
    node _T_14 = and(doEnWire, _T_13) @[GLBCluster.scala 151:53]
    node _T_15 = mux(writeOrRead, UInt<1>("h00"), _T_14) @[GLBCluster.scala 151:21]
    nextValid <= _T_15 @[GLBCluster.scala 151:15]
    node _T_16 = and(nextValid, io.dataPath.outIOs.ready) @[GLBCluster.scala 152:31]
    nextValidReg <= _T_16 @[GLBCluster.scala 152:18]
    node _T_17 = eq(_T_8, UInt<1>("h00")) @[GLBCluster.scala 155:24]
    node _T_18 = eq(doEnWire, UInt<1>("h00")) @[GLBCluster.scala 155:56]
    node _T_19 = or(writeOrRead, _T_18) @[GLBCluster.scala 155:53]
    node _T_20 = eq(waitForRead, UInt<1>("h00")) @[GLBCluster.scala 155:80]
    node _T_21 = mux(_T_19, waitForRead, _T_20) @[GLBCluster.scala 155:40]
    node _T_22 = mux(_T_17, _T_21, UInt<1>("h00")) @[GLBCluster.scala 155:23]
    waitForRead <= _T_22 @[GLBCluster.scala 155:17]
    io.dataPath.outIOs.valid <= nextValidReg @[GLBCluster.scala 156:21]
    node _T_23 = and(io.dataPath.outIOs.ready, nextValidReg) @[GLBCluster.scala 157:35]
    doReadWire <= _T_23 @[GLBCluster.scala 157:16]
    node _T_24 = eq(waitForRead, UInt<1>("h00")) @[GLBCluster.scala 158:54]
    node _T_25 = and(doReadWire, _T_24) @[GLBCluster.scala 158:51]
    wire _T_26 : UInt @[GLBCluster.scala 158:32]
    _T_26 is invalid @[GLBCluster.scala 158:32]
    when _T_25 : @[GLBCluster.scala 158:32]
      _T_26 <= _T_3 @[GLBCluster.scala 158:32]
      node _T_27 = or(_T_26, UInt<10>("h00")) @[GLBCluster.scala 158:32]
      node _T_28 = bits(_T_27, 9, 0) @[GLBCluster.scala 158:32]
      read mport _T_29 = onePSumSRAMBank[_T_28], clock @[GLBCluster.scala 158:32]
      skip @[GLBCluster.scala 158:32]
    readOutData <= _T_29 @[GLBCluster.scala 158:17]
    node _T_30 = mux(waitForRead, readOutData, UInt<1>("h00")) @[GLBCluster.scala 159:26]
    io.dataPath.outIOs.bits <= _T_30 @[GLBCluster.scala 159:20]
    io.debugIO.idx <= _T_3 @[GLBCluster.scala 172:17]
    io.debugIO.idxInc <= doIdxIncWire @[GLBCluster.scala 173:20]
    io.debugIO.waitForRead <= waitForRead @[GLBCluster.scala 174:25]
    io.debugIO.doReadWire <= doReadWire @[GLBCluster.scala 175:24]
    io.debugIO.idxCount <= _T_4 @[GLBCluster.scala 121:25]
    io.debugIO.currentData is invalid @[GLBCluster.scala 122:28]
    io.debugIO.meetOneZero is invalid @[GLBCluster.scala 123:28]
    io.debugIO.theState is invalid @[GLBCluster.scala 124:25]
    
