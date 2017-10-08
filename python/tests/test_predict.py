from nose.tools import *
from python.dmdtools.batch import *
from python.dmdtools.predict import predict


def test_Atilde_predict(w=0.25, n=1000):
    x = np.array([np.sin(w * np.arange(n)), np.cos(w * np.arange(n))])
    print(x[:, 2], x[:, 1].dot(dmd_object._Atilde))
    print(x[:, 512], x[:, 511].dot(dmd_object._Atilde))
    dmd_object = DMD(exact=True, total=False)  # exact, standard
    dmd_object = dmd_object.fit(x)
    print("Transition matrix:\n", dmd_object._Atilde)
    print(x[:, 1], x[:, 0].dot(dmd_object._Atilde))


def test_tls_predict(n_rank=None, w=0.25, n=1000):
    x = np.array([np.sin(w * np.arange(n)), np.cos(w * np.arange(n)), -np.cos(w * np.arange(n))])
    dmd_object = DMD(n_rank=n_rank, exact=False, total=True)
    dmd_object = dmd_object.fit(x)
    print("Transition matrix:\n", dmd_object._Atilde)
    evals, modes = sort_modes_evals(dmd_object)
    Ybar = predict(x, evals, modes).astype(float)
    print("Original:\n", x[:, 2:5])
    print("Predicted:\n", Ybar[:, 1:4])
    print("isequal:", np.all(np.isclose(x[:, 1:n], Ybar[:, 0:(n - 1)])))
