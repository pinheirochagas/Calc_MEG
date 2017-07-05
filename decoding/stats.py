#Libraries
from scipy import stats
from scipy.stats import wilcoxon
from scipy.stats import mannwhitneyu


# Define custom wilcoxon
def _my_wilcoxon(X):
    out = wilcoxon(X)
    return out[1]


def _my_mannwhitneyu(X):
    out = mannwhitneyu(X)
    return out[1]