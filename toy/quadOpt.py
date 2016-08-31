from __future__ import division
import numpy as np
from cvxopt import matrix, solvers
import sys
import numpy as np
solvers.options['msg_lev'] = 'GLP_MSG_OFF'  # works on cvxopt 1.1.7

def approx_min(A, d, b, k):
    n = len(b)
    ind = np.random.choice(n, k, replace=False)
    #ind = np.arange(n)
    A_sub = A[ind, :][:, ind].copy()
    d_sub = d[ind]
    b_sub = b[ind]

    return ((n / k) ** 2) * qp(A_sub, d_sub, b_sub)

def exact_min(A, d, b):
    return qp(A, d, b)

def qp(A, d, b):
    n = len(b)
    C = (A / n) + np.diag(d)
    G = np.vstack((np.eye(n), -np.eye(n)))  # for [-1,1] constraints
    sol = solvers.qp(matrix(2 * C), matrix(b), matrix(G), matrix(np.ones(2 * n)))
    return n * sol['primal objective']

def generate_data(n):
    A = np.random.uniform(-1, 1, (n, n))
    d = np.random.uniform(0, 1, n)
    b = np.random.uniform(-1, 1, n)
    return A, d, b

if __name__ == '__main__':
    np.random.seed(1)
    
    n = 500
    s = 0.1
    N_trial = 10

    exacts  = np.zeros(N_trial)
    approxs = np.zeros(N_trial)
    for i in xrange(N_trial):
        A = np.random.uniform(-1, 1, (n, n))
        d = np.random.uniform(0, 1, n)
        b = np.random.uniform(-1, 1, n)

        approxs[i] = approx_min(A, d, b, s)
        exacts[i] = exact_min(A, d, b)

    print '\tExact\t\tApprox'
    for i in xrange(N_trial):
        print '%02d\t%.4f\t%.4f' % (i, exacts[i], approxs[i])
    
