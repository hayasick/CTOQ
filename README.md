# CTOQ

Codes for reproducing the experiments of:

Kohei Hayashi, Yuichi Yoshida. [Minimizing Quadratic Functions in Constant Time.](http://arxiv.org/abs/1608.07179) To appear in NIPS 2016.

## Numerical Simulation
Reproducing Figure 1.

### Requirements

 * python 2.X
  * numpy
  * cvxopt >= 1.1.7
 * R 
  * ggplot2
  * plyr
  * reshape2
  * grid
 
### Usage
```
make all
make plot
```
Then ``toy_error.eps`` will be generated.

## Kernel Methods
Reproducing Tables 1 and 2.

### Requirements

 * octave or matlab
 * R
  * plyr
  * reshape2
  * xtable
  
### Usage
```
make all
make table
```
Then ``kernel_error.tex`` and ``kernel_time.tex`` will be generated.

If you use matlab instead of octave, replace ``make XX`` as ``make XX BIN=matlab``.

## Acknowledgment
We thank Makoto Yamada for allowing to modify and upload his [RuLSIF codes](http://www.makotoyamada-ml.com/RuLSIF.html).

