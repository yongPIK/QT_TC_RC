# QT_TC_RC

working title: "Delayed coordinates significantly improve the performance of reservoir computing" 

by 

Kaiwen Jiang, Michael Small, Yong Zou

Nonlinear transformations to the delayed coordinates of reservoir states improve the prediction significantly. 



# Code Documentation for QT‑RC, NG‑RC, TC‑RC and Classical RC

This repository contains four MATLAB implementations for reservoir computing based chaotic time series prediction (Lorenz system).  
Below is a description of the main variables used in each script. Helper functions (`gene_Win`, `gene_Wr`, `poly_terms`, `TC_general`) are assumed to be provided separately.

---

## Common variables (appear in multiple scripts)

| Variable | Description |
|----------|-------------|
| `P_datas` | Raw data loaded from `data_Lorenz.dat` (3 columns). |
| `data` | Transposed `P_datas`; each row is a variable (size: 3 × total_time_steps). |
| `trainLen` | Number of time steps used for training (excluding initialization). |
| `testLen` | Number of time steps used for autonomous prediction testing. |
| `initLen` | Warm‑up length (transient discarded before collecting states). |
| `inSize` | Input dimension (3 for Lorenz). |
| `outSize` | Output dimension (3 for Lorenz). |
| `reg` | Tikhonov regularization parameter (β, ridge parameter). |
| `Wout` | Output weight matrix (size: outSize × feature_dim). |
| `Y` | Predicted output during testing (size: outSize × testLen). |
| `Y_t` | Ground truth for the testing period (size: outSize × testLen). |
| `errorLen` | Number of steps used for error evaluation (= `testLen`). |
| `mse` | Mean squared error (first variable only). |
| `rmse` | Root mean squared error. |
| `pre_length` | Valid prediction time (first time step where relative error > `threshold1`). |
| `threshold1` | Error tolerance ε (set to 0.5). |

---

## 1. QT‑RC (Quadratic Transformed Reservoir Computing)

**File:** `QT_RC.m` (typical)

| Variable | Meaning |
|----------|---------|
| `resSize` | Number of reservoir nodes (M = 10). |
| `add_dim` | Additional input dimension (not used). |
| `delay` | Takens embedding delay τ (e.g., 30 for Lorenz). |
| `lin_num` | Number of delayed copies (embedding dimension m). |
| `RESIZE` | Total feature dimension after quadratic expansion: `resSize*lin_num + resSize*lin_num*(1+resSize*lin_num)/2`. |
| `a` | Leakage rate α (0.1). |
| `W_in_a` | Input weight scaling factor (1). |
| `k` | Average degree (connectivity) used when generating `W`. |
| `eig_rho` | Spectral radius ρ of reservoir matrix (0.2 for QT‑RC in paper). |
| `W_in_type` | Type of input weight initialization (1 = uniform random). |
| `W_r_type` | Type of reservoir weight initialization (1 = sparse random). |
| `Win` | Input weight matrix (size: resSize × inSize). |
| `W` | Reservoir internal weight matrix (size: resSize × resSize). |
| `X` | Collected reservoir states after `initLen` (size: resSize × (trainLen‑initLen)). |
| `X_ts` | Feature matrix after delay and quadratic expansion (size: RESIZE × number_of_training_points). |
| `Yt` | Target output matrix (ground truth) for training. |
| `x` | Current reservoir state vector (size: resSize × 1). |
| `X_T` | Transpose of `X_ts` (used in ridge regression). |
| `u` | Current input; in testing it is fed back from output. |

---

## 2. NG‑RC (Next Generation Reservoir Computing)

**File:** `NG_RC.m` (typical)

| Variable | Meaning |
|----------|---------|
| `init0` | Extra initial steps to discard before building feature vectors. |
| `initLen` | Total warm‑up length = `(k-1)*s + init0`. |
| `k` | Number of past time steps used (linear delay count). |
| `s` | Delay interval (skip between consecutive delayed points). |
| `index` | Polynomial order (e.g., 2 for quadratic, 3 for cubic). |
| `num_index` | Number of polynomial terms: `nchoosek(inSize*k + index - 1, index)`. |
| `resSize` | Feature dimension = `1 + inSize*k + num_index`. |
| `X` | Feature matrix (each column is a feature vector at one time step). |
| `x_lin` | Linear delayed input vector (size: inSize × k). |
| `phi` | Polynomial terms (returned by `poly_terms`). |
| `x_nonlin` | Polynomial feature vector (transpose of `phi`). |
| `Wout` | Output weight matrix computed by ridge regression. |
| `Y` | Predicted output. |
| `data1` | Copy of `data` used during testing for feedback (to avoid overwriting original). |

---

## 3. TC‑RC (Temporal Convolution Reservoir Computing)

**File:** `TC_RC.m` (typical)

| Variable | Meaning |
|----------|---------|
| `resSize` | Number of reservoir nodes (usually 100). |
| `add_dim` | Not used. |
| `gap` | Time difference (step) between consecutive points used in convolution (default 1). |
| `convolution_num` | Number of points used in each convolution step (typically 2). |
| `lin_num` | Number of delayed copies (embedding dimension m). |
| `delay` | Time delay τ (e.g., 30 for Lorenz). |
| `index` | Number of convolution layers / iteration count. |
| `RESIZE` | Feature dimension after hierarchical convolution: `(index+1)*lin_num*resSize - (convolution_num-1)*gap*index*(1+index)/2`. |
| `a` | Leakage rate (0.1). |
| `W_in_a` | Input scaling (1). |
| `k` | Average connectivity for reservoir generation. |
| `eig_rho` | Spectral radius ρ (e.g., -0.48 for TC‑RC). |
| `Win` | Input weight matrix. |
| `W` | Reservoir weight matrix. |
| `X` | Collected reservoir states (size: resSize × (trainLen‑initLen)). |
| `X_ts` | Feature matrix after delay and convolution operations. |
| `x_lin` | Linear delayed reservoir states (concatenated). |
| `x_nonlin` | Nonlinear features obtained by repeatedly applying `TC_general`. |
| `TC_general` | User‑defined function performing temporal convolution (hierarchical product). |
| `Yt` | Target output. |
| `Wout` | Output weight matrix. |
| `Y` | Predicted output. |

---

## 4. Classical Reservoir Computing (RC)

**File:** `classical_RC.m` (typical)

| Variable | Meaning |
|----------|---------|
| `resSize` | Number of reservoir nodes (e.g., 100). |
| `add_dim` | Not used. |
| `a` | Leakage rate (0.1). |
| `W_in_a` | Input scaling (1). |
| `k` | Average connectivity for reservoir generation. |
| `eig_rho` | Spectral radius (e.g., 1.01). |
| `Win` | Input weight matrix. |
| `W` | Reservoir weight matrix. |
| `X` | Collected reservoir states (size: resSize × (trainLen‑initLen)). |
| `Yt` | Target output. |
| `Wout` | Output weight matrix (size: outSize × resSize). |
| `x` | Current reservoir state vector. |
| `Y` | Predicted output (autonomous). |

---

## Helper functions (to be provided)

- **`gene_Win(resSize, inSize, add_dim, W_in_a, type)`**  
  Generates the input weight matrix `Win` according to the specified type.
- **`gene_Wr(resSize, k, eig_rho, type)`**  
  Generates the reservoir weight matrix `W` with given average degree `k` and spectral radius `eig_rho`.
- **`poly_terms(x_lin, index)`**  
  Returns all polynomial terms (up to order `index`) of the vector `x_lin` as a row vector.  
  Used in NG‑RC.
- **`TC_general(state, gap, conv_num)`**  
  Performs temporal convolution operation on the input state vector.  
  Used in TC‑RC to create hierarchical nonlinear features.

---

**Notes**  
- All scripts normalize each variable (x, y, z) by its maximum absolute value before processing.  
- The random seeds are not fixed in the provided code; for reproducibility consider adding `rng('default')` or a fixed seed.  
- Plotting sections are commented out but can be enabled for visualisation.
