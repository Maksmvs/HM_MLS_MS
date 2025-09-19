import numpy as np
from alibi_detect.cd import MMDDrift

# Еталонні дані (імітація, у реалі - з історичних логів)
X_ref = np.random.randn(100, 4)

# Ініціалізація дрейф-детектора
cd = MMDDrift(X_ref, p_val=.05)

def drift_detector(features):
    x = np.array(features).reshape(1, -1)
    preds = cd.predict(x)
    return preds["data"]["is_drift"]
