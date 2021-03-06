# Deep Learning Accelerator Based On Eyeriss V2 with Extend Custom RISC-V Instructions

This project is a deep learning accelerator implementation in Chisel. The architecture of the accelerator is based on Eyeriss v2.

And it will extend some custom RISC-V instructions in the near future.

## TODO

You can find more at [the project page](https://github.com/SingularityKChen/dl_accelerator/projects/1).

- [X] Implementation of Processing Elements

- [X] Test file of PE

- [ ] Add a PE test using FIFO

- [ ] Add a PE test with input partial sum

- [ ] Add a PE test with continuous zero columns in weight matrix

- [ ] Software analysis based on Eyexam

- [ ] Implementation of PE Cluster

- [ ] Implementation of GLB Cluster

- [ ] Implementation of Router Cluster

- [ ] Implementation of NoC level

- [ ] Test of NoC level

- [ ] Implementation of Global Buffer level

- [ ] Test of GB level

- [ ] Implementation of DRAM level

- [ ] Test of DRAM level

- [ ] Custom instruction

- [ ] ...

## Known Bugs

+ Meet continuous zero columns in weight matrix;

## [Elaboration](./src/main/scala)

### [Processing Element](./src/main/scala/pe)

This is the fundamental component of deep learning accelerator.

![Eyeriss v2 PE Architecture. The address SPad for both iact and weight are used to store addr vector in the CSC compressed data, while the data SPad stores the data and count vectors](https://images-cdn.shimo.im/Zj7Aa6YzIis6Fhxs/image.png)

#### ProcessingElementControl

This is the control module of PE.

#### ProcessingElementPad

This is the Scratch Pad of input feature map, filter weight and partial sum. It contains seven stages.

#### [Scratch Pad Module](./src/main/scala/pe/SPadModule.scala)

This file contains the template of Scratch Pad module with simple read and write function.

#### [PEIOs](./src/main/scala/pe/PEIOs.scala)

This file contains all the IOs we need to use in Processing Element module. Including some sub IOs.

##### PETopDebugIO

This is used for debug at PE top level. It generates two sub IOs to get the signal through from control module and Scratch Pad modle.

##### PEControlDebugIO

This is used for monitoring control module to top module.

+ peState: know the state of the state machine, idle, load or calculation;
+ doMACEnDebug: this signal can be seen as the start signal of MAC, so we need to keep an eye on it;

##### PESPadDebugIO

This is used for monitoring Scratch Pad module.

+ iactMatrixData: input activations matrix element;
+ iactMatrixRow: input activations matrix row index;
+ iactMatrixColumn: input activations matrix column index, also the column index of output partial sum;
+ iactAddrInc: true then the index of input activation address vector will increase;
+ iactDataInc: true then the index of input activation data and count vector will increase;
+ iactAddrIdx: the index number of input activation address vector;
+ weightAddrSPadReadOut: this is the current value read from weight address vector;
+ weightMatrixData: weight matrix element;
+ weightMatrixRow: weight matrix row index, also the row index of output partial sum;
+ productResult: `iactMatrixData * weightMatrixData`;
+ pSumLoad: the corresponding partial sum produced previous;
+ pSumResult: `productResult + pSumLoad`;
+ weightAddrInIdx: the weight address vector index;
+ sPadState: the state of Scratch Pad state machine, i.e., MAC process;

#### [PE Config](./src/main/scala/pe/PEConfig.scala)

This is the config file for PE generator.

##### SPadSizeConfig

Contains the size of five scratch pads.

##### PESizeConfig

Contains some more general configs.

+ weightHeight: the height of weight;
+ ofmapHeight: the height of output feature map (output partial sum);
+ iactDataWidth: input activations data width in scratch pad, it is the combination of 8-bit data vector and its corresponding 4-bit count vector;
+ iactAddrWidth: input activations address width in scratch pad, i.e., the width of address vector element;
+ weightDataWidth:
+ weightAddrWidth:
+ cscDataWidth: compressed sparse column data vector width, used for get the real element of iact and weight;
+ cscCountWidth: csc count vector width;
+ psDataWidth: data width of partial sum;
+ fifoSize: the size of FIFO;
+ fifoEn: true then generate a PE with FIFOs;
+ commonLenWidth: used for get the length of data vector, address vector.
+ weightDataLenWidth: used for get the length of weight data vector;
+ iactZeroColumnCode: used for judge whether current iact column is a zero column, default is the last number it can express;
+ weightZeroColumnCode: used for judge whether current weight column is a zero column, default is the last number it can express;

##### MCRENFConfig

Used for data reuse.


### [Cluster](./src/main/scala/cluster)

#### [Cluster Group](./src/main/scala/cluster/ClusterGroup.scala)

This is the top module of cluster group. It contains one GLB cluster, one Router cluster, one PE cluster.

#### [GLB Cluster](./src/main/scala/cluster/GLBCluster.scala)

This is the global buffer cluster module. It contains three input activation SRAM bank, four partial sum SRAM bank.

#### [PE Cluster](./src/main/scala/cluster/PECluster.scala)

This is the processing element cluster module. It is a PE Array which contains `peArrayColumnNum` columns and `peArrayRowNum` rows.

#### [Router Cluster](./src/main/scala/cluster/RouterCluster.scala)

This is the router cluster module. It contains `iactRouterNum` input activations router, `weightRouterNum` weight router, `pSumRouterNum` partial sum router.

Each router cluster not only connects to one GLB cluster, one PE cluster, but also at least one another router cluster.

##### IactRouter

This class is the generator of one input activations router.


- InIOs\(0\): the input activation comes from its corresponding input activations SRAM back;
- InIOs\(1\): the input activation comes from its northern iact router;
- InIOs\(2\): the input activation comes from its southern iact router;
- InIOs\(3\): the input activation comes from its horizontal iact router;
- OutIOs\(0\): send the input activation to PE Array;
- OutIOs\(1\): send the input activation to northern iact router;
- OutIOs\(2\): send the input activation to southern iact router;
- OutIOs\(3\): send the input activation to horizontal iact router;
- outSelWire: 0: unicast, 1: horizontal, 2: vertical, 3: broadcast

##### WeightRouter

This class is the generator of one weight router.

- inIOs\(0\): the weight comes from its corresponding GLB Cluster;
- inIOs\(1\): the weight comes from its only horizontal neighboring WeightRouter;
- OutIOs\(0\): send the data to its corresponding PE Array row;
- OutIOs\(1\): send the data to its only horizontal neighboring WeightRouter;
- inSelWire: 0 enables inIOs\(0\) and 1 enables inIOs\(1\)
- OutSelWire: 0 enables outIOs\(0\) and 1 enables outIOs\(1\)

##### PSumRouter

This class is the generator of one partial sum router.

- inIOs\(0\): the output partial sum computed by its corresponding PE Array column;
- inIOs\(1\): the partial sum read from its corresponding partial sum SRAM bank;
- inIOs\(2\): the partial sum transferred from its northern neighboring PSumRouter;
- OutIOs\(0\): send the partial sum to its corresponding PE Array column;
- OutIOs\(1\): send the partial sum back to its corresponding partial sum SRAM bank;
- OutIOs\(2\): send the partial sum to its southern neighboring PSumRouter;
- inSelWire: its value enable the corresponding inIOs, i.e., 0 enables inIOs\(0\)
- outSelWire: its value enable the corresponding outIOs, i.e., 0 enables outIOs\(0\)

#### [Cluster Config](./src/main/scala/cluster/ClusterConfig.scala)

This file contains some basic static parameters needed in the Cluster Group.

## [Tests](./src/test/scala)

This directory contains all the test files.

### [PE Test](./src/test/scala/petest)

This directory contains PE test files.

#### [PE Spec Test](./src/test/scala/petest/ProcessingElementSpecTest.scala)

This is the main body of PE test, including spec test from top level to Scratch Pad level.

#### [CSC Format Data R/W Test](./src/test/scala/petest/SimplyCombineAddrDataSPad.scala)

This is one fundamental scratch pad module to test the read and write with CSC format data.

### [Cluster Tets](./src/test/scala/clustertest)

This directory contains cluster test files.

## Compressed Sparse Column Data Format

Compressed Sparse Column is a data format used to jump zero-element MAC.

The CSC format used in this project is a little different from the original one.

![Example of compressing sparse weights with compressed sparse column (CSC) coding](https://images-cdn.shimo.im/dwf3TL2QC4EdrmXJ/image.png)

The picture above shows the one used in Eyeriss V2, but in this project it changes.

+ I used Zero Column Code to represent a zero column instead of repeat the value of next address vector element;
+ I used the row number in original matrix instead of the real 'count' vector;

Although it will decrease the size of matrix column with a pseudo-count vector, it is much simpler.
