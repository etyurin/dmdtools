import numpy as np
from numpy.linalg import pinv


def predict(x, evals, modes, steps=1):
    """ Starting with x, predict system evolution steps steps. """
    if steps > 1:
        evals = evals ** steps

    b = pinv(modes).dot(x)
    if b.ndim == 1:
        return modes.dot(b*evals)
    else:
        return modes.dot(np.diag(evals).dot(b))
