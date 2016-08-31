from __future__ import division
import sys
import datetime
import numpy as np
sys.path.insert(0, '../')
import quadOpt

def to_seconds_float(timedelta):
    """Calculate floating point representation of combined
    seconds/microseconds attributes in :param:`timedelta`.

    :raise ValueError: If :param:`timedelta.days` is truthy.

        >>> to_seconds_float(datetime.timedelta(seconds=1, milliseconds=500))
        1.5
    """
    return timedelta.seconds + timedelta.microseconds / 1E6 \
        + timedelta.days * 86400

def print_res(coef, time):
    print ' '.join(sys.argv[1:]), coef, time

n = int(sys.argv[1])
k = int(sys.argv[2])
s = int(sys.argv[3])
method = sys.argv[4]

np.random.seed(s)
A, d, b = quadOpt.generate_data(n)

start = datetime.datetime.now()
if method == "approx":
    ans = quadOpt.approx_min(A, d, b, k)
elif method == "exact":
    ans = quadOpt.exact_min(A, d, b)

elapsed = to_seconds_float(datetime.datetime.now() - start)
print_res(ans, elapsed)
    

