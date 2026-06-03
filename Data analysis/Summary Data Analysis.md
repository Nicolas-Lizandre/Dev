**Big Data**
- Implemented a distributed pipeline in Apache Spark to process a text corpus from Project Gutenberg. Built a resilient RDD, applied parallel transformations, then converted it into a DataFrame to construct an Inverted Index. 
- Developed an RDD of Wikimedia logs and analyzed the most frequent words in page titles. Benchmarked performance across RDD, DataFrame, and SparkSQL, highlighting the gains provided by the Catalyst optimizer.

**Graphs**
- Implemented high pass, band pass, and low pass filters using a spectral GNN, then performed spatial filtering with a Vanilla GNN in PyTorch. Applied the models to a connected graph generated with NetworkX and to a 95×95 image converted into a graph. 
- Performed 384 dimensional vector search on a 100,000 element dataset using Faiss. Benchmarked HNSW, IVF, IVFPQ, and IVFOPQ, demonstrating: performance gains from centroid based quantization, acceleration from Product Quantization, and improved accuracy through OPQ preprocessing (optimized orthogonal matrix).

**Inferential & Computational Statistics**
- Applied an efficient vectorized Kernel Density Estimator (Scikit Learn) to estimate a Gaussian mixture. Assessed performance with respect to bandwidth and sample size.
- Optimized the Rosenbrock function using gradient based methods (constant and optimal step size). Analyzed the influence of learning rate and conditioning on convergence.
- Performed goodness of fit tests with SciPy to assess hypotheses about the underlying distribution of a given sample.

**Machine Learning**
- Built a linear regression model (closed form and gradient descent) to analyze the relationship between life expectancy and explanatory variables. Evaluated the model using R², residual analysis (Scale Location), influence measures (Cook’s distance), and an F test to validate statistical assumptions. 
- Implemented KNN, SVM, and Random Forest classifiers with Scikit Learn to predict life expectancy from socio economic variables. Evaluated models using AUC ROC and associated curves. Improved performance through class weight tuning and, for SVM, kernel selection (linear, RBF).

**Signal processing**
- Implemented baseband modulation schemes including BPSK (Binary Phase Shift Keying) with comprehensive signal analysis and constellation diagram visualization.
- Developed complex baseband equivalent representation for 16-QAM modulation.
- Created a composite audio signal processing chain featuring multi-stage filtering, equalization, and real-time audio manipulation using NumPy and SciPy.
- Built SLIT (System Linear Invariant Time) analysis tools for audio sequences, including impulse response characterization and convolution-based filtering demonstrations.
- Implemented chirp signal generation and analysis, exploring frequency-swept waveforms with applications to radar and sonar signal processing.

**Time Series**
- Evaluated the performance of anomaly detectors (STOMP, IsolationForest, KMeansAD, LOF, OneClassSVM, PyODAdapter(CBLOF)) using sensitivity related metrics on a training dataset (Aeon.datasets).
- Developed a time series classification pipeline: DTW KNN, KNN on PyCatch22 features (Euclidean distance), then PyTorch models (linear network and CNN) trained on raw sequences. Evaluated performance using accuracy.



